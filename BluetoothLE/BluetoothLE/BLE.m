//
//  PTBluetooth.m
//
//  Created by midmirror on 15/12/14.
//  Copyright © 2015年 midmirror. All rights reserved.
//

#import "BLE.h"
#import "BLE+Delegate.h"
#import "BLE+SendData.h"

@interface BLE ()

@end

@implementation BLE

static BLE *instance = nil;
+ (BLE *)shared
{
    if (instance == nil) {
        instance = [[BLE alloc] init];
    }
    return instance;
}

//扫描蓝牙
- (void)scan {
    
    _MTU = 20;
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];//创建CBCentralManager对象
    // 设置 NO 表示不发现重复设备
    NSDictionary *optionDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [_centralManager scanForPeripheralsWithServices:nil options:optionDic];//将第一个参数设置为nil，Central Manager就会开始寻找所有的服务。
}

- (void)connect:(CBPeripheral *)peripheral {
    
    [_centralManager connectPeripheral:peripheral options:nil];
}

- (void)stopScan {
    
    [_centralManager stopScan];
}

- (void)unconnect {
    
    if (_peripheral) {
        [self.centralManager cancelPeripheralConnection:_peripheral];
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
