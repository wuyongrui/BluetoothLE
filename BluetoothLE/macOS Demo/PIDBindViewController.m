//
//  PIDBindViewController.m
//  macOS Demo
//
//  Created by 吴勇锐 on 2017/12/18.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDBindViewController.h"
#import "BLEBroadcast.h"

@interface PIDBindViewController()

@end

/**
 窗口实现时，广播数据，处于可绑定状态
 窗口消失时，停止广播，不可绑定
 */
@implementation PIDBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BLEBroadcast shared] stopAdvertising];
    [[BLEBroadcast shared] startUnbindAdvertising];
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [[BLEBroadcast shared] stopAdvertising];
    [[BLEBroadcast shared] startBindedAdvertising];
}

@end
