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
#import <SVProgressHUD/SVProgressHUD.h>

@interface PIDStatusViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *statusButton;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) BOOL isEnableSend;
@property (nonatomic, strong) NSMutableArray *RSSIs;
@property (nonatomic, strong) NSMutableArray *leaveRSSIs;
//@property (nonatomic, strong) NSDate *startTime;
//@property (nonatomic, strong) NSDate *endTime;
//@property (nonatomic, strong) NSMutableArray *usingTimes;

- (void)commonInit;
- (void)prepareBluetooth;

@end

@implementation PIDStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.RSSIs = [[NSMutableArray alloc] init];
    self.leaveRSSIs = [[NSMutableArray alloc] init];
//    self.usingTimes = [[NSMutableArray alloc] init];
    self.isEnableSend = YES;
    [self commonInit];
    [self prepareBluetooth];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
        make.top.equalTo(self.distanceLabel.mas_bottom).offset(PIDRealHeight(58));
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.statusButton];
    [self.statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(PIDRealHeight(-40));
        make.centerX.equalTo(self.view);
    }];
}

- (void)prepareBluetooth
{
    BLEData *bleData = [BLEData new];
//    NSDictionary *passwordDict = [bleData passwordDict];
    PIDBindDevice *bindedDevice = [bleData bindedDevice];
    [[BLE shared] scan];
    [[BLE shared] whenFindBindedBluetooth:^(BLEDevice *device) {
        if (device.distance.doubleValue < PIDLOCKDISTANCE) {
            if ([bindedDevice.UUID isEqualToString:device.UUID]) {
                if (bindedDevice.password.length > 0) {
                    [[BLE shared] connect:device];
                }
            }
        }
    }];
    [[BLE shared] whenConnectSuccess:^{
        self.nameLabel.text = [BLE shared].currentDevice.peripheral.name;
    }];
    [[BLE shared] whenUpdateService:^(CBService *service) {
        // 更新服务（characteristic）
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"BB00"]]) {
                [BLE shared].characteristicWrite = characteristic;
            } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"BB11"]]) {
                [[BLE shared].currentDevice.peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }];
    [[BLE shared] whenUpdateRSSI:^(NSNumber *RSSI) {
        float average = [self averageRSSI:RSSI];
        NSString *rssi = @"/RSSI";
        NSString *str =  [NSString stringWithFormat:@"%.1f /RSSI", average];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(str.length - rssi.length, rssi.length)];
        self.distanceLabel.attributedText = attr;
        
        if (average > PIDLOCKRSSI) {
//            if ([BLE shared].currentDevice.isLocked) {
//                [self unlock];
//            }
            [self unlock];
        } else {
//            if (![BLE shared].currentDevice.isLocked) {
//                [self lock];
//            }
            [self lock];
        }
    }];
    [[BLE shared] whenReceiveData:^(NSData *data) {
        if ([data isEqualToData:bleData.unlockSuccessData]) {
            self.isEnableSend = YES;
            [BLE shared].currentDevice.isLocked = NO;
//            [SVProgressHUD showSuccessWithStatus:@"解锁成功"];
        } else if ([data isEqualToData:bleData.unlockFailureData]) {
//            [self logEndTime];
            self.isEnableSend = YES;
            [BLE shared].currentDevice.isLocked = YES;
            [self unlock];
        } else if ([data isEqualToData:bleData.lockSuccessData]) {
            self.isEnableSend = YES;
            [BLE shared].currentDevice.isLocked = YES;
//            [SVProgressHUD showSuccessWithStatus:@"锁定成功"];
        } else if ([data isEqualToData:bleData.lockFailureData]) {
            self.isEnableSend = YES;
            [BLE shared].currentDevice.isLocked = NO;
            [self lock];
        } else if ([data isEqualToData:bleData.unbindData]) {
            [self didUnbind];
        } else if ([data isEqualToData:bleData.unbindSuccessData]) {
            [self didUnbind];
        } else if ([data isEqualToData:bleData.unconnectData]) {
            [[BLE shared] unconnect];
            [[BLE shared] emptyBlock];
            [self prepareBluetooth];
            self.distanceLabel.text = @" ";
            self.nameLabel.text = @"已断开";
        }
    }];
}

- (void)unlock {
    BLEData *bleData = [BLEData new];
    NSString *password = [bleData bindedDevice].password;
    NSMutableData *unlockData = [[NSMutableData alloc] init];
    [unlockData appendData:bleData.unlockData];
    [unlockData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    if (self.isEnableSend) {
        self.isEnableSend = NO;
    }
    [[BLE shared] send:bleData.lightScreenData];
    [[BLE shared] send:unlockData];
}

- (void)lock {
   BLEData *bleData = [BLEData new];
    if (self.isEnableSend) {
        self.isEnableSend = NO;
    }
    [[BLE shared] send:bleData.lockData];
}

//- (void)logStartTime {
//    self.startTime = [NSDate new];
//}
//
//- (void)logEndTime {
//    if (self.startTime) {
//        self.endTime = [NSDate new];
//        NSTimeInterval interval = [self.endTime timeIntervalSinceDate:self.startTime];
//        [self.usingTimes addObject:@(interval)];
//        if (self.usingTimes.count == 10) {
//            NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//            NSString *uuid = [NSUUID UUID].UUIDString;
//            NSString *filePath = [cachePatch stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",uuid]];
//            [self.usingTimes writeToFile:filePath atomically:YES];
//            [self.usingTimes removeAllObjects];
//        }
//    }
//    self.startTime = nil;
//}

- (void)unbind
{
    BLEData *bleData = [BLEData new];
    [[BLE shared] send:bleData.unbindData];
    if (![BLE shared].currentDevice) {
        [self didUnbind];
    }
}

- (void)didUnbind {
    BLEData *bleData = [BLEData new];
    [bleData removeBindedDevice];
    [[BLE shared] unconnect];
    [[BLE shared] emptyBlock];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
        _distanceLabel.font = [UIFont systemFontOfSize:PIDRealWidth(32)];
        _distanceLabel.textAlignment = NSTextAlignmentCenter;
        _distanceLabel.textColor = [UIColor colorWithWhite:1 alpha:0.9];
        _distanceLabel.text = @" ";//占位
    }
    return _distanceLabel;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:PIDRealWidth(22)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    }
    return _nameLabel;
}

- (UIButton *)statusButton{
    if(!_statusButton){
        _statusButton = [UIButton new];
        [_statusButton setImage:[UIImage imageNamed:@"status_btn"] forState:UIControlStateNormal];
        [_statusButton addTarget:self action:@selector(unbind) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusButton;
}

- (float)averageOfSaved {
    double RSSISum = 0;
    for (BLERSSI *bleRSSI in self.RSSIs) {
        RSSISum += bleRSSI.RSSI.floatValue;
    }
    float average = RSSISum/self.RSSIs.count;
    return average;
}

- (void)removeTimeoutRSSI {
    [self.leaveRSSIs enumerateObjectsUsingBlock:^(BLERSSI *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isTimeout) {
            [self.leaveRSSIs removeObject:obj];
            NSLog(@"剔除超时异常值");
        }
    }];
}

- (void)appendRealtimeRSSI:(BLERSSI *)bleRSSI {
    if (self.RSSIs.count == 5) {
        [self.RSSIs removeObjectAtIndex:0];
    }
    [self.RSSIs addObject:bleRSSI];
}

- (float)averageRSSI:(NSNumber *)RSSI {
    
    float averageSaved = [self averageOfSaved];
    BLERSSI *bleRSSI = [[BLERSSI alloc] init];
    bleRSSI.RSSI = RSSI;
    if (RSSI.floatValue < averageSaved*1.3) {
        [self.leaveRSSIs addObject:bleRSSI];
    }
    [self removeTimeoutRSSI];
    if (self.leaveRSSIs.count > 3) {
        if (self.RSSIs.count > 3) {
            [self.RSSIs removeObjectsInRange:NSMakeRange(0, 3)];
        }
        for (BLERSSI *bleRSSI in self.leaveRSSIs) {
            NSLog(@"加入一个 RSSI*1.3 的值:%.1f",bleRSSI.RSSI.floatValue);
        }
        [self.RSSIs addObjectsFromArray:self.leaveRSSIs];
        [self.leaveRSSIs removeAllObjects];
    } else {
        [self appendRealtimeRSSI:bleRSSI];
    }
    float averageNew = [self averageOfSaved];
    NSLog(@"平均RSSI:%.1f RSSI:%.1f", averageNew, RSSI.floatValue);
    return averageNew;
}

@end
