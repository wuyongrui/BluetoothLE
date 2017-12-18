//
//  BLEData.m
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/18.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLEData.h"

@implementation BLEData

- (instancetype)init {
    if (self = [super init]) {
        Byte bindByte[4]   = {50, 49, 44, 00};
        Byte unbindByte[4] = {50, 49, 44, 01};
        Byte lockByte[4]   = {50, 49, 44, 02};
        Byte unlockByte[4] = {50, 49, 44, 03};
        self.bindData    = [NSData dataWithBytes:bindByte length:4];
        self.unbindData  = [NSData dataWithBytes:unbindByte length:4];
        self.lockData    = [NSData dataWithBytes:lockByte length:4];
        
        self.password = @"mtdp";
        NSMutableData *unlockData = [[NSMutableData alloc] initWithBytes:unlockByte length:4];
        [unlockData appendData:[self.password dataUsingEncoding:NSUTF8StringEncoding]];
        self.unlockData = unlockData;
    }
    return self;
}

@end
