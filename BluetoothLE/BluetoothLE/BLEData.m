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
        
        Byte bindSuccessByte[5]   = {50, 49, 44, 00, 00};
        Byte unbindSuccessByte[5] = {50, 49, 44, 01, 00};
        Byte lockSuccessByte[5]   = {50, 49, 44, 02, 00};
        Byte unlockSuccessByte[5] = {50, 49, 44, 03, 00};
        
        Byte bindFailureByte[5]   = {50, 49, 44, 00, 01};
        Byte unbindFailureByte[5] = {50, 49, 44, 01, 01};
        Byte lockFailureByte[5]   = {50, 49, 44, 02, 01};
        Byte unlockFailureByte[5] = {50, 49, 44, 03, 01};
        
        self.bindData    = [NSData dataWithBytes:bindByte length:4];
        self.unbindData  = [NSData dataWithBytes:unbindByte length:4];
        self.lockData    = [NSData dataWithBytes:lockByte length:4];
        self.unlockData  = [NSData dataWithBytes:unlockByte length:4];
        
        self.bindSuccessData    = [NSData dataWithBytes:bindSuccessByte length:5];
        self.unbindSuccessData  = [NSData dataWithBytes:unbindSuccessByte length:5];
        self.lockSuccessData    = [NSData dataWithBytes:lockSuccessByte length:5];
        self.unlockSuccessData  = [NSData dataWithBytes:unlockSuccessByte length:5];
        
        self.bindFailureData    = [NSData dataWithBytes:bindFailureByte length:5];
        self.unbindFailureData  = [NSData dataWithBytes:unbindFailureByte length:5];
        self.lockFailureData    = [NSData dataWithBytes:lockFailureByte length:5];
        self.unlockFailureData  = [NSData dataWithBytes:unlockFailureByte length:5];
        
        self.password = @"mtdp";
        NSMutableData *unlockData = [[NSMutableData alloc] init];
        [unlockData appendData:self.unlockData];
        [unlockData appendData:[self.password dataUsingEncoding:NSUTF8StringEncoding]];
        self.passwordData = unlockData;
    }
    return self;
}

@end
