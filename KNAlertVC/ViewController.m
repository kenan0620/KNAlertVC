//
//  ViewController.m
//  KNAlertVC
//
//  Created by 柯南 on 16/8/12.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "ViewController.h"
#import "KNAlertVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    KNAlertVC * a = [[KNAlertVC alloc] initWithTitle:@"警告" WithMessage:@"你有条警告"];
    
    [a addButton:ALERT_BUTTON_OK WithTitle:@"好的" WithAction:^(void *action) {
        NSLog(@"你点击了 index 为 0 的  好的");
    }];
    [a addButton:ALERT_BUTTON_CANCEL WithTitle:@"取消" WithAction:^(void *action) {
        NSLog(@"你点击了 index 为 1 的  取消");
    }];
    [a show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
