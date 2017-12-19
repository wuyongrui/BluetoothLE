//
//  BLEData.h
//  BluetoothLE
//
//  Created by 许向亮 on 2017/12/18.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEData : NSObject

@property (nonatomic, strong) NSData *bindData;
@property (nonatomic, strong) NSData *unbindData;
@property (nonatomic, strong) NSData *lockData;
@property (nonatomic, strong) NSData *unlockData;
@property (nonatomic, strong) NSData *bindSuccessData;
@property (nonatomic, strong) NSData *bindFailureData;
@property (nonatomic, strong) NSData *unbindSuccessData;
@property (nonatomic, strong) NSData *unbindFailureData;
@property (nonatomic, strong) NSData *lockSuccessData;
@property (nonatomic, strong) NSData *lockFailureData;
@property (nonatomic, strong) NSData *unlockSuccessData;
@property (nonatomic, strong) NSData *unlockFailureData;

- (void)storePassword:(NSString *)password withUUID:(NSString *)uuid;
- (NSMutableDictionary *)passwordDict;
- (NSString *)passwordWithUUID:(NSString *)uuid;
- (NSData *)passwordDataWithUUID:(NSString *)uuid;
- (void)clearPasswords;

@end
