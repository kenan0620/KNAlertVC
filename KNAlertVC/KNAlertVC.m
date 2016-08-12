//
//  KNAlertVC.m
//  KNAlertVC
//
//  Created by 柯南 on 16/8/12.
//  Copyright © 2016年 柯南. All rights reserved.
//

#import "KNAlertVC.h"
//#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#pragma mark ----------------私有类 - 单按钮
/*******************私有类 - 单按钮*******************/


@interface MyButton : NSObject
@property (nonatomic,strong) NSString *title;
@property KNAlertBtnType type;
@property (nonatomic,strong) void (^actionHandler)(void *);
@end


@implementation MyButton
@end

#pragma mark ----------------私有类 - 警告视图
/*******************私有类 - 警告视图*******************/

//
// 此类包含引用到打开的警告
// 意思就是说，它不会被ARC给销毁
// 直到它被你dismissed -  单击按钮
// 这是一个单独的类，生命周期为整个应用的生命
// 每次警告都会生成一个唯一的ID
//
@interface AlertManager : NSObject<UIAlertViewDelegate>

+(id)SharedManager;

+(NSInteger)nextIndex;

+(void)AddMyAlertMessage:(KNAlertVC *)msg;

+(void)RemoveMyAlertMessage:(KNAlertVC *)msg;

@end


@implementation AlertManager
{
    NSInteger _nextMsgIndex;
    NSMutableDictionary *_msgs;
}
//静态方法来获取单一实例
+(id)SharedManager
{
    static AlertManager *sharedSingletonAlert = nil;
    @synchronized(self)
    {
        if(sharedSingletonAlert == nil)
        {
            sharedSingletonAlert = [[AlertManager alloc] init];
        }
    }
    return sharedSingletonAlert;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _msgs = [[NSMutableDictionary alloc] init];
        _nextMsgIndex = 0;
    }
    
    return self;
}

+(NSInteger)nextIndex
{
    AlertManager *m = [AlertManager SharedManager];
    
    
    NSInteger i = m->_nextMsgIndex;
    m->_nextMsgIndex++;
    return i;
}

+(void)AddMyAlertMessage:(KNAlertVC *)msg
{
    AlertManager *m = [AlertManager SharedManager];
    
    [m->_msgs setObject:msg forKey:[NSNumber numberWithInteger:msg.ID]];
}

+(void)RemoveMyAlertMessage:(KNAlertVC *)msg
{
    AlertManager *m = [AlertManager SharedManager];
    
    NSNumber *index = [NSNumber numberWithInteger:msg.ID];
    
    [m->_msgs removeObjectForKey:index];
}


@end

#pragma mark ----------------公有类 - 警报消息
/*******************公有类 - 警报消息 *******************/
@interface KNAlertVC ()

-(void)show8;

@end
@implementation KNAlertVC
{
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        _buttons = [[NSMutableArray alloc] init];
        _title = @"";
        _message = @"";
        _ID = [AlertManager nextIndex];
    }
    
    return self;
}
/** 初始化调用方法*/
-(id)initWithTitle:(NSString *)title WithMessage:(NSString *)msg
{
    self = [super init];
    if (self != nil)
    {
        _buttons = [[NSMutableArray alloc] init];
        
        _title = title;
        _message = msg;
        _ID = [AlertManager nextIndex];
    }
    
    return self;
}
/** 添加按钮及点击事件Block*/
-(void)addButton:(KNAlertBtnType)type WithTitle:(NSString *)title WithAction:(void (^)(void *action))handler
{
    MyButton *btn = [[MyButton alloc] init];
    
    btn.title = title;
    btn.type = type;
    btn.actionHandler = handler;
    
    [_buttons addObject:btn];
    
}

-(void)show
{
    
    [self show8];
    
    
}

-(void)show8
{
    //iOS >= 8
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:_title
                                                                             message:_message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    //虽然没用，但是可以用它来保持iOS7的逻辑
    [AlertManager AddMyAlertMessage:self];
    
    for (MyButton *btn in _buttons)
    {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        
        if (btn.type == ALERT_BUTTON_CANCEL) style = UIAlertActionStyleCancel;
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:btn.title style:style handler:^(UIAlertAction *action) {
            if (btn.actionHandler == nil) {
                
            }else
                btn.actionHandler((__bridge void *)(action));
            [AlertManager RemoveMyAlertMessage:self];
        }];
        
        [alertController addAction:alertAction];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
#ifdef TARGET_IS_EXTENSION
        
#else
        UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
        [top presentViewController:alertController animated:YES completion:nil];
#endif
    });
    
}


@end
