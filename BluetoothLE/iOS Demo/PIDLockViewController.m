//
//  ViewController.m
//  iOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "PIDLockViewController.h"
#import <BluetoothLE/BluetoothLE.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface PIDLockViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) BOOL isConnected;

@end

@implementation PIDLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Phone ID";
    self.titles = @[@"锁定 Mac", @"解锁 Mac"];
    [self.view addSubview:self.tableView];

    self.isConnected = YES;
    
    BLEDevice *device = [BLE shared].currentDevice;
    BLEData *bleData = [BLEData new];
    NSDictionary *passwordDict = [bleData passwordDict];
    [[BLE shared] scan];
    [[BLE shared] whenFindBindedBluetooth:^(BLEDevice *device) {
        if (device.distance.doubleValue < PIDLOCKDISTANCE) {
            NSString *password = passwordDict[device.peripheral.identifier.UUIDString];
            if (password.length > 0) {
                [[BLE shared] connect:device];
            }
        }
    }];
    [[BLE shared] whenConnectSuccess:^{
        self.title = [NSString stringWithFormat:@"已连接:%@",[BLE shared].currentDevice.peripheral.name];
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
        float distance = [BLEDevice distanceWithRSSI:RSSI].floatValue;
        NSString *state = @"";
        if (distance <= PIDLOCKDISTANCE) {
            if ([BLE shared].currentDevice.isLocked) {
                [self unlock];
                state = @"解锁中";
                NSLog(@"解锁中");
            }
        } else {
            if (![BLE shared].currentDevice.isLocked) {
                [[BLE shared] send:bleData.lockData];
                state = @"锁定中";
                NSLog(@"锁定中");
            }
        }
        self.title = [NSString stringWithFormat:@"%.2f m %@", distance, state];
    }];
    [[BLE shared] whenReceiveData:^(NSData *data) {
        if ([data isEqualToData:bleData.unlockSuccessData]) {
            NSLog(@"解锁成功");
            [BLE shared].currentDevice.isLocked = NO;
            [SVProgressHUD showSuccessWithStatus:@"解锁成功"];
        } else if ([data isEqualToData:bleData.unlockFailureData]) {
            
            [BLE shared].currentDevice.isLocked = YES;
            [self unlock];
        } else if ([data isEqualToData:bleData.lockSuccessData]) {
            NSLog(@"锁定成功");
            [BLE shared].currentDevice.isLocked = YES;
            [SVProgressHUD showSuccessWithStatus:@"锁定成功"];
        } else if ([data isEqualToData:bleData.lockFailureData]) {
            
            [BLE shared].currentDevice.isLocked = NO;
            [[BLE shared] send:bleData.lockData];
        }
    }];
}

- (void)unlock {
    BLEDevice *device = [BLE shared].currentDevice;
    BLEData *bleData = [BLEData new];
    NSString *password = [bleData passwordWithUUID:device.peripheral.identifier.UUIDString];
    NSMutableData *unlockData = [[NSMutableData alloc] init];
    [unlockData appendData:bleData.unlockData];
    [unlockData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
    [[BLE shared] send:unlockData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = self.isConnected ? [UIColor blackColor] : [UIColor grayColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLEData *data = [BLEData new];
    if (indexPath.row == 0) {
        [[BLE shared] send:data.lockData];
    } else if (indexPath.row == 1) {
        [[BLE shared] send:data.unlockData];
    }
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

@end
