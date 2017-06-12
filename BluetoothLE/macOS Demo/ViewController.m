//
//  ViewController.m
//  macOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "ViewController.h"
#import <BluetoothLE/BluetoothLE.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[BluetoothLE shared] initBluetooth];
    [[BluetoothLE shared] scanBluetooth];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
