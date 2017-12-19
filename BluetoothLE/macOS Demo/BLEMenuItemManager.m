//
//  BLEMenuItemManager.m
//  macOS Demo
//
//  Created by 吴勇锐 on 2017/12/19.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLEMenuItemManager.h"
#import <AppKit/AppKit.h>

@interface BLEMenuItemManager()

@property (nonatomic, strong) NSStatusItem *item;
@property (nonatomic, strong) NSWindowController *scanWindowController;

@property (nonatomic, copy) NSString *bindedDeviceName;

@property (nonatomic, strong) NSMenuItem *scanMenuItem;
@property (nonatomic, strong) NSMenuItem *unbindMenuItem;
@property (nonatomic, strong) NSMenuItem *quitMenuItem;

@end

@implementation BLEMenuItemManager

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
        self.scanMenuItem = [[NSMenuItem alloc] initWithTitle:@"扫描" action:@selector(scanAction:) keyEquivalent:@""];
        [self.scanMenuItem setTarget:self];
        self.unbindMenuItem = [[NSMenuItem alloc] initWithTitle:@"解除绑定" action:@selector(unbindAction:) keyEquivalent:@""];
        [self.unbindMenuItem setTarget:self];
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
    [self.item.menu addItem:self.scanMenuItem];
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

- (void)scanAction:(NSMenuItem *)item {
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSWindowController *scanWindowController = [storyboard instantiateControllerWithIdentifier:@"ScanWindowController"];
    [scanWindowController showWindow:self];
    self.scanWindowController = scanWindowController;
}

- (void)unbindAction:(NSMenuItem *)item {
    // TODO
}

- (void)quitAction:(NSMenuItem *)item {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
