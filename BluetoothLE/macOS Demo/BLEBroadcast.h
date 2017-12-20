//
//  BLEBroadcast.h
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/15.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^AddServiceBlock)(void);
typedef void(^BindSuccessBlock)(void);

@interface BLEBroadcast : NSObject

@property (nonatomic, copy) AddServiceBlock addServiceBlock;
@property (nonatomic, copy) BindSuccessBlock bindSuccessBlock;

+ (BLEBroadcast *)shared;

- (void)start;
/** 开始未绑定广播 */
- (void)startUnbindAdvertising;
/** 开始已绑定广播 */
- (void)startBindedAdvertising;
/** 停止广播 */
- (void)stopAdvertising;
/** 是否正在广播 */
- (BOOL)isAdvertising;
/** 发送数据 */
- (void)send:(NSData *)data;

- (void)whenAddService:(AddServiceBlock)addServiceBlock;
- (void)whenBindSuccess:(BindSuccessBlock)bindSuccessBlock;

@end
