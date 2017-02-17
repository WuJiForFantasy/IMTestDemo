//
//  LoginController.m
//  IMTestDemo
//
//  Created by tqh on 2017/2/14.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "LoginController.h"
#import "WJIMChatKeyBoardToolBar.h"
#import "WJIMChatKeyBoard.h"

@interface LoginController ()

@property (nonatomic,strong) UITextField *textFeild;    //输入框
@property (nonatomic,strong) UIButton *button;          //按钮
@property (nonatomic,strong) WJIMChatKeyBoard *tool;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textFeild];
    [self.view addSubview:self.button];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tool = [[WJIMChatKeyBoard alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 40, CGRectGetWidth(self.view.bounds), 200)];
//    self.tool.toolBarTopY = 100;
    [self.view addSubview:self.tool];
    
}

#pragma mark - 事件监听

- (void)buttonPressed {
    WJIMMainManagerLoginModel *model = [[WJIMMainManagerLoginModel alloc]init];
    model.userName = self.textFeild.text;
    model.password = @"123";
    
    [[WJIMMainManager shareManager] loginWithLoginModel:model finish:nil];
    
//    [WJIMMainManager loginWithLoginModel:model finish:^(BOOL sucess, EMError *error, WJIMMainManagerLoginModel *model) {
//        
//        
////        NSLog(@"%@登录%@",model.userName,sucess ? @"成功" : @"失败");
////        [[NSUserDefaults standardUserDefaults] setObject:model.userName forKey:@"user"];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////        
////        //登录成功刷新小红点
////        NSInteger count = [[WJIMMainManager shareManager] getAllUnreadMessageCount];
////        NSLog(@"所有未读消息:%ld",count);
////        if (count > 0) {
////            self.mainController.viewControllers[0].tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)count];
////        }else{
////            self.mainController.viewControllers[0].tabBarItem.badgeValue = nil;
////        }
////        UIApplication *application = [UIApplication sharedApplication];
////        [application setApplicationIconBadgeNumber:count];
//    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//    [self.tool resetKeyBoard];
}

#pragma mark - 懒加载

- (UITextField *)textFeild {
    if (!_textFeild) {
        _textFeild = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
        _textFeild.layer.borderWidth = 1;
        _textFeild.backgroundColor = [UIColor yellowColor];
    }
    return _textFeild;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        _button.frame = CGRectMake(100, 200, 100, 30);
        _button.backgroundColor = [UIColor redColor];
        [_button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
