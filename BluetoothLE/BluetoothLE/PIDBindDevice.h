//
//  PIDBindDevice.h
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/20.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDevice.h"

@interface PIDBindDevice : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *UUID;

+ (PIDBindDevice *)bindDeviceWithBLEDevice:(BLEDevice *)device;

@end
