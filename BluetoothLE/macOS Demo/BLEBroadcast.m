//
//  BLEBroadcast.m
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/15.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLEBroadcast.h"
#import "BLELockManager.h"

@interface BLEBroadcast()<CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBUUID *uuid;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@end

static NSString * const kServiceUUID = @"AA00";
static NSString * const kCharacteristicUUID = @"BB00";

@implementation BLEBroadcast

- (id)initWithUUID:(NSString *)uuid
{
    self = [super init];
    if (self) {
        self.uuid = [CBUUID UUIDWithString:uuid];
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    
    return self;
}

- (void)addService {
    CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:kServiceUUID] primary:YES];//primary
    CBMutableCharacteristic *characteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kCharacteristicUUID] properties:CBCharacteristicPropertyWriteWithoutResponse value:nil permissions:CBAttributePermissionsWriteable];
    [service setCharacteristics:@[characteristic]];
    
    [self.peripheralManager addService:service];
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
    if (error) {
        NSLog(@"Error publishing service: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"service is added");
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey:@"Phone ID Beacon", CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:kServiceUUID]]}];
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
    NSString *password = @"mtdp";
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    NSData *lockData = [NSData dataWithBytes:"\x0a\x0b" length:2];
    for (CBATTRequest *request in requests) {
        // 接收到蓝牙返回的数据
        NSLog(@"request:%@",request.value);
        if ([request.value isEqualToData:passwordData]) {
            [BLELockManager unlock:password];
        } else if ([request.value isEqualToData:lockData]) {
            [BLELockManager lock];
        }
    }
}

@end
