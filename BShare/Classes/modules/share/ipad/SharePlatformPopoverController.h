//
//  ShareForiPadViewController.h
//  iVideoForiPad
//
//  Created by tvie on 13-11-18.
//  Copyright (c) 2013年 tvie. All rights reserved.
//

#import "AppBaseViewController.h"
#import "SharePlatformView.h"
#import "UIPopoverCustomBackgroundView.h"

@class SharePlatformPopoverController;
@protocol SharePlatformPopoverControllerDelegate <NSObject>
@optional
- (void)sharePlatformPopoverController:(SharePlatformPopoverController*)controller willSelectSharePlatform:(SharePlatform *)platform;
- (void)sharePlatformPopoverController:(SharePlatformPopoverController*)controller didSelectedSharePlatform:(SharePlatform *)platform;
@end

@interface SharePlatformPopoverController : AppBaseViewController
@property (nonatomic, strong) UIPopoverController *popover;
@property (nonatomic, assign) BOOL autoShare;
@property (nonatomic, strong) NSString *shareImagePath;
@property (nonatomic, strong) IBOutlet UIScrollView *contentView;
@property (nonatomic, strong) id<SharePlatformPopoverControllerDelegate>delegate;
@end

