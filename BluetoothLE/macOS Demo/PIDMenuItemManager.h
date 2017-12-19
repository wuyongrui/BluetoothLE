//
//  PIDMenuItemManager.h
//  macOS Demo
//
//  Created by 吴勇锐 on 2017/12/19.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIDMenuItemManager : NSObject

+ (instancetype)sharedManager;
- (void)refresh;

- (void)updateDeviceName:(NSString *)deviceName;

@end
