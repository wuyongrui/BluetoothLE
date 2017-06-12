//
//  PTBluetooth.h
//
//  Created by midmirror on 15/12/14.
//  Copyright © 2015年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


/**
 *  主要功能：BLE 蓝牙的搜索，连接，数据传输
 */
@interface BluetoothLE : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

+ (BluetoothLE *)shared;

- (void)initBluetooth;
/**
 *  扫描蓝牙
 */
- (void)scanBluetooth;

- (void)stopScanBluetooth;

/**
 *  连接蓝牙设备
 *
 *  @param peripheral 将要连接的 CBPeripheral 对象
 */
- (void)connectBluetooth:(CBPeripheral *)peripheral;

/**
 *  取消连接蓝牙设备
 */
- (void)unconnectBluetooth:(CBPeripheral *)peripheral;

/**
 *  以下两个方法不要直接调用，请调用 PTDispatch 中的相关方法
 *
 */
- (void)sendData:(NSData *)data;

@end
