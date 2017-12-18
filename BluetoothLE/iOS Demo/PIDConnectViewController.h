//
//  PIDConnectViewController.h
//  iOS Demo
//
//  Created by Robin on 2017/12/17.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLEDevice;

@interface PIDConnectViewController : UIViewController

- (instancetype)initWithDevice:(BLEDevice *)device;

@end
