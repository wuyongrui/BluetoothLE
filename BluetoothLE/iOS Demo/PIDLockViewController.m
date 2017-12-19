//
//  ViewController.m
//  iOS Demo
//
//  Created by ios on 12/06/2017.
//  Copyright © 2017 midmirror. All rights reserved.
//

#import "PIDLockViewController.h"
#import <BluetoothLE/BluetoothLE.h>

@interface PIDLockViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) BOOL isConnected;

@end

@implementation PIDLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Phone ID";
    self.titles = @[@"锁定 Mac", @"解锁 Mac"];
    [self.view addSubview:self.tableView];

    self.isConnected = YES;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BLEData *data = [BLEData new];
    if (indexPath.row == 0) {
        [[BLE shared] send:data.lockData];
    } else if (indexPath.row == 1) {
        [[BLE shared] send:data.unlockData];
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
