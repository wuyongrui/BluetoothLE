//
//  BluetoothLE.h
//  BluetoothLE
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

#import <Foundation/NSObjCRuntime.h>

//! Project version number for BluetoothLE.
FOUNDATION_EXPORT double BluetoothLEVersionNumber;

//! Project version string for BluetoothLE.
FOUNDATION_EXPORT const unsigned char BluetoothLEVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BluetoothLE/PublicHeader.h>

#import <BluetoothLE/BLE.h>
#import <BluetoothLE/BLE+Delegate.h>
#import <BluetoothLE/BLE+SendData.h>
