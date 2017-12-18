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
@property (nonatomic, strong) NSString *password;

@end
