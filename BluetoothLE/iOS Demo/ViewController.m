//
//  ViewController.m
//  iOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "ViewController.h"
#import <BluetoothLE/BluetoothLE.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) BOOL isConnected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"锁定 Mac", @"解锁 Mac"];
    [self.view addSubview:self.tableView];
    self.isConnected = YES;
//    [[BLE shared] scan];
//    [[BLE shared] whenFindBluetooth:^(BLEDevice *device) {
//        // 扫描的的蓝牙
//        NSLog(@"name:%@ uuid:%@ advertisement:%@", device.peripheral.name, device.peripheral.identifier.UUIDString, device.advertisementData);
//        if ([device.peripheral.name isEqualToString:@"XiangLiang's MBP"]) {
//            [[BLE shared] connect:device];
//        }
//    }];
//    [[BLE shared] whenFindBluetoothAll:^(NSDictionary *deviceDict) {
//        // 扫描到的蓝牙列表
//    }];
//    [[BLE shared] whenConnectSuccess:^{
//        // 连接成功
//        self.isConnected = YES;
//        [self.tableView reloadData];
//    }];
//    [[BLE shared] whenConnectFailure:^{
//        // 连接失败
//    }];
//    [[BLE shared] whenUpdateService:^(CBService *service) {
//        // 更新服务（characteristic）
//        for (CBCharacteristic *characteristic in service.characteristics) {
//            NSLog(@"characteristic:%@",characteristic);
//        }
//    }];
//    [[BLE shared] send:[[NSData alloc] init]];
//    [[BLE shared] whenSendProgressUpdate:^(NSNumber *progress) {
//       // 数据发送进度
//    }];
//    [[BLE shared] whenSendSuccess:^{
//       // 数据发送成功
//    }];
//    [[BLE shared] whenSendFailure:^{
//       // 数据发送失败
//    }];
//    [[BLE shared] whenReceiveData:^(NSData *data) {
//       // 接收到蓝牙返回的数据
//    }];
//    [[BLE shared] unconnect];
//    [[BLE shared] whenUnconnect:^{
//       // 已断开
//    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = self.isConnected ? [UIColor blackColor] : [UIColor grayColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isConnected) {
        if (indexPath.row == 0) {
            NSData *lockData = [NSData dataWithBytes:"\x0a\x0b" length:2];
            [[BLE shared] send:lockData];
        } else if (indexPath.row == 1) {
            NSString *password = @"650779";
            NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
            [[BLE shared] send:passwordData];
        }
    }
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

@end
