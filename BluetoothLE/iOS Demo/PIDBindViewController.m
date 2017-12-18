//
//  PIDBindViewController.m
//  iOS Demo
//
//  Created by midmirror on 2017/12/17.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDBindViewController.h"
#import <BluetoothLE/BluetoothLE.h>

@interface PIDBindViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<BLEDevice *> *devices;

@end

@implementation PIDBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定设备";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.view addSubview:self.tableView];
    
    [[BLE shared] scan];
    [[BLE shared] whenFindBluetoothAll:^(NSDictionary *deviceDict) {
        // 扫描到的蓝牙列表
        self.devices = deviceDict.allValues.copy;
        [self.tableView reloadData];
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[BLE shared] stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifider = NSStringFromClass([UITableViewCell class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifider];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifider];
    }
    BLEDevice *device = self.devices[indexPath.row];
    cell.textLabel.text = device.peripheral.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f m", device.distance.floatValue];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLEDevice *device = self.devices[indexPath.row];
    [[BLE shared] connect:device];
    [[BLE shared] whenConnectSuccess:^{
        
    }];
    [[BLE shared] whenUpdateService:^(CBService *service) {
        // 更新服务（characteristic）
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"BB00"]]) {
                [BLE shared].characteristicWrite = characteristic;
                [self dismiss];
            }
        }
    }];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
