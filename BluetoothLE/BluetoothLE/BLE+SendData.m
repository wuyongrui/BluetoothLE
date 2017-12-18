//
//  BLE+SendData.m
//  BluetoothLE
//
//  Created by ios on 15/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "BLE+SendData.h"

@implementation BLE (SendData)

- (void)send:(NSData *)data {
    
    self.isSendFinish = NO;
    self.dataOffset = 0;
    if (self.currentDevice.peripheral && data) {
        self.sendData = data;
        int dataSize = (int)self.sendData.length;
        if (dataSize < self.MTU) {
            //不分包情况下，一次性发送
            [self writeFinal:self.sendData];
            self.isSendFinish = YES;
            self.sendData = nil;
        }else {
            [self sendNext:self.sendData];
        }
    }
}

- (void)sendNext:(NSData *)data {
    float dataSize = (float)data.length;
    NSData *subData;
    if (data.length - self.dataOffset <= self.MTU) { // 剩余数据量可以一次性发送完（最后一次发送）
        
        subData = [data subdataWithRange:NSMakeRange(self.dataOffset, dataSize - self.dataOffset)];
        self.dataOffset = 0;
        self.isSendFinish = YES;
        self.sendData = nil;
        
        if (self.sendProgressBlock) {
            self.sendProgressBlock(@1);
        }
        
    }else {
        
        subData = [data subdataWithRange:NSMakeRange(self.dataOffset, self.MTU)];
        self.dataOffset += self.MTU;
        self.isSendFinish = NO;
        
        if (self.sendProgressBlock) {
            self.sendProgressBlock([NSNumber numberWithFloat:self.dataOffset/dataSize]);
        }
    }
    
    [self writeFinal:subData];
}

- (void)writeFinal:(NSData *)data {
    
    if (self.characteristicWrite && data) {
        [self.currentDevice.peripheral writeValue:data forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithoutResponse];
    }
}

@end
