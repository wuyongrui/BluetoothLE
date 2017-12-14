//
//  ViewController.m
//  macOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "ViewController.h"
#import <BluetoothLE/BluetoothLE.h>
#import "LockManager.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [LockManager lock];
    [[BLE shared] scan];
    sleep(10);
    [LockManager unlock:@"mtdp"];
    [[BLE shared] whenFindBluetooth:^(BLEDevice *BLE) {
        // 扫描的的蓝牙
        NSLog(@"name:%@ uuid:%@ advertisement:%@", BLE.peripheral.name, BLE.peripheral.identifier.UUIDString, BLE.advertisementData);
        if ([[BLE.peripheral identifier].UUIDString isEqualToString:@"167FEB01-EC51-4CE8-B086-448FD0F888F0"]) {
            
        }
    }];
    [[BLE shared] whenFindBluetoothAll:^(NSDictionary *peripheralDict) {
        // 扫描到的蓝牙列表
        // 连接蓝牙
//        [[BLE shared] connect:peripheralDict.allValues.firstObject];
//        NSLog(@"dict:%@", peripheralDict);
    }];
    [[BLE shared] whenConnectSuccess:^{
        // 连接成功
    }];
    [[BLE shared] whenConnectFailure:^{
        // 连接失败
    }];
    [[BLE shared] whenUpdateService:^(CBService *service) {
        // 更新服务（characteristic）
    }];
    [[BLE shared] send:[[NSData alloc] init]];
    [[BLE shared] whenSendProgressUpdate:^(NSNumber *progress) {
        // 数据发送进度
    }];
    [[BLE shared] whenSendSuccess:^{
        // 数据发送成功
    }];
    [[BLE shared] whenSendFailure:^{
        // 数据发送失败
    }];
    [[BLE shared] whenReceiveData:^(NSData *data) {
        // 接收到蓝牙返回的数据
    }];
    [[BLE shared] unconnect];
    [[BLE shared] whenUnconnect:^{
        // 已断开
    }];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
