//
//  BLERSSI.h
//  BluetoothLE
//
//  Created by midmirror on 2017/12/23.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLERSSI : NSObject

@property (nonatomic, strong) NSNumber *RSSI;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL isTimeout;

@end
