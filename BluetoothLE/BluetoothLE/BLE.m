//
//  PTBluetooth.m
//
//  Created by midmirror on 15/12/14.
//  Copyright © 2015年 midmirror. All rights reserved.
//

#import "BLE.h"
#import "BLE+Delegate.h"
#import "BLE+SendData.h"


@implementation BLE

+ (BLE *)shared
{
    static BLE *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        _MTU = 20;
        _deviceDict = [[NSMutableDictionary alloc] init];
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];//创建CBCentralManager对象
    }
    return self;
}

//扫描蓝牙
- (void)scan {
    
    // 设置 NO 表示不发现重复设备
    NSDictionary *optionDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [_centralManager scanForPeripheralsWithServices:nil options:optionDic];//将第一个参数设置为nil，Central Manager就会开始寻找所有的服务。
}

- (void)connect:(BLEDevice *)device {
    if (device.peripheral) {
        _currentDevice = device;
        [_centralManager connectPeripheral:device.peripheral options:nil];
    }
}

- (void)stopScan {
    
    [_centralManager stopScan];
}

- (void)unconnect {
    
    if (_currentDevice.peripheral) {
        [self.centralManager cancelPeripheralConnection:_currentDevice.peripheral];
    }
}

- (void)whenFindBluetooth:(FindBluetoothBlock)bluetoothBlock {
    self.findBluetoothBlock = bluetoothBlock;
}

- (void)whenFindBluetoothAll:(FindBluetoothAllBlock)bluetoothAllBlock {
    self.findBluetoothAllBlock = bluetoothAllBlock;
}

- (void)whenUpdateService:(UpdateServiceBlock)serviceBlock {
    self.updateServiceBlock = serviceBlock;
}

- (void)whenUnconnect:(UnconnectBlock)unconnectBlock {
    self.unconnectBlock = unconnectBlock;
}

- (void)whenConnectSuccess:(ConnectSuccessBlock)connectSuccessBlock {
    self.connectSuccessBlock = connectSuccessBlock;
}

- (void)whenConnectFailure:(ConnectFailureBlock)connectFailureBlock {
    self.connectFailureBlock = connectFailureBlock;
}

- (void)whenSendSuccess:(SendSuccessBlock)sendSuccessBlock {
    self.sendSuccessBlock = sendSuccessBlock;
}

- (void)whenSendFailure:(SendFailureBlock)sendFailureBlock {
    self.sendFailureBlock = sendFailureBlock;
}

- (void)whenSendProgressUpdate:(SendProgressBlock)sendProgressBlock {
    self.sendProgressBlock = sendProgressBlock;
}

- (void)whenReceiveData:(ReceiveDataBlock)receiveDataBlock {
    self.receiveDataBlock = receiveDataBlock;
}

@end