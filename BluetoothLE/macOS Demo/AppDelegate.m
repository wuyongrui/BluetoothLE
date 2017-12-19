//
//  AppDelegate.m
//  macOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "AppDelegate.h"
#import "PIDMenuItemManager.h"
#import "BLEBroadcast.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[PIDMenuItemManager sharedManager] refresh];
    [[BLEBroadcast shared] start];
    [[BLEBroadcast shared] whenAddService:^{
        [[BLEBroadcast shared] startBindedAdvertising];
    }];
}

@end
