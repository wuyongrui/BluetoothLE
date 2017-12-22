//
//  PIDBindViewController.m
//  macOS Demo
//
//  Created by 吴勇锐 on 2017/12/18.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDBindViewController.h"
#import "BLEBroadcast.h"
#import "PIDMenuItemManager.h"

@interface PIDBindViewController()

@property (weak) IBOutlet NSTextField *titleTextField;

@property (weak) IBOutlet NSButton *agreeButton;
@property (weak) IBOutlet NSButton *disagreeButton;
@property (weak) IBOutlet NSTextField *tipTextField;

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *deviceName;

@end

/**
 窗口实现时，广播数据，处于可绑定状态
 窗口消失时，停止广播，不可绑定
 */
@implementation PIDBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agreeButton.hidden = YES;
    self.disagreeButton.hidden = YES;
    self.tipTextField.hidden = YES;
    
    [[BLEBroadcast shared] stopAdvertising];
    [[BLEBroadcast shared] startUnbindAdvertising];
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [[BLEBroadcast shared] stopAdvertising];
    [[BLEBroadcast shared] startBindedAdvertising];
}

- (void)updateDeviceName:(NSString *)deviceName uuid:(NSString *)uuid {
    self.deviceName = deviceName;
    self.uuid = uuid;
    self.titleTextField.stringValue = [NSString stringWithFormat:@"收到手机设备:[%@]的绑定请求",deviceName];
    self.titleTextField.stringValue = deviceName;
    self.agreeButton.hidden = NO;
    self.disagreeButton.hidden = NO;
    self.tipTextField.hidden = NO;
}

- (IBAction)agreeAction:(id)sender {
    [[BLEBroadcast shared] requestGranted:YES uuid:self.uuid];
    [[PIDMenuItemManager sharedManager] updateDeviceName:self.deviceName];
    [self.view.window close];
}

- (IBAction)disagreeAction:(id)sender {
    [[BLEBroadcast shared] requestGranted:NO uuid:self.uuid];
    [[PIDMenuItemManager sharedManager] updateDeviceName:nil]; // 绑定失败
}

@end
