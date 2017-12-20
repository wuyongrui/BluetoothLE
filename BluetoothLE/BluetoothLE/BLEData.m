//
//  BLEData.m
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/18.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLEData.h"
#import "PIDDiskCache.h"

const float PIDLOCKDISTANCE = 1.0;
const float PIDLOCKRSSI = -65;
NSString * const PIDUNBIND = @"PIDUNBIND";
NSString * const PIDBINDED = @"PIDBINDED";

NSString * const PIDDEFAULTDEVICE = @"PIDDEFAULTDEVICE";

@implementation BLEData

- (instancetype)init {
    if (self = [super init]) {
        Byte bindByte[4]   = {0x50, 0x49, 0x44, 0x00};
        Byte unbindByte[4] = {0x50, 0x49, 0x44, 0x01};
        Byte lockByte[4]   = {0x50, 0x49, 0x44, 0x02};
        Byte unlockByte[4] = {0x50, 0x49, 0x44, 0x03};
        Byte clearPasswordByte[4] = {0x50, 0x49, 0x44, 0x04};
        
        Byte bindSuccessByte[5]   = {0x50, 0x49, 0x44, 0x00, 0x00};
        Byte unbindSuccessByte[5] = {0x50, 0x49, 0x44, 0x01, 0x00};
        Byte lockSuccessByte[5]   = {0x50, 0x49, 0x44, 0x02, 0x00};
        Byte unlockSuccessByte[5] = {0x50, 0x49, 0x44, 0x03, 0x00};
        Byte clearPasswordSuccessByte[5] = {0x50, 0x49, 0x44, 0x04, 0x00};
        
        Byte bindFailureByte[5]   = {0x50, 0x49, 0x44, 0x00, 0x01};
        Byte unbindFailureByte[5] = {0x50, 0x49, 0x44, 0x01, 0x01};
        Byte lockFailureByte[5]   = {0x50, 0x49, 0x44, 0x02, 0x01};
        Byte unlockFailureByte[5] = {0x50, 0x49, 0x44, 0x03, 0x01};
        Byte clearPasswordFailureByte[5] = {0x50, 0x49, 0x44, 0x04, 0x01};
        
        self.bindData    = [NSData dataWithBytes:bindByte length:4];
        self.unbindData  = [NSData dataWithBytes:unbindByte length:4];
        self.lockData    = [NSData dataWithBytes:lockByte length:4];
        self.unlockData  = [NSData dataWithBytes:unlockByte length:4];
        self.clearPasswordData = [NSData dataWithBytes:clearPasswordByte length:4];
        
        self.bindSuccessData    = [NSData dataWithBytes:bindSuccessByte length:5];
        self.unbindSuccessData  = [NSData dataWithBytes:unbindSuccessByte length:5];
        self.lockSuccessData    = [NSData dataWithBytes:lockSuccessByte length:5];
        self.unlockSuccessData  = [NSData dataWithBytes:unlockSuccessByte length:5];
        self.clearPasswordData = [NSData dataWithBytes:clearPasswordSuccessByte length:5];
        
        self.bindFailureData    = [NSData dataWithBytes:bindFailureByte length:5];
        self.unbindFailureData  = [NSData dataWithBytes:unbindFailureByte length:5];
        self.lockFailureData    = [NSData dataWithBytes:lockFailureByte length:5];
        self.unlockFailureData  = [NSData dataWithBytes:unlockFailureByte length:5];
        self.clearPasswordFailureData = [NSData dataWithBytes:clearPasswordFailureByte length:5];
    }
    return self;
}

- (void)storeBindedDevice:(BLEDevice *)device {
    PIDBindDevice *bindDevice = [PIDBindDevice bindDeviceWithBLEDevice:device];
    [[PIDDiskCache shared] storeItem:bindDevice forKey:PIDDEFAULTDEVICE];
}

- (void)removeBindedDevice {
    [[PIDDiskCache shared] removeItemForKey:PIDDEFAULTDEVICE];
}

- (PIDBindDevice *)bindedDevice {
    return [[PIDDiskCache shared] itemForKey:PIDDEFAULTDEVICE];
}

- (NSData *)passwordDataWithPassword:(NSString *)password {
    if (password.length > 0) {
        NSMutableData *unlockData = [[NSMutableData alloc] init];
        [unlockData appendData:self.unlockData];
        [unlockData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
        return unlockData;
    } else {
        return nil;
    }
}

@end
