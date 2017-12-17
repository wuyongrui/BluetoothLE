//
//  ViewController.m
//  macOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "ViewController.h"
#import "BLEBroadcast.h"

@interface ViewController()

@property (nonatomic, strong) BLEBroadcast *broadcast;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [[BLE shared] scan];
//    [[BLE shared] whenFindBluetooth:^(BLEDevice *device) {
//        // 扫描的的蓝牙
//        NSLog(@"name:%@ uuid:%@ advertisement:%@", device.peripheral.name, device.peripheral.identifier.UUIDString, device.advertisementData);
//        if ([[device.peripheral identifier].UUIDString isEqualToString:@"167FEB01-EC51-4CE8-B086-448FD0F888F0"]) {
//
//        }
//    }];
//    [[BLE shared] whenFindBluetoothAll:^(NSDictionary *deviceDict) {
//        // 扫描到的蓝牙列表
//        // 连接蓝牙
//    }];
//    [[BLE shared] whenConnectSuccess:^{
//        // 连接成功
//    }];
//    [[BLE shared] whenConnectFailure:^{
//        // 连接失败
//    }];
//    [[BLE shared] whenUpdateService:^(CBService *service) {
//        // 更新服务（characteristic）
//    }];
//    [[BLE shared] send:[[NSData alloc] init]];
//    [[BLE shared] whenSendProgressUpdate:^(NSNumber *progress) {
//        // 数据发送进度
//    }];
//    [[BLE shared] whenSendSuccess:^{
//        // 数据发送成功
//    }];
//    [[BLE shared] whenSendFailure:^{
//        // 数据发送失败
//    }];
//
//    NSString *password = @"mtdp";
//    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *lockData = [NSData dataWithBytes:"\x0a\x0b" length:2];
//    [[BLE shared] whenReceiveData:^(NSData *data) {
//        // 接收到蓝牙返回的数据
//        if ([data isEqualToData:passwordData]) {
//            [BLELockManager unlock:password];
//        } else if ([data isEqualToData:lockData]) {
//            [BLELockManager lock];
//        }
//    }];
//    [[BLE shared] unconnect];
//    [[BLE shared] whenUnconnect:^{
//        // 已断开
//    }];
    self.broadcast = [[BLEBroadcast alloc] initWithUUID:@"C4D13329-6DF2-47B5-83AC-CD3AB71AA9F8"];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
