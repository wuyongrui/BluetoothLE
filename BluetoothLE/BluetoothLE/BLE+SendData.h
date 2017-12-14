//
//  BLE+SendData.h
//  BluetoothLE
//
//  Created by ios on 15/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import <BluetoothLE/BluetoothLE.h>

@interface BLE (SendData)

/**
 * 发送数据
 */
- (void)send:(NSData *)data;
- (void)sendNext:(NSData *)data;

@end
