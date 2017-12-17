//
//  BLELockManager.h
//  macOS Demo
//
//  Created by 许向亮 on 2017/12/14.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLELockManager : NSObject

+ (BOOL)isLocked;
+ (void)lock;
+ (void)unlock:(NSString *)password;

@end
