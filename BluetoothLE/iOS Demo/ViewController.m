//
//  ViewController.m
//  iOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "ViewController.h"
#import <BluetoothLE/BluetoothLE.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BLE shared] scan];
    [[BLE shared] whenFindBluetooth:^(CBPeripheral *peripheral) {
        // 扫描的的蓝牙
    }];
    [[BLE shared] whenFindBluetoothAll:^(NSDictionary *peripheralDict) {
        // 扫描到的蓝牙列表
        // 连接蓝牙
        [[BLE shared] connect:peripheralDict.allValues.firstObject];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
