//
//  BLEData.h
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/18.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDevice.h"
#import "PIDBindDevice.h"

extern const float PIDLOCKDISTANCE;
extern const float PIDLOCKRSSI;
extern NSString * const PIDUNBIND;
extern NSString * const PIDBINDED;

@interface BLEData : NSObject

@property (nonatomic, strong) NSData *pidData;
@property (nonatomic, strong) NSData *askBindData;
@property (nonatomic, strong) NSData *bindData;
@property (nonatomic, strong) NSData *unbindData;
@property (nonatomic, strong) NSData *lockData;
@property (nonatomic, strong) NSData *unlockData;
@property (nonatomic, strong) NSData *clearPasswordData;
@property (nonatomic, strong) NSData *unconnectData;
@property (nonatomic, strong) NSData *lightScreenData;

@property (nonatomic, strong) NSData *bindSuccessData;
@property (nonatomic, strong) NSData *bindFailureData;
@property (nonatomic, strong) NSData *unbindSuccessData;
@property (nonatomic, strong) NSData *unbindFailureData;
@property (nonatomic, strong) NSData *clearPasswordSuccessData;

@property (nonatomic, strong) NSData *lockSuccessData;
@property (nonatomic, strong) NSData *lockFailureData;
@property (nonatomic, strong) NSData *unlockSuccessData;
@property (nonatomic, strong) NSData *unlockFailureData;
@property (nonatomic, strong) NSData *clearPasswordFailureData;

- (void)storeBindedDevice:(BLEDevice *)device;
- (void)removeBindedDevice;
- (PIDBindDevice *)bindedDevice;
- (NSData *)passwordDataWithPassword:(NSString *)password;

@end

