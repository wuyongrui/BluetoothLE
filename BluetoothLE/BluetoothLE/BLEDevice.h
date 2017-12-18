//
//  BLEDevice.h
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/14.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEDevice : NSObject

@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) NSDictionary *advertisementData;
@property (nonatomic, copy) NSString *localName;
@property (nonatomic, strong) NSNumber *strength;
@property (nonatomic, strong) NSNumber *distance;   // Printer's distance calculate by RSSI

/** 计算距离 */
+ (NSNumber *)distanceWithRSSI:(NSNumber *)RSSI;

/** 判断信号强度 */
+ (NSNumber *)strengthWithRSSI:(NSNumber *)RSSI;

@end
