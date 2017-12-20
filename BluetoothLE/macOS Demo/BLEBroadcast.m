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
            [self bind:request];
        } else if ([operationData isEqualToData:bleData.unbindData]) {
        } else if ([operationData isEqualToData:bleData.lockData]) {
            NSLog(@"锁定");
            [self lock:request];
        } else if ([operationData isEqualToData:bleData.unlockData]) {
//            NSLog(@"解锁");
            [self unlock:request];
        }
    }
}

- (void)lock:(CBATTRequest *)request {
    BLEData *bleData = [BLEData new];
    [BLELockManager lock];
    if ([BLELockManager isLocked]) {
        [self.peripheralManager updateValue:bleData.lockSuccessData forCharacteristic:self.characteristicNotify onSubscribedCentrals:@[request.central]];
    } else {
        [self.peripheralManager updateValue:bleData.lockFailureData forCharacteristic:self.characteristicNotify onSubscribedCentrals:@[request.central]];
    }
}

- (void)unlock:(CBATTRequest *)request {
    BLEData *bleData = [BLEData new];
    NSData *userPasswordData = [request.value subdataWithRange:NSMakeRange(4, request.value.length-4)];
    NSString *password = [[NSString alloc] initWithData:userPasswordData encoding:NSUTF8StringEncoding];
//    NSData *passwordData = [bleData passwordDataWithPassword:password];
    [BLELockManager unlock:password];
    if (![BLELockManager isLocked]) {
        [self.peripheralManager updateValue:bleData.unlockSuccessData forCharacteristic:self.characteristicNotify onSubscribedCentrals:@[request.central]];
    } else {
        [self.peripheralManager updateValue:bleData.unlockFailureData forCharacteristic:self.characteristicNotify onSubscribedCentrals:@[request.central]];
    }
}

- (void)bind:(CBATTRequest *)request {
    BLEData *bleData = [BLEData new];
    NSData *userPasswordData = [request.value subdataWithRange:NSMakeRange(4, request.value.length-4)];
    NSString *password = [[NSString alloc] initWithData:userPasswordData encoding:NSUTF8StringEncoding];
    [BLELockManager unlock:password];
    if (![BLELockManager isLocked]) {
        if (self.bindSuccessBlock) {
            self.bindSuccessBlock();
        }
        NSLog(@"绑定成功");
        [self.peripheralManager updateValue:bleData.bindSuccessData forCharacteristic:self.characteristicNotify onSubscribedCentrals:@[request.central]];
        PIDBindDevice *bindedDevice = [[BLEDevice alloc] init];
        bindedDevice.UUID = request.central.identifier.UUIDString;
        bindedDevice.password = password;
        [bleData storeBindedDevice:bindedDevice];
    } else {
        NSLog(@"绑定失败");
        [self.peripheralManager updateValue:bleData.bindFailureData forCharacteristic:self.characteristicNotify onSubscribedCentrals:@[request.central]];
    }
}

- (void)send:(NSData *)data {
    if (self.peripheralManager && self.characteristicNotify) {
        [self.peripheralManager updateValue:data forCharacteristic:self.characteristicNotify onSubscribedCentrals:self.characteristicNotify.subscribedCentrals];
    }
}

- (void)whenAddService:(AddServiceBlock)addServiceBlock {
    self.addServiceBlock = addServiceBlock;
}

- (void)whenBindSuccess:(BindSuccessBlock)bindSuccessBlock {
    self.bindSuccessBlock = bindSuccessBlock;
}

@end
