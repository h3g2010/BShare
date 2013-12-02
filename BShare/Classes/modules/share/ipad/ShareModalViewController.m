//
//  ShareModalViewController.m
//  iVideoForiPad
//
//  Created by baboy on 13-12-1.
//  Copyright (c) 2013年 tvie. All rights reserved.
//

#import "ShareModalViewController.h"

@interface ShareModalViewController ()
@property (nonatomic, strong) NSMutableArray *sharePlatforms;
@property (nonatomic, strong) NSArray *shareBtns;
@end

@implementation ShareModalViewController
- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
        self.autoSend = YES;
        self.showCountLabel = YES;
        self.sharePlatforms = [NSMutableArray array];
    }
    return self;
}
- (void)setContainerShadow{
    [self.container.layer setShadowColor:[UIColor colorWithWhite:0 alpha:0.1].CGColor];
    [self.container.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.container.layer setShadowRadius:1.0];
    [self.container.layer setShadowOpacity:1.0];
    //[self.container.layer setCornerRadius:5.0];
    [self.textView.superview.layer setBorderColor:[UIColor colorWithWhite:0.95 alpha:1.0].CGColor];
    [self.textView.superview.layer setBorderWidth:1.0];
    [self.imageView.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1.0].CGColor];
    [self.imageView.layer setBorderWidth:1.0];
}
- (BOOL)isAddSharePlatform:(SharePlatform *)platform{
    for (SharePlatform *p in self.sharePlatforms) {
        if (p.shareType == platform.shareType) {
            return YES;
        }
    }
    return NO;
}
- (void)addSharePlatform:(SharePlatform *)platform{
    for (SharePlatform *p in self.sharePlatforms) {
        if (p.shareType == platform.shareType) {
            return;
        }
    }
    [self.sharePlatforms addObject:platform];
    [self updateShareplatform];
}
- (void)removeSharePlatform:(SharePlatform *)platform{
    for (int i = self.sharePlatforms.count-1; i>=0;i--) {
        SharePlatform *p = [self.sharePlatforms objectAtIndex:i];
        if (p.shareType == platform.shareType) {
            [self.sharePlatforms removeObject:p];
            [self updateShareplatform];
            return;
        }
    }
}
- (void)setSharePlatform:(SharePlatform *)sharePlatform{
    _sharePlatform = sharePlatform;
    [self addSharePlatform:sharePlatform];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *titleLabel = [Theme labelForStyle:@"modal-navigationbar"];
    titleLabel.frame = self.navigationController.navigationBar.bounds;
    self.titleLabel = titleLabel;
    [self performSelector:@selector(setContainerShadow) withObject:nil afterDelay:0.1];
    [self.textView becomeFirstResponder];
    self.navigationItem.leftBarButtonItem = [Theme navBarButtonForKey:@"navigationbar-back-button" withTarget:self action:@selector(cancel:)];
    
    self.navigationItem.rightBarButtonItem = [Theme navButtonForStyle:@"submit"
                                                            withTitle:NSLocalizedString(@"发送", nil)
                                                                frame:CGRectZero
                                                               target:self
                                                               action:@selector(send:)];
    self.navigationItem.leftBarButtonItem = [Theme navButtonForStyle:@"submit"
                                                            withTitle:NSLocalizedString(@"取消", nil)
                                                                frame:CGRectZero
                                                               target:self
                                                               action:@selector(cancel:)];
    [self setContent:self.content];
    [self setImagePath:self.imagePath];
    [self updateCountLabel];
    [self layout];
    [self updateShareplatform];
}
- (void)updateShareplatform{
    if (!_shareBtns && self.platformContainer) {
        NSMutableArray *btns = [NSMutableArray array];
        NSArray *platforms = [ShareUtils bindPlatforms];
        CGRect itemFrame = self.platformContainer.bounds;
        itemFrame.size.width = itemFrame.size.height;
        float padding = 10;
        for (int i = 0, n = platforms.count; i < n; i++) {
            SharePlatform *p = [platforms objectAtIndex:i];
            if (!p.onekeyShare) {
                continue;
            }
            itemFrame.origin.x = btns.count *(itemFrame.size.width+padding);
            UIImage *icon = [UIImage imageWithContentsOfFile:p.icon];
            UIImage *grayIcon = [icon imageWithColor:[UIColor grayColor]];
            UIButton *btn = createImageButton(itemFrame, nil, self, @selector(tapSharePlatform:));
            [btn setImage:icon forState:UIControlStateNormal];
            [btn setImage:grayIcon forState:UIControlStateSelected];
            btn.tag = p.shareType;
            [self.platformContainer addSubview:btn];
            [btns addObject:btn];
        }
        self.shareBtns = btns;
    }
    for (UIButton *btn in self.shareBtns) {
        BOOL flag = NO;
        for (SharePlatform *p in self.sharePlatforms) {
            if (p.shareType == btn.tag) {
                flag = YES;
                break;
            }
        }
        btn.selected = !flag;
    }
}
- (void)tapSharePlatform:(id)sender{
    SharePlatform *platform = [ShareUtils platformWithType:[sender tag]];
    if (platform) {
        if ([self isAddSharePlatform:platform]) {
            [self removeSharePlatform:platform];
        }else{
            [ShareUtils loginWithPlatform:platform
                                 callback:^(id user, NSError *error) {
                                     if (error) {
                                         [self showMessageAndFadeOut:error.localizedDescription];
                                     }else{
                                         [self addSharePlatform:platform];
                                     }
                                 }];
        }
        
    }
    DLOG(@"%@",self.sharePlatforms);
}
- (void)layout{
    self.platformContainer.superview.hidden = self.shareViewType == ShareViewTypeComment;
    CGRect textViewWrapperFrame = CGRectInset(self.container.bounds, 5, 5);
    self.countLabel.hidden = !self.showCountLabel;
    self.imageView.hidden = !(self.imagePath ? YES : NO);
    
    if (self.showCountLabel) {
        textViewWrapperFrame.size.height -= 30;
    }
    self.textView.superview.frame = textViewWrapperFrame;
    CGRect textViewFrame = self.textView.superview.bounds;
    if (self.imagePath) {
        textViewFrame.size.width -= self.imageView.bounds.size.width + 10;
    }
    self.textView.frame = textViewFrame;
}

- (void) setContent:(NSString *)content{
    _content = content;
    self.textView.text = content;
}
- (void)setImagePath:(NSString *)imagePath{
    _imagePath = [imagePath length]>0 ? imagePath : nil;
    
    if ( !imagePath || ( !isURL(imagePath) && ![imagePath fileExists]) ) {
        return;
    }
    NSURL *imageURL = isURL(imagePath) ? [NSURL URLWithString:imagePath] : [NSURL fileURLWithPath:imagePath];
    [self.imageView setImageURL:imageURL];
}
- (IBAction)send:(id)sender{
    if (self.shareViewType == ShareViewTypeShare && self.sharePlatforms.count==0) {
        [self showMessageAndFadeOut:NSLocalizedString(@"至少选择一个分享平台!", nil)];
        return;
    }
    
    BOOL shouldCancel = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareModalViewController:shouldSendContent:withImagePath:)]) {
        shouldCancel = [self.delegate shareModalViewController:self shouldSendContent:self.textView.text withImagePath:self.imagePath];
    }
    if (self.autoSend && self.sharePlatform) {
        //分享
        __block BOOL isSend = NO;
        [ShareUtils shareOnPlatform:[NSArray arrayWithObject:self.sharePlatform]
                        withContent:self.textView.text
                      withImagePath:self.imagePath
                           callback:^(NSError *error) {
                               DLOG(@"Share error:%@", error);
                               NSString *msg = error ? [error localizedDescription] : NSLocalizedString(@"分享成功", nil) ;
                               [self showMessageAndFadeOut:msg];
                               @synchronized(self){
                                   if (!error && !isSend) {
                                       isSend = YES;
                                       [self performSelector:@selector(didSend) withObject:nil afterDelay:1.0];
                                   }
                               }
                           }];
    }else{
        if (shouldCancel) {
            [self didCancel];
        }
    }
}
- (IBAction)cancel:(id)sender{
    [self didCancel];
}

- (void)updateCountLabel{
    int textCount = 140 - [self.textView.text length];
    self.countLabel.text = [NSString stringWithFormat:@"%d", textCount];
    self.countLabel.textColor = textCount>=0 ? [UIColor blackColor] : [UIColor redColor];
}
#pragma UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    [self updateCountLabel];
}
#pragma delegate
- (void)didCancel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareControllerDidCancel:)]) {
        [self.delegate shareControllerDidCancel:self];
    }
    id vc = self.navigationController ?: self;
    [vc dismissModalViewControllerAnimated:NO];
}
- (void)didSend{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareControllerDidSend:)]) {
        [self.delegate shareControllerDidSend:self];
    }
    id vc = self.navigationController ?: self;
    [vc dismissModalViewControllerAnimated:NO];
}
@end
