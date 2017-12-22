//
//  BLELockManager.m
//  macOS Demo
//
//  Created by 许向亮 on 2017/12/14.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "BLELockManager.h"

@interface BLELockManager()

@end

@implementation BLELockManager

+ (BOOL)isLocked
{
    BOOL locked = NO;
    
    CFDictionaryRef CGSessionCurrentDictionary = CGSessionCopyCurrentDictionary();
    id o = [(__bridge NSDictionary*)CGSessionCurrentDictionary objectForKey:@"CGSSessionScreenIsLocked"];
    if (o) {
        locked = [o boolValue];
    }
    CFRelease(CGSessionCurrentDictionary);
    
    return locked;
}

+ (void)lock
{
    if ([self isLocked]) return;
    
    // get user's old setting
//    BOOL screensaverAskForPassword = [self getScreensaverAskForPassword];
//    NSInteger screensaverDelay = [self getScreensaverDelay];
    
    // set the new setting for locking operation
    [self setScreensaverAskForPassword:YES];    // ask for password to unlock
    [self setScreensaverDelay:0];               // show login window immediately
    
    // shutdown display to idle status
    io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
    if (r) {
        IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanTrue);
        IOObjectRelease(r);
    }
    
    // show login window 1s after display idle
//    double delayInSeconds = 1.0; // longer or shorter are both not good.
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
//        // wakeup display from idle status to show login window
//        io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
//        if (r) {
//            IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanFalse);
//            IOObjectRelease(r);
//        }
//
//        // restore user's old setting, the old setting only takes effect after next display idle.
//        [self setScreensaverAskForPassword:screensaverAskForPassword];
//        [self setScreensaverDelay:screensaverDelay];
//    });
    sleep(1);
}

+ (void)unlock:(NSString *)password
{
    if (![self isLocked]) return;
    io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
    if (r) {
        IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanFalse);
        IOObjectRelease(r);
    }
    // use Apple Script to input password and unlock Mac
    NSString *s = @"tell application \"System Events\" to keystroke \"%@\"\n\
    tell application \"System Events\" to keystroke return";
    
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:s, password]];
    [script executeAndReturnError:nil];
    sleep(1);
}

+ (void)lightScreen {
    if (![self isLocked]) return;
    io_registry_entry_t r = IORegistryEntryFromPath(kIOMasterPortDefault, "IOService:/IOResources/IODisplayWrangler");
    if (r) {
        IORegistryEntrySetCFProperty(r, CFSTR("IORequestIdle"), kCFBooleanFalse);
        IOObjectRelease(r);
    }
    NSString *s = @"tell application \"System Events\" to keystroke return";
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:s];
    [script executeAndReturnError:nil];
}

#pragma mark - private

+ (NSInteger)getScreensaverDelay
{
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screensaver"];
    return [[prefs objectForKey:@"askForPasswordDelay"] integerValue];
}

+ (BOOL)getScreensaverAskForPassword
{
    NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screensaver"];
    return [[prefs objectForKey:@"askForPassword"] boolValue];
}

+ (void)setScreensaverDelay:(NSInteger)value
{
    NSMutableDictionary *prefs = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screensaver"] mutableCopy];
    [prefs setValue:[NSString stringWithFormat:@"%li", value] forKey:@"askForPasswordDelay"];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:@"com.apple.screensaver"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setScreensaverAskForPassword:(BOOL)value
{
    NSMutableDictionary *prefs = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.screensaver"] mutableCopy];
    [prefs setValue:[NSString stringWithFormat:@"%hhi", value] forKey:@"askForPassword"];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:@"com.apple.screensaver"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSAppleScript *kickSecurityPreferencesScript = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:@"tell application \"System Events\" to tell security preferences to set require password to wake to %@", value ? @"true" : @"false"]];
    [kickSecurityPreferencesScript executeAndReturnError:nil];
}

@end
