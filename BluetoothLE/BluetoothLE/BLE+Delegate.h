//
//  BluetoothLE+Delegate.h
//  BluetoothLE
//
//  Created by ios on 15/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import <BluetoothLE/BLE.h>

@interface BLE (Delegate)

- (void)centralManagerDidUpdateState:(CBCentralManager *)central;

@end
