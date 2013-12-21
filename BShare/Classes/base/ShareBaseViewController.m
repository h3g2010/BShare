//
//  AppBaseViewController.m
//  iShow
//
//  Created by baboy on 13-5-5.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "ShareBaseViewController.h"


@interface ShareBaseViewController ()

@end

@implementation ShareBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)shareWithTitle:(NSString *)title withUrl:(NSString *)url withContent:(NSString *)content withImagePath:(NSString *)imagePath{
    SharePlatformView *sharePlatformView = [SharePlatformView sharePlatformView];
    [sharePlatformView setAutoShare:YES];
    [sharePlatformView setShareContent:content];
    [sharePlatformView setShareImagePath:imagePath];
    [sharePlatformView setShareUrl:url];
    [sharePlatformView setShareTitle:title];
    [sharePlatformView show];

}
- (void)shareWithContent:(NSString *)content withImagePath:(NSString *)imagePath{
    [self shareWithTitle:nil withUrl:nil withContent:content withImagePath:imagePath];
}
- (void)commentWithPlaceholders:(NSString *)placeholders{
    ShareView *shareView = [ShareView shareView];
    [shareView setTitle:NSLocalizedString(@"评论", nil)];
    [shareView setDelegate:self];
    [shareView setShowCountLabel:YES];
    [shareView setMaxTextLength:MaxCommentTextLength];
    [shareView setShareViewType:ShareViewTypeComment];
    [shareView show];
}

@end
