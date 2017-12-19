//
//  AppDelegate.m
//  macOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "AppDelegate.h"
#import "BLEMenuItemManager.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[BLEMenuItemManager sharedManager] refresh];
}

@end
