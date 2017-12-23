//
//  BLERSSI.m
//  BluetoothLE
//
//  Created by midmirror on 2017/12/23.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLERSSI.h"

@implementation BLERSSI

- (instancetype)init {
    if (self = [super init]) {
        self.date = [[NSDate alloc] init];
    }
    return self;
}

- (BOOL)isTimeout {
    NSDate *nowDate = [[NSDate alloc] init];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:self.date];
    if (interval > 0.5) {
        NSLog(@"超时:%f，将被移除:%.1f", interval,self.RSSI.floatValue);
        return YES;
    } else {
        return NO;
    }
}

@end
