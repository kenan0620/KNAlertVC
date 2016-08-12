//
//  KNAlertVC.h
//  KNAlertVC
//
//  Created by 柯南 on 16/8/12.
//  Copyright © 2016年 柯南. All rights reserved.
//

/**
 使用方法
 
 KNAlertVC * a = [[KNAlertVC alloc] initWithTitle:@"警告" WithMessage:@"你有条警告"];
 
 [a addButton:ALERT_BUTTON_OK WithTitle:@"好的" WithAction:^(void *action) {
 NSLog(@"你点击了 index 为 0 的  好的");
 }];
 [a addButton:ALERT_BUTTON_CANCEL WithTitle:@"取消" WithAction:^(void *action) {
 NSLog(@"你点击了 index 为 1 的  取消");
 }];
 [a show];
 
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum KNAlertBtnType
{
    ALERT_BUTTON_OK,
    ALERT_BUTTON_CANCEL,
    ALERT_BUTTON_OTHER
    
} KNAlertBtnType;


@interface KNAlertVC : NSObject


@property (readonly) NSMutableArray *buttons;
@property (readonly) NSInteger ID;
/** 标题*/
@property NSString *title;
/** 信息*/
@property NSString *message;


-(id)init;
/** 初始化调用方法*/
-(id)initWithTitle:(NSString *)title WithMessage:(NSString *)msg;
/** 添加按钮及点击事件Block*/
-(void)addButton:(KNAlertBtnType)type WithTitle:(NSString *)title WithAction:(void (^)(void *action))handler;


-(void)show;




@end
