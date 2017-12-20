//
//  PIDBindDevice.m
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/20.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDBindDevice.h"

@implementation PIDBindDevice

+ (PIDBindDevice *)bindDeviceWithBLEDevice:(BLEDevice *)device {
    PIDBindDevice *bindDevice = [[PIDBindDevice alloc] init];
    bindDevice.name = device.peripheral.name;
    bindDevice.password = device.password;
    bindDevice.UUID = device.UUID;
    return bindDevice;
}

@end
