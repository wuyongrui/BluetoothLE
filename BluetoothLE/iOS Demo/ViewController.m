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
    
    [[BluetoothLE shared] initBluetooth];
    [[BluetoothLE shared] scanBluetooth];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
