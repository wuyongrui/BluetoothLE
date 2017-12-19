//
//  BLEBroadcast.m
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/15.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLEBroadcast.h"
#import "BLELockManager.h"
#import <BluetoothLE_Mac/BluetoothLE_Mac.h>

@interface BLEBroadcast()<CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic *characteristicWrite;
@property (nonatomic, strong) CBMutableCharacteristic *characteristicNotify;
@property (nonatomic, strong) CBMutableService *service;

@end

static NSString * const kServiceUUID = @"AA00";
static NSString * const kCharacteristicWriteUUID = @"BB00";
static NSString * const kCharacteristicNotifyUUID = @"BB11";

@implementation BLEBroadcast

+ (BLEBroadcast *)shared
{
    static BLEBroadcast *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)start {
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)startUnbindAdvertising {
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey:PIDUNBIND, CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:kServiceUUID]]}];
}

- (void)startBindedAdvertising {
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey:PIDBINDED, CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:kServiceUUID]]}];
}

- (void)stopAdvertising {
    [self.peripheralManager stopAdvertising];
}

- (BOOL)isAdvertising {
    return [self.peripheralManager isAdvertising];
}

- (void)addService {
    if (!self.service) {
        self.service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:kServiceUUID] primary:YES];//primary
        self.characteristicWrite = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCharacteristicWriteUUID] properties:CBCharacteristicPropertyWriteWithoutResponse value:nil permissions:CBAttributePermissionsWriteable];
        self.characteristicNotify = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCharacteristicNotifyUUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsWriteable];
        [self.service setCharacteristics:@[self.characteristicWrite, self.characteristicNotify]];
        [self.peripheralManager addService:self.service];
    }
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"peripheralManagerDidUpdateState CBPeripheralManagerStatePoweredOn");
        [self addService];
    } else {
        NSLog(@"peripheralManagerDidUpdateState %@", @(peripheral.state));
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    NSLog(@"didAddService");
    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
    }
    if (self.addServiceBlock) {
        self.addServiceBlock();
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"peripheralManagerDidStartAdvertising");
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests
{
    NSLog(@"requests:%@",requests);
    
    BLEData *bleData = [BLEData new];
    
    for (CBATTRequest *request in requests) {
        // 接收到蓝牙返回的数据
        NSLog(@"request:%@",request.value);
        NSData *operationData = [request.value subdataWithRange:NSMakeRange(0, 4)];
        if ([operationData isEqualToData:bleData.bindData]) {
            [BLELockManager lock];
        } else if ([operationData isEqualToData:bleData.unbindData]) {
            
        } else if ([operationData isEqualToData:bleData.lockData]) {
            [BLELockManager lock];
            if ([BLELockManager isLocked]) {
                [peripheral updateValue:bleData.lockSuccessData forCharacteristic:self.characteristicNotify onSubscribedCentrals:@[request.central]];
            } else {
                [peripheral updateValue:bleData.lockFailureData forCharacteristic:self.characteristicNotify onSubscribedCentrals:@[request.central]];
            }
        } else if ([operationData isEqualToData:bleData.unlockData]) {
            NSData *userPasswordData = [request.value subdataWithRange:NSMakeRange(4, request.value.length-4)];
            NSString *password = [[NSString alloc] initWithData:userPasswordData encoding:NSUTF8StringEncoding];
            NSData *passwordData = [bleData passwordDataWithUUID:request.central.identifier.UUIDString];
            NSLog(@"userpasswordData:%@",userPasswordData);
            NSLog(@"用户输入的密码：%@，用户数据:%@ 本地:%@",password, request.value, passwordData);
            if ([request.value isEqualToData:passwordData]) {
                // 解锁流程
                [BLELockManager unlock:password];
                if (![BLELockManager isLocked]) {
                    [peripheral updateValue:bleData.unlockSuccessData forCharacteristic:self.characteristicNotify onSubscribedCentrals:self.characteristicNotify.subscribedCentrals];
                } else {
                    [peripheral updateValue:bleData.unlockFailureData forCharacteristic:self.characteristicNotify onSubscribedCentrals:self.characteristicNotify.subscribedCentrals];
                }
            } else {
                // 验证绑定流程
                [BLELockManager unlock:password];
                if (![BLELockManager isLocked]) {
                    [peripheral updateValue:bleData.bindSuccessData forCharacteristic:self.characteristicNotify onSubscribedCentrals:self.characteristicNotify.subscribedCentrals];
                    [bleData storePassword:password withUUID:request.central.identifier.UUIDString];
                } else {
                    [peripheral updateValue:bleData.bindFailureData forCharacteristic:self.characteristicNotify onSubscribedCentrals:self.characteristicNotify.subscribedCentrals];
                }
            }
        }
    }
}

- (void)send:(NSData *)data {
    if (self.peripheralManager && self.characteristicNotify) {
        [self.peripheralManager updateValue:data forCharacteristic:self.characteristicNotify onSubscribedCentrals:self.characteristicNotify.subscribedCentrals];
    }
}

- (void)whenAddService:(AddServiceBlock)addServiceBlcok {
    self.addServiceBlock = addServiceBlcok;
}

@end
