//
//  BLEBroadcast.m
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/15.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLEBroadcast.h"

@interface BLEBroadcast()<CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBUUID *uuid;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@end

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

- (void)startBroadcasting
{
    NSLog(@"startBroadcasting");
    if ([CBPeripheralManager authorizationStatus] != CBPeripheralManagerAuthorizationStatusAuthorized) {
        NSLog(@"CBPeripheralManager: Not authorized");
        return;
    }
    
    // Only two supported data types.
    // While app is in foreground, first 28 bytes of advertisingData go in initial advertisement.
    // If there is more data, the local name is put in a scan response.
    // While app is in background, advertisingData is ignored. Apple-specific data is sent in the advertisement instead:
    // e.g. 14:FF:4C:00:01:00:00:80:00:00:00:00:00:00:00:00:00:00:00:00:00
    
    NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey:@"Phone ID Beacon",
                                      CBAdvertisementDataServiceUUIDsKey:@[self.uuid]};
    [self.peripheralManager startAdvertising:advertisingData];
    
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"peripheralManagerDidUpdateState CBPeripheralManagerStatePoweredOn");
        [self startBroadcasting];
    } else {
        NSLog(@"peripheralManagerDidUpdateState %@", @(peripheral.state));
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    NSLog(@"peripheralManagerDidStartAdvertising");
    if (error) {
        NSLog(@"Error advertising: %@", [error localizedDescription]);
    }
}

@end
