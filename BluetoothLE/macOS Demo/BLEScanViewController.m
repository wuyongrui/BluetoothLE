//
//  BLEScanViewController.m
//  macOS Demo
//
//  Created by 吴勇锐 on 2017/12/18.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLEScanViewController.h"
#import "BLEBroadcast.h"

@interface BLEScanViewController()

@property (nonatomic, strong) BLEBroadcast *broadcast;

@end

@implementation BLEScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.broadcast = [[BLEBroadcast alloc] initWithUUID:@"C4D13329-6DF2-47B5-83AC-CD3AB71AA9F8"];
}

@end
