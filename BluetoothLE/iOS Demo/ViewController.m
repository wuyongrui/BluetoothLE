//
//  ViewController.m
//  iOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "ViewController.h"
#import <BluetoothLE/BluetoothLE.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BLE shared] scan];
    [[BLE shared] whenFindBluetoothAll:^(NSDictionary *peripheralDict) {
        [[BLE shared] connect:peripheralDict.allValues.firstObject];
    }];
    [[BLE shared] whenConnectSuccess:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
