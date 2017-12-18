//
//  PIDSearchViewController.m
//  iOS Demo
//
//  Created by Robin on 2017/12/17.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDSearchViewController.h"
#import <BluetoothLE/BluetoothLE.h>
#import "PIDBindViewController.h"
#import "PIDOperationViewController.h"
#import "PIDMacro.h"

@interface PIDSearchViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UILabel *warnLabel;

- (void)commonInit;
- (void)prepareBlueTooth;
- (void)startLoading;
//- (void)endLoading;//optional
//- (void)alertConnectOption;//optional
    
@end

@implementation PIDSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commonInit];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self prepareBlueTooth];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self startLoading];
}

- (void)commonInit
{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.loadingImageView];
    [self.view addSubview:self.searchLabel];
    [self.view addSubview:self.warnLabel];
}

- (void)startLoading
{
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 2;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    [self.loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)prepareBlueTooth
{
    [[BLE shared] scan];
    [[BLE shared] whenFindBluetoothAll:^(NSDictionary *deviceDict) {
        // 扫描到的蓝牙列表
        NSLog(@"devices:%@", deviceDict);
        NSSortDescriptor *distanceDes = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
        NSArray<BLEDevice *> *devices = [deviceDict.allValues sortedArrayUsingDescriptors:@[distanceDes]];
        if (devices.firstObject.distance.doubleValue < 0.5) {
            [[BLE shared] connect:devices.firstObject];
        }
    }];
    [[BLE shared] whenUpdateService:^(CBService *service) {
        // 更新服务（characteristic）
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"BB00"]]) {
                [BLE shared].characteristicWrite = characteristic;
                NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:[BLE shared].currentDevice.peripheral.identifier.UUIDString];
                if (password.length > 0) {
                    UINavigationController *operationNC = [[UINavigationController alloc] initWithRootViewController:[[PIDOperationViewController alloc] init]];
                    [self.navigationController presentViewController:operationNC animated:YES completion:nil];
                } else {
                    BLEData *bleData = [BLEData new];
                    [[BLE shared] send:bleData.bindData];
                    [self presentBindVC];
                }
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"BB11"]]) {
                [[BLE shared].currentDevice.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }];
}

- (void)presentBindVC
{
    UINavigationController *bindNC = [[UINavigationController alloc] initWithRootViewController:[[PIDBindViewController alloc] init]];
    bindNC.navigationBar.hidden = YES;
    [self.navigationController presentViewController:bindNC animated:YES completion:nil];
}
    
#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
        _backgroundImageView.frame = self.view.bounds;
    }
    return _backgroundImageView;
}

- (UIImageView *)loadingImageView
{
    if (!_loadingImageView) {
        UIImage *img = [UIImage imageNamed:@"quanquan"];
        _loadingImageView = [[UIImageView alloc] initWithImage:img];
        CGSize size = CGSizeMake(img.size.width * PIDRealWidth(1.7), img.size.height * PIDRealWidth(1.7));
        _loadingImageView.frame = CGRectMake((self.view.frame.size.width - size.width)/2., PIDRealHeight(207), size.width, size.height);
    }
    return _loadingImageView;
}

- (UILabel *)searchLabel
{
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PIDRealHeight(410), self.view.frame.size.width, 15)];
        _searchLabel.font = [UIFont systemFontOfSize:14];
        _searchLabel.textAlignment = NSTextAlignmentCenter;
        _searchLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        _searchLabel.text = @"设备搜索中...";
    }
    return _searchLabel;
}

- (UILabel *)warnLabel
{
    if (!_warnLabel) {
        _warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PIDRealHeight(600), self.view.frame.size.width, 50)];
        _warnLabel.font = [UIFont systemFontOfSize:18];
        _warnLabel.textAlignment = NSTextAlignmentCenter;
        _warnLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _warnLabel.numberOfLines = 0;
        _warnLabel.text = @"无法连接\n至您的设备?";
    }
    return _warnLabel;
}

@end
