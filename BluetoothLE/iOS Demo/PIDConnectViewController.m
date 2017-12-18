//
//  PIDConnectViewController.m
//  iOS Demo
//
//  Created by Robin on 2017/12/17.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDConnectViewController.h"
#import <BluetoothLE/BluetoothLE.h>
#import "ViewController.h"

@interface PIDConnectViewController ()

@property (nonatomic, strong) BLEDevice *device;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nameTipLabel;
@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *warnLabel;
@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) UIButton *cancleButton;

- (void)commonInit;
- (void)viewTap;
- (void)connectClick;
- (void)cancleClick;
- (void)prepareBlueTooth;

@end

@implementation PIDConnectViewController

- (instancetype)initWithDevice:(BLEDevice *)device
{
    if (self = [super init]) {
        _device = device;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commonInit];
    [self prepareBlueTooth];
}

- (void)commonInit
{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.nameLabel];
    self.nameLabel.text = self.device.peripheral.name;
    [self.view addSubview:self.nameTipLabel];
    [self.view addSubview:self.accountTextField];
    NSRange range = [self.device.peripheral.name rangeOfString:@"的"];
    if (range.location == NSNotFound) {
        range.location = 5;
    }
    self.accountTextField.text = [self.device.peripheral.name substringToIndex:range.location];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.warnLabel];
    [self.view addSubview:self.connectButton];
    [self.view addSubview:self.cancleButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewTap
{
    [self.view endEditing:YES];
}

- (void)connectClick
{
    [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:self.device.peripheral.name];
    [[BLE shared] connect:self.device];
}

- (void)cancleClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareBlueTooth
{
    [[BLE shared] whenConnectSuccess:^{
        NSLog(@"连接成功");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[ViewController new] animated:YES];
        });
    }];
    [[BLE shared] whenConnectFailure:^{
        NSLog(@"连接失败");
    }];
}

#pragma mark - getter

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
        _backgroundImageView.frame = self.view.bounds;
    }
    return _backgroundImageView;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 34)];
        _nameLabel.font = [UIFont systemFontOfSize:30];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    }
    return _nameLabel;
}

- (UILabel *)nameTipLabel
{
    if (!_nameTipLabel) {
        _nameTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 268, self.view.frame.size.width, 18)];
        _nameTipLabel.font = [UIFont systemFontOfSize:16];
        _nameTipLabel.textAlignment = NSTextAlignmentCenter;
        _nameTipLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        _nameTipLabel.text = @"请输入您的Mac登录密码";
    }
    return _nameTipLabel;
}

- (UITextField *)accountTextField{
    if(!_accountTextField){
        CGFloat pad = 30, height = 45;
        _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(pad, 310, self.view.frame.size.width - 2 * pad, height)];
        _accountTextField.font = [UIFont systemFontOfSize:22];
        _accountTextField.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_icon"]];
        icon.contentMode = UIViewContentModeCenter;
        icon.frame = CGRectMake(0, 0, 50, height);
        _accountTextField.leftView = icon;
        _accountTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, height - 1, _accountTextField.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [_accountTextField addSubview:line];
    }
    return _accountTextField;
}

- (UITextField *)passwordTextField{
    if(!_passwordTextField){
        CGFloat pad = 30, height = 45;
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(pad, 375, self.view.frame.size.width - 2 * pad, height)];
        _passwordTextField.font = [UIFont systemFontOfSize:22];
        _passwordTextField.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _passwordTextField.secureTextEntry = YES;
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock_icon"]];
        icon.contentMode = UIViewContentModeCenter;
        icon.frame = CGRectMake(0, 0, 50, height);
        _passwordTextField.leftView = icon;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, height - 1, _passwordTextField.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [_passwordTextField addSubview:line];
    }
    return _passwordTextField;
}

- (UILabel *)warnLabel
{
    if (!_warnLabel) {
        _warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 430, self.view.frame.size.width, 40)];
        _warnLabel.font = [UIFont systemFontOfSize:16];
        _warnLabel.textAlignment = NSTextAlignmentCenter;
        _warnLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
        _warnLabel.numberOfLines = 0;
        _warnLabel.text = @"数据已加密\n并仅存储在您的设备中";
    }
    return _warnLabel;
}

- (UIButton *)connectButton{
    if(!_connectButton){
        CGFloat pad = 30, height = 45;
        _connectButton = [[UIButton alloc] initWithFrame:CGRectMake(pad, 550, self.view.frame.size.width - 2 * pad, height)];
        _connectButton.layer.cornerRadius = height / 2.;
        _connectButton.backgroundColor = [UIColor colorWithRed:53/255. green:124/255. blue:220/255. alpha:1];
        _connectButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [_connectButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateNormal];
        [_connectButton setTitle:@"连接" forState:UIControlStateNormal];
        [_connectButton addTarget:self action:@selector(connectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectButton;
}

- (UIButton *)cancleButton{
    if(!_cancleButton){
        CGFloat pad = 30, height = 45;
        _cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(pad, 610, self.view.frame.size.width - 2 * pad, height)];
        _cancleButton.layer.cornerRadius = height / 2.;
        _cancleButton.backgroundColor = [UIColor colorWithRed:53/255. green:124/255. blue:220/255. alpha:1];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [_cancleButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateNormal];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}



@end
