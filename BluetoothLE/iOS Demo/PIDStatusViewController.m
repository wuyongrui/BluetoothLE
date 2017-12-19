//
//  PIDStatusViewController.m
//  iOS Demo
//
//  Created by Robin on 2017/12/19.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDStatusViewController.h"
#import "PIDMacro.h"
#import <Masonry.h>
#import <BluetoothLE/BluetoothLE.h>

@interface PIDStatusViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *statusButton;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)commonInit;
- (void)prepareBluetooth;

@end

@implementation PIDStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commonInit];
    [self prepareBluetooth];
}

- (void)commonInit
{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PIDRealHeight(240));
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLabel.mas_bottom).offset(PIDRealHeight(55));
        make.centerX.equalTo(self.view);
    }];    [self.view addSubview:self.statusButton];
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(PIDRealHeight(-40));
        make.centerX.equalTo(self.view);
    }];
}

- (void)prepareBluetooth
{
//    BLEData *bleData = [BLEData new];
//    NSDictionary *passwordDict = [bleData passwordDict];
//    [[BLE shared] scan];
//    [[BLE shared] whenFindBindedBluetooth:^(BLEDevice *device) {
//        if (device.distance.doubleValue < PIDLOCKDISTANCE) {
//            NSString *password = passwordDict[device.peripheral.identifier.UUIDString];
//            if (password.length > 0) {
//                [[BLE shared] connect:device];
//            }
//        }
//    }];
    [[BLE shared] whenConnectSuccess:^{
        self.nameLabel.text = [BLE shared].currentDevice.peripheral.name;
    }];
    [[BLE shared] whenUpdateService:^(CBService *service) {

    }];
    [[BLE shared] whenUpdateRSSI:^(NSNumber *RSSI) {
        float distance = [BLEDevice distanceWithRSSI:RSSI].floatValue;
        NSString *str =  [NSString stringWithFormat:@"%.2f /m", distance];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(str.length - 3, 3)];
        self.distanceLabel.attributedText = attr;
    }];
    [[BLE shared] whenReceiveData:^(NSData *data) {

    }];
}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"status_bg"]];
        _backgroundImageView.frame = self.view.bounds;
    }
    return _backgroundImageView;
}

- (UILabel *)distanceLabel{
    if(!_distanceLabel){
        _distanceLabel = [UILabel new];
        _distanceLabel.font = [UIFont systemFontOfSize:45];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        _distanceLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
    }
    return _distanceLabel;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:22];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    }
    return _nameLabel;
}

- (UIButton *)statusButton{
    if(!_statusButton){
        _statusButton = [UIButton new];
        [_statusButton setImage:[UIImage imageNamed:@"status_btn"] forState:UIControlStateNormal];
    }
    return _statusButton;
}

@end
