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
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];//创建CBCentralManager对象
    }
    return self;
}

//扫描蓝牙
- (void)scan {
    
    // 设置 NO 表示不发现重复设备
    NSDictionary *optionDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [_centralManager scanForPeripheralsWithServices:nil options:optionDic];//将第一个参数设置为nil，Central Manager就会开始寻找所有的服务。
    _deviceDict = [[NSMutableDictionary alloc] init];
}

- (void)emptyBlock {
    self.connectSuccessBlock = nil;
    self.connectFailureBlock = nil;
    self.findBindedBluetoothBlock = nil;
    self.findUnbindBluetoothAllBlock = nil;
    self.updateServiceBlock = nil;
    self.unconnectBlock = nil;
    self.updateRSSIBlock = nil;
    self.sendProgressBlock = nil;
    self.sendFailureBlock = nil;
    self.sendSuccessBlock = nil;
    self.receiveDataBlock = nil;
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

- (void)whenFindBindedBluetooth:(FindBindedBluetoothBlock)bluetoothBlock {
    self.findBindedBluetoothBlock = bluetoothBlock;
}

- (void)whenFindUnbindBluetoothAll:(FindUnbindBluetoothAllBlock)bluetoothAllBlock {
    self.findUnbindBluetoothAllBlock = bluetoothAllBlock;
}

- (void)whenUpdateService:(UpdateServiceBlock)serviceBlock {
    self.updateServiceBlock = serviceBlock;
}

- (void)whenUnconnect:(UnconnectBlock)unconnectBlock {
    self.unconnectBlock = unconnectBlock;
}

- (void)whenUpdateRSSI:(UpdateRSSIBlock)RSSIBlock {
    self.updateRSSIBlock = RSSIBlock;
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

- (void)setCurrentDevice:(BLEDevice *)currentDevice {
    _currentDevice = currentDevice;
    NSLog(@"当前设备:%@",currentDevice);
}

@end
