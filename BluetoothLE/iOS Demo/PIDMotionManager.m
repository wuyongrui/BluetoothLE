//
//  PIDMotionManager.m
//  MotionDemo
//
//  Created by 吴勇锐 on 2017/12/20.
//  Copyright © 2017年 吴勇锐. All rights reserved.
//

#import "PIDMotionManager.h"
#import <CoreMotion/CoreMotion.h>

@interface PIDMotionManager()

@property (nonatomic, assign, readwrite) BOOL isMoving;

@property (nonatomic, strong) NSOperationQueue *monitorQueue;
@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, assign) CGFloat previousX;
@property (nonatomic, assign) CGFloat previousY;
@property (nonatomic, assign) CGFloat previousZ;

@end

@implementation PIDMotionManager

- (BOOL)startMonitor {
    if (!self.motionManager) {
        self.motionManager = [CMMotionManager new];
    }
    if (!self.monitorQueue) {
        self.monitorQueue = [NSOperationQueue new];
    }
    if (!self.motionManager.isAccelerometerAvailable) {
        return NO;
    }
    self.motionManager.accelerometerUpdateInterval = 0.3;
    
    [self.motionManager startGyroUpdatesToQueue:self.monitorQueue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
        CGFloat x = (NSInteger)(gyroData.rotationRate.x*100) / 100.0;
        CGFloat y = (NSInteger)(gyroData.rotationRate.y*100) / 100.0;
        CGFloat z = (NSInteger)(gyroData.rotationRate.z*100) / 100.0;
        self.isMoving = (self.previousX != x) || (self.previousY != y) || (self.previousZ != z);
        self.previousX = x;
        self.previousY = y;
        self.previousZ = z;
    }];
    return YES;
}

- (void)stopMonitor {
    [self.motionManager stopGyroUpdates];
}

@end
