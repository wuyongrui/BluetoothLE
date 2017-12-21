//
//  PIDMotionManager.h
//  MotionDemo
//
//  Created by 吴勇锐 on 2017/12/20.
//  Copyright © 2017年 吴勇锐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PIDMotionManager : NSObject

@property (nonatomic, assign, readonly) BOOL isMoving;

/**
 开始监听陀螺仪
 @return 是否成功。如果设备不支持陀螺仪则无法监听，返回失败
 */
- (BOOL)startMonitor;

/**
 结束监听
 */
- (void)stopMonitor;

@end
