//
//  SharePlatformView.m
//  iShow
//
//  Created by baboy on 13-7-2.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "SharePlatformView.h"


@interface SharePlatformView()
@property (nonatomic, retain) NSArray *shareViews;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIButton *cancelBtn;
@end

@implementation SharePlatformView
- (void)dealloc{
    /*
    RELEASE(_backgroundView);
    RELEASE(_shareViews);
    RELEASE(_contentView);
    RELEASE(_cancelBtn);
    RELEASE(_shareContent);
    RELEASE(_shareImagePath);
    [super dealloc];
     */
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}
- (id)init
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self = [self initWithFrame:window.bounds];
    if (self) {
    }
    return self;
}
- (void)setContentViewShadow{
    CALayer *layer = self.contentView.layer;
    [layer setShadowColor:gShadowColor.CGColor];
    [layer setShadowOffset:CGSizeMake(0, -1)];
    [layer setShadowRadius:2.0];
    [layer setShadowOpacity:1.0];
}
- (UIView *)container{
    return [[UIApplication sharedApplication] keyWindow];
}
- (void)setup{
    if (self.contentView) {
        return;
    }
    self.backgroundView = /*AUTORELEASE*/([[UIView alloc] initWithFrame:self.bounds]);
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.backgroundView];
    
    UITapGestureRecognizer *tap = /*AUTORELEASE*/([[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)]);
    [self.backgroundView addGestureRecognizer:tap];
    
    UIView *container = [self container];
    CGRect contentViewFrame = CGRectMake(0, 0, container.bounds.size.width, 2000);
    self.contentView = /*AUTORELEASE*/([[UIView alloc] initWithFrame:contentViewFrame]);
    self.contentView.backgroundColor = [Theme colorForKey:@"shareplatform-view-background"];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    int numOfLine = 4;
    float padding = (contentViewFrame.size.width - numOfLine*SHARE_ICON_WIDTH)/(numOfLine+1);
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
    self.shareViews = shareViews;
    UIButton *cancelBtn = [Theme buttonForStyle:@"shareplatform-cancel"
                                      withTitle:NSLocalizedString(@"取 消", nil)
                                          frame:CGRectMake(10, rect.origin.y + rect.size.height + 10, contentViewFrame.size.width-20, 36)
                                         target:self
                                         action:@selector(cancel:)];
    [self.contentView addSubview:cancelBtn];
    contentViewFrame.size.height = cancelBtn.frame.origin.y + cancelBtn.frame.size.height + 10;
    contentViewFrame.origin.y = self.frame.size.height - contentViewFrame.size.height;
    self.contentView.frame = contentViewFrame;
    [self addSubview:self.contentView];
    [self setContentViewShadow];
}
+ (id)sharePlatformView{
    return /*AUTORELEASE*/([[SharePlatformView alloc] init]);
}
- (void)show{
    UIView *container = [self container];
    self.frame = container.bounds;
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y = self.bounds.size.height;
    self.contentView.frame = contentViewFrame;
    [container addSubview:self];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
                         CGRect frame = self.contentView.frame;
                         frame.origin.y = self.bounds.size.height - frame.size.height;
                         self.contentView.frame = frame;
                         
                         CGAffineTransform transform = CGAffineTransformMakeScale(  0.97,  0.97 );
                         [[APPRootController view] setTransform:transform];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (IBAction)shareWithPlatform:(id)sender{
    SharePlatform *platform = [sender object];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sharePlatformView:willSelectSharePlatform:)]) {
        [self.delegate sharePlatformView:self didSelectedSharePlatform:platform];
    }
    [self cancelWithBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(sharePlatformView:didSelectedSharePlatform:)]) {
            [self.delegate sharePlatformView:self didSelectedSharePlatform:platform];
        }
        if(self.autoShare){
            ShareView *shareView = [ShareView shareView];
            [shareView setTitle:platform.name];
            [shareView setContent:self.shareContent];
            [shareView setImagePath:self.shareImagePath];
            [shareView setShareTitle:self.shareTitle];
            [shareView setShareUrl:self.shareUrl];
            [shareView setShowCountLabel:YES];
            [shareView setAutoSend:YES];
            [shareView setSharePlatform:platform];
            [shareView show];
        }
    }];
}
- (void)cancelWithBlock:(void(^)())block{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         CGRect frame = self.contentView.frame;
                         frame.origin.y = self.bounds.size.height;
                         self.contentView.frame = frame;
                         
                         CGAffineTransform transform = CGAffineTransformMakeScale(  1.0,  1.0 );
                         [[APPRootController view] setTransform:transform];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (block) {
                             block();
                         }
                     }];
}
- (void)cancel:(id)sender{
    [self cancelWithBlock:nil];
}
@end
