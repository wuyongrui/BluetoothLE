//
//  BluetoothLE+Delegate.m
//  BluetoothLE
//
//  Created by ios on 15/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "BLE+Delegate.h"
#import "BLE+SendData.h"

@implementation BLE (Delegate)

#pragma mark CBCentralManagerDelegate
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    NSLog(@"centralManagerDidUpdateState:%ld",(long)central.state);
    switch (central.state) {
        case CBManagerStateUnknown:      NSLog(@"CBManagerStateUnknown");     break;
        case CBManagerStateResetting:    NSLog(@"CBManagerStateResetting");   break;
        case CBManagerStateUnsupported:  NSLog(@"CBManagerStateUnsupported"); break;
        case CBManagerStateUnauthorized: NSLog(@"CBManagerStateUnauthorized");break;
        case CBManagerStatePoweredOff:   NSLog(@"CBManagerStatePoweredOff");  break;
        case CBManagerStatePoweredOn:    [self scan];                       break;//蓝牙打开，开始扫描。
        default:                         NSLog(@"蓝牙未工作在正确状态");                 break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *localName = advertisementData[CBAdvertisementDataLocalNameKey];
    if ([localName isEqualToString:@"Phone ID Beacon"]) {
        NSString *uuid = [peripheral.identifier UUIDString];
        BLEDevice *device = [[BLEDevice alloc] init];
        device.localName = localName;
        device.peripheral = peripheral;
        device.advertisementData = advertisementData;
        device.distance = [BLEDevice distanceWithRSSI:RSSI];
        device.strength = [BLEDevice strengthWithRSSI:RSSI];
        if (!self.deviceDict[uuid]) {
            self.deviceDict[uuid] = device;
            if (self.findBluetoothAllBlock) {
                self.findBluetoothAllBlock(self.deviceDict);
            }
        }
        if (self.findBluetoothBlock) {
            self.findBluetoothBlock(device);
        }
    }
}

//连接外设成功，扫描外设中的服务和特征
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    self.currentDevice.peripheral.delegate = self;
    
    if (self.connectSuccessBlock) {
        self.connectSuccessBlock();
    }
    
    [self stopScan]; //连接成功后停止扫描
    
    [peripheral discoverServices:nil];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)readRSSITimer:(NSTimer *)timer {
    if (self.currentDevice.peripheral) {
        [self.currentDevice.peripheral readRSSI];
    }
    else {
        [timer invalidate]; // 断开连接时，peripheral会置空，此时断开定时器
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    if (self.updateRSSIBlock) {
        self.updateRSSIBlock(RSSI);
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (self.unconnectBlock) {
        self.unconnectBlock();
    }
    self.currentDevice = nil;
}

//连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (self.connectFailureBlock) {
        self.connectFailureBlock();
    }
}


#pragma mark CBPeripheralDelegated

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        //发现特征，成功后执行：peripheral:didDiscoverCharacteristicsForService:error委托方法
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (self.updateServiceBlock) {
        self.updateServiceBlock(service);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateValueForCharacteristic:%@", characteristic);
    if (self.receiveDataBlock) {
        self.receiveDataBlock(characteristic.value);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ((self.isSendFinish == NO) && ( self.dataOffset != 0)) {
        [self sendNext:self.sendData];
    } else {
        if (self.sendSuccessBlock) {
            self.sendSuccessBlock();
        }
    }
}
#pragma clang diagnostic pop

@end
