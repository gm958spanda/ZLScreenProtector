//
//  ZLScreenProtector.m
//  ZLScreenProtector
//
//  Created by zxs.zl on 2019/2/11.
//  Copyright © 2019 zxs.zl. All rights reserved.
//

#import "ZLScreenProtector.h"
#import <UIKit/UIKit.h>

@interface ZLScreenProtector()
{
    BOOL _running;
    UIWindow *_blurWindow;
}
@end

@implementation ZLScreenProtector

+(instancetype)shareIns
{
    static ZLScreenProtector *s = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s = [[ZLScreenProtector alloc] init];
    });
    return s;
}

-(void)run
{
    _running = YES;
    [self p_addObserver];
}
-(void)stop
{
    _running = NO;
    _blurWindow = nil;
}
#pragma private method
-(void)p_addObserver
{
    //即将进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //进入活动状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_BecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //进入非活动状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_ResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)p_willEnterForeground:(id)msg
{//即将进入前台
    _blurWindow = nil;
}

-(void)p_didEnterBackground:(id)msg
{//进入后台
    [self p_blurScreen];
}

-(void)p_BecomeActive:(id)msg
{//即将进入前台
    _blurWindow = nil;
}

-(void)p_ResignActive:(id)msg
{//即将进入前台
    [self p_blurScreen];
}

-(void)p_blurScreen
{
    if (!_running)
        return;
    
    if (!_blurWindow)
    {
        UIWindow *currWin = [self p_getVisiableWindow];
        _blurWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _blurWindow.windowLevel = currWin.windowLevel; //windown级别，级别越高，越在视图上层
        [_blurWindow makeKeyAndVisible];
        
        //建议使用UIBlurEffectStyleExtraLight 或 UIBlurEffectStyleDark
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
        blurView.frame = _blurWindow.bounds;

        [_blurWindow addSubview:blurView];
    }
}
-(UIWindow *)p_getVisiableWindow
{
    UIWindow *w = nil;
    for (UIWindow *tmp in [UIApplication sharedApplication].windows)
    {
        if (tmp.hidden || tmp.alpha < 0.01)
            continue;
        
        if (!w)
        {
            w = tmp;
        }
        else if (w.windowLevel <= tmp.windowLevel )
        {
            w = tmp;
        }
    }
    return w;
}
@end
