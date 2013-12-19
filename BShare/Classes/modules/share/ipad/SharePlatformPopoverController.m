//
//  ShareForiPadViewController.m
//  iVideoForiPad
//
//  Created by tvie on 13-11-18.
//  Copyright (c) 2013年 tvie. All rights reserved.
//

#import "SharePlatformPopoverController.h"
#import "SlidingNavigationController.h"
#import "ShareModalViewController.h"

@interface SharePlatformPopoverController ()
@property (nonatomic, strong) NSArray *sharePlatforms;
@end

@implementation SharePlatformPopoverController

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sharePlatforms = [ShareUtils bindPlatforms];
    [self setup];
}
- (void)setup{
    int numOfLine = 4;
    float padding = (self.contentView.bounds.size.width - numOfLine*SHARE_ICON_WIDTH)/(numOfLine+1);
    NSArray *sharePlatforms = [ShareUtils platforms];
    int n = [sharePlatforms count];
    CGRect rect = CGRectMake(0, 0, SHARE_ICON_WIDTH, SHARE_ICON_WIDTH+20);
    NSMutableArray *shareViews = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < n; i++) {
        int line = i/numOfLine;
        int column = i%numOfLine;
        rect = CGRectMake(column*(rect.size.width+padding)+padding, line*(rect.size.height+10)+padding, rect.size.width, rect.size.height);
        
        SharePlatform *platform = [sharePlatforms objectAtIndex:i];
        BImageView *iconView = /*AUTORELEASE*/([[BImageView alloc] initWithFrame:rect]);
        [iconView addTarget:self action:@selector(shareWithPlatform:)];
        [iconView setTitleStyle:BImageTitleStyleBelow];
        [iconView setImageURL:platform.icon];
        iconView.titleLabel.text = platform.name;
        iconView.titleLabel.textColor = gDescColor;
        iconView.titleLabel.shadowColor = nil;
        iconView.object = platform;
        [shareViews addObject:iconView];
        [self.contentView addSubview:iconView];
    }

}
- (IBAction)shareWithPlatform:(id)sender{
    SharePlatform *platform = [sender object];
    self.autoShare = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharePlatformPopoverController:willSelectSharePlatform:)]) {
        [self.delegate sharePlatformPopoverController:self willSelectSharePlatform:platform];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharePlatformPopoverController:didSelectedSharePlatform:)]) {
        [self.delegate sharePlatformPopoverController:self didSelectedSharePlatform:platform];
    }
    if(self.autoShare){
        ShareModalViewController *vc = [[ShareModalViewController alloc] init];
        vc.shareViewType = ShareViewTypeShare;
        vc.autoSend = YES;
        vc.sharePlatform = platform;
        vc.imagePath = self.shareImagePath;
        vc.shareTitle = self.shareTitle;
        vc.content = self.shareContent;
        SlidingNavigationController *nav = [[SlidingNavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentModalViewController:nav animated:YES];
    }
    [self.popover dismissPopoverAnimated:YES];
}
@end
