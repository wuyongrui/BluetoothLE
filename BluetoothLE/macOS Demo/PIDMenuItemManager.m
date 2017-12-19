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

@interface PIDMenuItemManager()

@property (nonatomic, strong) NSStatusItem *item;
@property (nonatomic, strong) NSWindowController *scanWindowController;

@property (nonatomic, copy) NSString *bindedDeviceName;

@property (nonatomic, strong) NSMenuItem *bindMenuItem;
@property (nonatomic, strong) NSMenuItem *clearPasswordMenuItem;
@property (nonatomic, strong) NSMenuItem *quitMenuItem;

@end

@implementation PIDMenuItemManager

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
        self.clearPasswordMenuItem = [[NSMenuItem alloc] initWithTitle:@"清除密码" action:@selector(clearPasswordsAction:) keyEquivalent:@""];
        [self.clearPasswordMenuItem setTarget:self];
        self.quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"退出" action:@selector(quitAction:) keyEquivalent:@"q"];
        [self.quitMenuItem setTarget:self];
        
        _item = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        [_item setImage:[NSImage imageNamed:@"icon_menu"]];
        [self.item setHighlightMode:YES];
        [self.item setEnabled:YES];
        self.item.menu = [[NSMenu alloc] initWithTitle:@"menu"];
    }
    return self;
}

- (void)refresh {
    [self.item.menu removeAllItems];
    [self.item.menu addItem:self.bindMenuItem];
    [self.item.menu addItem:self.clearPasswordMenuItem];
    [self.item.menu addItem:self.quitMenuItem];
}

#pragma mark - Public

- (void)updateDeviceName:(NSString *)deviceName {
    self.bindedDeviceName = deviceName;
}

#pragma mark - delegate

//-(BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem {
//    //    return anItem.tag == 10;
////    return ([anItem action] == @selector(menuItemAction:));
//    return YES;
//}

#pragma mark - action

- (void)bindAction:(NSMenuItem *)item {
    if ([item.title isEqualToString:@"绑定"]) {
        NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        NSWindowController *scanWindowController = [storyboard instantiateControllerWithIdentifier:@"ScanWindowController"];
        [scanWindowController showWindow:self];
        self.scanWindowController = scanWindowController;
    } else {
        // 取消绑定
    }
}
- (void)quitAction:(NSMenuItem *)item {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

- (void)clearPasswordsAction:(NSMenuItem *)item {
    [[BLEData new] clearPasswords];
}

@end