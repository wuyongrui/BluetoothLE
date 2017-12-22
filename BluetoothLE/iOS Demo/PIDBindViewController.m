//
//  PIDBindViewController.m
//  iOS Demo
//
//  Created by Robin on 2017/12/17.
//  Copyright © 2017年 midmirror. All rights reserved.
//

#import "PIDBindViewController.h"
#import <BluetoothLE/BluetoothLE.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "PIDMacro.h"
#import "BLEData.h"
#import "PIDStatusViewController.h"

@interface PIDBindViewController ()

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

@end

@implementation PIDBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self commonInit];
}

- (void)commonInit
{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.nameLabel];
    self.nameLabel.text = [BLE shared].currentDevice.peripheral.name;
    [self.view addSubview:self.nameTipLabel];
//    [self.view addSubview:self.accountTextField];
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
    NSString *password = self.passwordTextField.text;
    BLEData *bleData = [BLEData new];
    
    [[BLE shared] whenReceiveData:^(NSData *data) {
        if ([data isEqualToData:bleData.bindSuccessData]) {
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            [BLE shared].currentDevice.password = password;
            [bleData storeBindedDevice:[BLE shared].currentDevice];
            PIDStatusViewController *statusVC = [[PIDStatusViewController alloc] init];
            [self.navigationController setViewControllers:@[statusVC] animated:YES];
        } else if ([data isEqualToData:bleData.bindFailureData]) {
            [SVProgressHUD showErrorWithStatus:@"密码错误"];
            self.passwordTextField.text = @"";
        }
    }];
    if (password.length > 0) {
        NSMutableData *unlockData = [[NSMutableData alloc] init];
        [unlockData appendData:bleData.bindData];
        [unlockData appendData:[password dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"密码：%@，密码数据:%@ 解锁数据:%@",password, [password dataUsingEncoding:NSUTF8StringEncoding], unlockData);
        [[BLE shared] send:unlockData];
    }
}

- (void)cancleClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PIDRealHeight(210), self.view.frame.size.width, 34)];
        _nameLabel.font = [UIFont systemFontOfSize:30];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6];
    }
    return _nameLabel;
}

- (UILabel *)nameTipLabel
{
    if (!_nameTipLabel) {
        _nameTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PIDRealHeight(248), self.view.frame.size.width, 18)];
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
        CGFloat pad = PIDRealWidth(30), height = PIDRealHeight(45), iconWidth = PIDRealWidth(50);
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(pad, PIDRealHeight(290), self.view.frame.size.width - 2 * pad, height)];
        _passwordTextField.font = [UIFont systemFontOfSize:22];
        _passwordTextField.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _passwordTextField.secureTextEntry = YES;
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock_icon"]];
        icon.contentMode = UIViewContentModeCenter;
        icon.frame = CGRectMake(0, 0, iconWidth, height);
        _passwordTextField.leftView = icon;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(iconWidth, height - 1, _passwordTextField.frame.size.width - iconWidth, 1)];
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [_passwordTextField addSubview:line];
    }
    return _passwordTextField;
}

- (UILabel *)warnLabel
{
    if (!_warnLabel) {
        _warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, PIDRealHeight(350), self.view.frame.size.width, 40)];
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
        CGFloat pad = PIDRealWidth(30), height = PIDRealHeight(42);
        _connectButton = [[UIButton alloc] initWithFrame:CGRectMake(pad, PIDRealHeight(520), self.view.frame.size.width - 2 * pad, height)];
        _connectButton.layer.cornerRadius = height / 2.;
        _connectButton.backgroundColor = [UIColor colorWithRed:53/255. green:124/255. blue:220/255. alpha:1];
        _connectButton.titleLabel.font = [UIFont systemFontOfSize:PIDRealWidth(22)];
        [_connectButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateNormal];
        [_connectButton setTitle:@"连接" forState:UIControlStateNormal];
        [_connectButton addTarget:self action:@selector(connectClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectButton;
}

- (UIButton *)cancleButton{
    if(!_cancleButton){
        CGFloat pad = PIDRealWidth(30), height = PIDRealHeight(42);
        _cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(pad, PIDRealHeight(580), self.view.frame.size.width - 2 * pad, height)];
        _cancleButton.layer.cornerRadius = height / 2.;
        _cancleButton.backgroundColor = [UIColor colorWithRed:53/255. green:124/255. blue:220/255. alpha:1];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:PIDRealWidth(22)];
        [_cancleButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.8] forState:UIControlStateNormal];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(cancleClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}



@end
