//
//  PTBluetooth.h
//
//  Created by midmirror on 15/12/14.
//  Copyright © 2015年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDevice.h"

/** 发现新蓝牙 */
typedef void(^FindBluetoothBlock)(BLEDevice *device);
typedef void(^FindBluetoothAllBlock)(NSDictionary *deviceDict);

/** 连接成功、失败 */
typedef void(^ConnectSuccessBlock)();
typedef void(^ConnectFailureBlock)();

typedef void(^UpdateServiceBlock)(CBService *service);

/** 可以发送、发送成功、发送失败、接收到返回值 */
typedef void(^SendSuccessBlock)();
typedef void(^SendFailureBlock)();
typedef void(^SendProgressBlock)(NSNumber *progress);
typedef void(^ReceiveDataBlock)(NSData *data);

/** 断开 */
typedef void(^UnconnectBlock)();


@interface BLE : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(copy,nonatomic,readwrite) FindBluetoothBlock      findBluetoothBlock;
@property(copy,nonatomic,readwrite) FindBluetoothAllBlock   findBluetoothAllBlock;

@property(copy,nonatomic,readwrite) UpdateServiceBlock      updateServiceBlock;

@property(copy,nonatomic,readwrite) SendSuccessBlock        sendSuccessBlock;        //发送结束时的 Block
@property(copy,nonatomic,readwrite) SendFailureBlock        sendFailureBlock;
@property(copy,nonatomic,readwrite) SendProgressBlock       sendProgressBlock;
@property(copy,nonatomic,readwrite) ReceiveDataBlock        receiveDataBlock;
@property(copy,nonatomic,readwrite) ConnectSuccessBlock     connectSuccessBlock;
@property(copy,nonatomic,readwrite) ConnectFailureBlock     connectFailureBlock;
@property(copy,nonatomic,readwrite) UnconnectBlock          unconnectBlock;

@property(strong,nonatomic,readwrite) CBCentralManager *centralManager;
@property(strong,nonatomic,readwrite) BLEDevice *currentDevice;
@property(strong,nonatomic,readwrite) NSMutableDictionary<NSString *, BLEDevice *> *deviceDict;
@property(strong,nonatomic,readwrite) CBCharacteristic *characteristicWrite;
@property(strong,nonatomic,readwrite) NSData *sendData;
@property(copy,nonatomic,readwrite) NSString *writeCharacteristic;

@property(assign,nonatomic,readwrite) NSInteger MTU;
@property(assign,nonatomic,readwrite) NSInteger dataOffset;
@property(assign,nonatomic,readwrite) BOOL isSendFinish;

+ (BLE *)shared;
/**
 *  扫描蓝牙
 */
- (void)scan;

- (void)stopScan;

/**
 *  连接蓝牙设备
 *
 *  @param peripheral 将要连接的 CBPeripheral 对象
 */
- (void)connect:(BLEDevice *)device;

/**
 *  取消连接蓝牙设备
 */
- (void)unconnect;

/* 发现新蓝牙（同一个蓝牙如果状态更新会被重复发现），仅用于快速连接 */
- (void)whenFindBluetooth:(FindBluetoothBlock)bluetoothBlock;
/* 发现所有的蓝牙（每3秒更新一次所有蓝牙状态），用于扫描连接 */
- (void)whenFindBluetoothAll:(FindBluetoothAllBlock)bluetoothAllBlock;

- (void)whenUpdateService:(UpdateServiceBlock)serviceBlock;

/** 当连接成功时 */
- (void)whenConnectSuccess:(ConnectSuccessBlock)connectSuccessBlock;

/** 当连接失败时 */
- (void)whenConnectFailure:(ConnectFailureBlock)connectFailureBlock;

/** 当断开连接时 */
- (void)whenUnconnect:(UnconnectBlock)unconnectBlock;

/** 发送数据 */
- (void)whenSendSuccess:(SendSuccessBlock)sendSuccessBlock; // 成功
- (void)whenSendFailure:(SendFailureBlock)sendFailureBlock; // 失败
- (void)whenSendProgressUpdate:(SendProgressBlock)sendProgressBlock;    // 发送进度
- (void)whenReceiveData:(ReceiveDataBlock)receiveDataBlock;

@end
