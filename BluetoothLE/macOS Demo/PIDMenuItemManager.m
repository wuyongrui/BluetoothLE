//
//  PIDMenuItemManager.m
//  macOS Demo
//
//  Created by 吴勇锐 on 2017/12/19.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDMenuItemManager.h"
#import <AppKit/AppKit.h>
#import <BluetoothLE_Mac/BluetoothLE_Mac.h>
#import "BLEBroadcast.h"
#import "BLELockManager.h"
#import "BLEData.h"
#import "PIDBindViewController.h"

@interface PIDMenuItemManager()

@property (nonatomic, strong) NSStatusItem *item;
@property (nonatomic, strong) NSWindowController *bindWindowController;
@property (nonatomic, strong) PIDBindViewController *bindViewController;

@property (nonatomic, copy) NSString *bindedDeviceName;

@property (nonatomic, strong) NSMenuItem *bindMenuItem;
@property (nonatomic, strong) NSMenuItem *unbindMenuItem;
@property (nonatomic, strong) NSMenuItem *lockMenuItem;
@property (nonatomic, strong) NSMenuItem *quitMenuItem;

@end

@implementation PIDMenuItemManager

- (void)dealloc {
    
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bindMenuItem = [[NSMenuItem alloc] initWithTitle:@"绑定" action:@selector(bindAction:) keyEquivalent:@""];
        [self.bindMenuItem setTarget:self];
        self.unbindMenuItem = [[NSMenuItem alloc] initWithTitle:@"解绑" action:@selector(unbindAction:) keyEquivalent:@""];
        [self.unbindMenuItem setTarget:self];
        self.lockMenuItem = [[NSMenuItem alloc] initWithTitle:@"锁定" action:@selector(lockAction:) keyEquivalent:@""];
        [self.lockMenuItem setTarget:self];
        self.quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"退出" action:@selector(quitAction:) keyEquivalent:@"q"];
        [self.quitMenuItem setTarget:self];
        
        _item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        NSImage *img = [NSImage imageNamed:@"statusBar_icon"];
        img.template = YES;
        [_item setImage:img];
        [_item setAlternateImage:img];
        
        [self.item setHighlightMode:YES];
        [self.item setEnabled:YES];
        self.item.menu = [[NSMenu alloc] initWithTitle:@"menu"];
        
        [[BLEBroadcast shared] start];
        [[BLEBroadcast shared] whenAddService:^{
            [[BLEBroadcast shared] startBindedAdvertising];
        }];
        [[BLEBroadcast shared] whenBindSuccess:^{
            [self refresh];
        }];
        BLEData *bleData = [BLEData new];
        [[BLEBroadcast shared] whenReceiveRequestData:^(NSData *data) {
            if ([data isEqualToData:bleData.unbindFailureData]) {
                [[BLEBroadcast shared] send:bleData.unbindData];
            } else if ([data isEqualToData:bleData.unbindData]) {
                [self realUnbind];
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestingBind:) name:BLEBroadcastReceiveRequestNotificationName object:nil];
        BLEDevice *bindDevice = [[BLEData new] bindedDevice];
        if (bindDevice) {
            [self updateDeviceName:bindDevice.UUID];
        }
    }
    return self;
}

- (void)requestingBind:(NSNotification *)notification {
    NSString *uuid = notification.userInfo[@"uuid"];
    NSString *deviceName = notification.userInfo[@"deviceName"];
    [self.bindViewController updateDeviceName:deviceName uuid:uuid];
}

- (void)refresh {
    [self.item.menu removeAllItems];
    PIDBindDevice *bindedDevice = [[BLEData new] bindedDevice];
    if (self.bindedDeviceName && bindedDevice) {
        [self.item.menu addItem:self.unbindMenuItem];
    } else {
        [self.item.menu addItem:self.bindMenuItem];
    }
    [self.item.menu addItem:self.lockMenuItem];
    [self.item.menu addItem:self.quitMenuItem];
    
//    self.bindMenuItem.title = bindedDevice ? @"取消绑定" : @"绑定";
}

#pragma mark - Public

- (void)updateDeviceName:(NSString *)deviceName {
    self.bindedDeviceName = deviceName;
    [self refresh];
}

#pragma mark - delegate

//-(BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem {
//    //    return anItem.tag == 10;
////    return ([anItem action] == @selector(menuItemAction:));
//    return YES;
//}

#pragma mark - action

- (void)bindAction:(NSMenuItem *)item {
    [self showBindViewController];
}

- (void)showBindViewController {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *bindWindowController = [storyboard instantiateControllerWithIdentifier:@"PIDBindWindowController"];
    [bindWindowController showWindow:self];
    self.bindWindowController = bindWindowController;
    self.bindViewController = bindWindowController.contentViewController;
}

- (void)unbindAction:(NSMenuItem *)item {
    BLEData *bleData = [BLEData new];
    [[BLEBroadcast shared] send:bleData.unbindData];
    [self realUnbind];
}

- (void)realUnbind {
    BLEData *bleData = [BLEData new];
    [bleData removeBindedDevice];
    self.bindedDeviceName = nil;
    [self refresh];
}

- (void)lockAction:(NSMenuItem *)item {
    [BLELockManager lock];
}

- (void)quitAction:(NSMenuItem *)item {
    [[BLEBroadcast shared] send:[BLEData new].unconnectData];
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
