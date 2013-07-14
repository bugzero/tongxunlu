//
//  LoginViewController.m
//  Tongxunlu
//
//  Created by 吴英杰 on 13-6-23.
//  Copyright (c) 2013年 ELVIS zhou. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (){
    UITextField*    _nameTextField;
    UITextField*    _pwdTextField;
    
    BOOL            _select;
}

@end

@implementation LoginViewController

-(id)init{
    if ((self = [super init])) {
        self.showNavigationBar = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark
#pragma -mark viewcontroller action
-(void)loadView{
    UIControl* ctl = [[UIControl alloc]initWithFrame:FULL_VIEW_FRAME];
    
    [ctl addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchDown];
    
    self.view = ctl;
}

-(void)dismissKeyBoard{
    [_nameTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setTitle:@"用户登陆"];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(20,60,280,80)];
    [background shadowColor:RGB(194, 194, 194) shadowOffset:CGSizeMake(0.0f, 0.5f) shadowRadius:3 shadowOpacity:0.6];
    background.image = [[UIImage imageNamed:@"bg_textfeild.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:6];
//    background.userInteractionEnabled = YES;
    
    [self.view addSubview:background];
    
    UILabel * labelNameLable = [[UILabel alloc]initWithFrame:CGRectMake(29,73,60,16)];
    labelNameLable.textAlignment = UITextAlignmentLeft;
    labelNameLable.font = [UIFont systemFontOfSize:16.f];
    labelNameLable.text = @"用户名";
    [self.view addSubview:labelNameLable];
    
    UIView* span = [[UIView alloc]initWithFrame:CGRectMake(labelNameLable.right, labelNameLable.top+2, 1, labelNameLable.height-4)];
    span.backgroundColor = RGB(194, 194, 194);
    [self.view addSubview:span];
    
    //用户名输入框
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 71.f, 200.0f, 22.0f)];
        _nameTextField.font = [UIFont systemFontOfSize:16.f];
        _nameTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.clearButtonMode = YES;
        //_nameTextField.delegate = self;
        _nameTextField.placeholder = @"请输入用户名或手机";
        _nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //_nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kLAST_LOGINED_NAME];
    }
    
    if (!_nameTextField.superview) {
        [self.view addSubview:_nameTextField];
    }
    
    
    UILabel * passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(29,113,60,16)];
    passwordLabel.textAlignment = UITextAlignmentLeft;
    passwordLabel.font = [UIFont systemFontOfSize:16.f];
    passwordLabel.text = @"密    码";
    [self.view addSubview:passwordLabel];
    
    UIView* spanPwd = [[UIView alloc]initWithFrame:CGRectMake(passwordLabel.right, passwordLabel.top+2, 1, passwordLabel.height-4)];
    spanPwd.backgroundColor = RGB(194, 194, 194);
    [self.view addSubview:spanPwd];
    
    //密码输入框
    if (!_pwdTextField) {
        _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 110.f, 200.0f, 22.0f)];
        _pwdTextField.font = [UIFont systemFontOfSize:16.f];
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.placeholder = @"请输入密码";
        _pwdTextField.returnKeyType = UIReturnKeyGo;
        _pwdTextField.clearButtonMode = YES;
    }
    if (!_pwdTextField.superview) {
        [self.view addSubview:_pwdTextField];
    }
    
    
    UIView* spanH = [[UIView alloc]initWithFrame:CGRectMake(background.left, _nameTextField.bottom+5, background.width, 1)];
    spanH.backgroundColor = RGB(194, 194, 194);
    [self.view addSubview:spanH];
    
    UIButton*   autoLoginbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    autoLoginbtn.frame = CGRectMake(30, 155, 20, 20);
    autoLoginbtn.tag = 999;
    [autoLoginbtn setBackgroundImage:[UIImage imageNamed:@"login_protocol_uncheck"] forState:UIControlStateNormal];
    [self.view addSubview:autoLoginbtn];
    [autoLoginbtn addTarget:self action:@selector(remember) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * autoLoginLabel = [[UILabel alloc]initWithFrame:CGRectMake(55,155,75,20)];
    autoLoginLabel.textAlignment = UITextAlignmentLeft;
    autoLoginLabel.font = [UIFont systemFontOfSize:16.f];
    autoLoginLabel.text = @"记住密码";
    [self.view addSubview:autoLoginLabel];
    
    UIButton*   forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(140, 150, 80, 30);
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.textColor = RGB(212,116,13);
    [self.view addSubview:forgetBtn];
    
    
    
    UIButton*   loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(30, 200, 100, 50);
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_register"] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton*   cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(170, 200, 100, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_register_selected"] forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    
    [cancelBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_nameTextField becomeFirstResponder];
}

-(void)dismissAction
{
    [self back];
//    [self back];
}

-(void)remember
{
    UIButton*   autoLoginbtn = (UIButton*)[self.view viewWithTag:999];
    _select = !_select;
    if (_select) {
        [autoLoginbtn setBackgroundImage:[UIImage imageNamed:@"login_protocol_check"] forState:UIControlStateNormal];
    }else{
        [autoLoginbtn setBackgroundImage:[UIImage imageNamed:@"login_protocol_uncheck"] forState:UIControlStateNormal];
    }

}

-(void)loginAction{
    if (isEmptyStr(_nameTextField.text)) {
        [_nameTextField shake];
        [_nameTextField becomeFirstResponder];
    }
    else if(isEmptyStr(_pwdTextField.text)){
        [_pwdTextField shake];
        [_pwdTextField becomeFirstResponder];
    }
    else{
        [[User instance]loginRequest:_nameTextField.text pwd:_pwdTextField.text isRemember:YES];
//        [[User instance]loginRequest:@"test" pwd:@"test"];        
    }

}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}


@end
