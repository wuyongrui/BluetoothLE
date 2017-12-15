//
//  BLEBroadcast.h
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/15.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEBroadcast : NSObject

- (id)initWithUUID:(NSString *)uuid;
- (void)startBroadcasting;
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral;
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error;

@end
