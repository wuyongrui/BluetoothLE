//
//  PTBluetooth.m
//
//  Created by midmirror on 15/12/14.
//  Copyright © 2015年 midmirror. All rights reserved.
//

#import "BLE.h"

#define UUID_NOTIFY           @"49535343-1E4D-4BD9-BA61-23C647249616"
#define UUID_WRITE            @"49535343-8841-43F4-A8D4-ECBE34729BB3"

@interface BluetoothLE ()

@property BOOL BluetoothReady;
@property(strong,nonatomic,readwrite) CBCentralManager *centralManager;
@property(strong,nonatomic,readwrite) CBPeripheral *peripheral;
@property(strong,nonatomic,readwrite) CBCharacteristic *characteristicWrite;
@property(strong,nonatomic,readwrite) NSData *sendData;

@end

@implementation BluetoothLE

static BluetoothLE *instance = nil;
+ (BluetoothLE *)shared
{
    if (instance == nil) {
        instance = [[BluetoothLE alloc] init];
    }
    return instance;
}

- (void)initBluetooth {
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];//创建CBCentralManager对象
}

//扫描蓝牙
- (void)scanBluetooth {
    
    // 设置 NO 表示不发现重复设备
    NSDictionary *optionDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [_centralManager scanForPeripheralsWithServices:nil options:optionDic];//将第一个参数设置为nil，Central Manager就会开始寻找所有的服务。
}

- (void)connectBluetooth:(CBPeripheral *)peripheral {
    
    [_centralManager connectPeripheral:peripheral options:nil];
}

- (void)stopScanBluetooth {
    
    [_centralManager stopScan];
}

- (void)unconnectBluetooth:(CBPeripheral *)peripheral {
    
    if (peripheral) {
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

#pragma mark CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    NSLog(@"centralManagerDidUpdateState:%ld",(long)central.state);
    switch (central.state) {
        case CBCentralManagerStateUnknown:      NSLog(@"CBCentralStateUnknown");     break;
        case CBCentralManagerStateResetting:    NSLog(@"CBCentralStateResetting");   break;
        case CBCentralManagerStateUnsupported:  NSLog(@"CBCentralStateUnsupported"); break;
        case CBCentralManagerStateUnauthorized: NSLog(@"CBCentralStateUnauthorized");break;
        case CBCentralManagerStatePoweredOff:   NSLog(@"CBCentralStatePoweredOff");  break;
        case CBCentralManagerStatePoweredOn:    [self scanBluetooth];                       break;//蓝牙打开，开始扫描。
        default:                         NSLog(@"蓝牙未工作在正确状态");                 break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"peripheral:%@ uuid:%@",peripheral.name, peripheral.identifier.UUIDString);
    
    if ([[peripheral.identifier UUIDString] isEqualToString:@"39DC2107-8B75-4154-9B74-C42E020D29BC"]) {
        [self stopScanBluetooth];
        _peripheral = peripheral;
        [self connectBluetooth:_peripheral];
    }
}

//连接外设成功，扫描外设中的服务和特征
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    _peripheral = peripheral;
    _peripheral.delegate = self;
    
    [self stopScanBluetooth]; //连接成功后停止扫描
    
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    _peripheral = nil;
}

//连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}


#pragma mark CBPeripheralDelegated

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        //发现特征，成功后执行：peripheral:didDiscoverCharacteristicsForService:error委托方法
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    CBCharacteristic *characteristic = nil;
    
    for (characteristic in service.characteristics) {
        NSLog(@"characteristic uuid:%@", characteristic.UUID);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_WRITE]]) {
            
            self.characteristicWrite = characteristic;
            
            [self sendData:[NSData dataWithBytes:"\x0d\x0a" length:2]];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    // 多次发送时，继续发送下一包
    NSLog(@"已经发送");
}

#pragma mark SendData

- (void)sendData:(NSData *)data {
    
    //不分包情况下，一次性发送
    _sendData = data;
    NSLog(@"要发送的数据:%@",_sendData);
    [self writeWithResponse:_sendData];
    
}

- (void)writeWithResponse:(NSData *)data {
    
    if (self.characteristicWrite) {
        [_peripheral writeValue:data forCharacteristic:self.characteristicWrite type:CBCharacteristicWriteWithResponse];
    }
}

@end
