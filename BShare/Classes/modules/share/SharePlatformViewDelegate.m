//
//  SharePlatformViewDelegate.m
//  iShow
//
//  Created by baboy on 13-6-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SharePlatformViewDelegate.h"
#import "UINavigationBar+x.h"
@implementation SharePlatformViewDelegate
+ (id)defaultDelegate{
    static id _defaultSharePlatformViewDelegate = nil;
    static dispatch_once_t initOnceHttpRequestClient;
    dispatch_once(&initOnceHttpRequestClient, ^{
        _defaultSharePlatformViewDelegate = [[SharePlatformViewDelegate alloc] init];
    });
    return _defaultSharePlatformViewDelegate;
}
#pragma mark - ISSShareViewDelegate

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    UINavigationBar *navigationBar = viewController.navigationController.navigationBar;
    if ([navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        UIImage *navigationBarBackground = gNavBarBackgroundImage;
        if (navigationBarBackground)
            [navigationBar setBackgroundImage:navigationBarBackground forBarMetrics:UIBarMetricsDefault];
    }
    //[viewController.navigationController.navigationBar setBackgroundImage:];
    viewController.navigationItem.rightBarButtonItem = nil;
    UIButton *btn = (id)viewController.navigationItem.leftBarButtonItem.customView;
    UIButton *backBtn = [Theme buttonForKey:@"navigationbar-back-button"];
    btn.frame = backBtn.frame;
    [btn setImage:[backBtn imageForState:UIControlStateNormal] forState:UIControlStateNormal];
}

- (void)view:(UIViewController *)viewController autorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation shareType:(ShareType)shareType
{
    
}

@end
