//
//  BLEDevice.m
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/14.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLEDevice.h"

@implementation BLEDevice

/**
 *  根据 RSSI 强度计算距离
 *
 *  @param RSSI 信号强度
 *
 */
+ (NSNumber *)distanceWithRSSI:(NSNumber *)RSSI
{
    int rssi = RSSI.intValue;
    //    float power = (abs(rssi)-67)/(10 * 2.0);
    float power = (abs(rssi)-65)/(10 * 2.0);
    float distance = pow(10, power);
    
    return [[NSNumber alloc] initWithFloat:distance];
}

+ (NSNumber *)strengthWithRSSI:(NSNumber *)RSSI
{
    NSInteger rssi = RSSI.integerValue;
    if (rssi < 0 && rssi >= -50)   return @5;
    else if (rssi < -50 && rssi >= -60) return @4;
    else if (rssi < -60 && rssi >= -70) return @3;
    else if (rssi < -70 && rssi >= -80) return @2;
    else if (rssi < -80 && rssi >= -95) return @1;
    else if (rssi >= 0)                 return @1;
    else                                return @0;
}

- (void)setIsLocked:(BOOL)isLocked {
    _isLocked = isLocked;
    NSLog(@"锁定状态:%@",@(isLocked));
}

+ (BLEDevice *)deviceWithPeripheral:(CBPeripheral *)peripheral
                  advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                               RSSI:(NSNumber *)RSSI {
    NSString *localName = advertisementData[CBAdvertisementDataLocalNameKey];
    BLEDevice *device = [[BLEDevice alloc] init];
    device.localName = localName;
    device.peripheral = peripheral;
    device.advertisementData = advertisementData;
    device.distance = [BLEDevice distanceWithRSSI:RSSI];
    device.strength = [BLEDevice strengthWithRSSI:RSSI];
    return device;
}

@end
