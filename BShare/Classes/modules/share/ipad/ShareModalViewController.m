//
//  ShareModalViewController.m
//  iVideoForiPad
//
//  Created by baboy on 13-12-1.
//  Copyright (c) 2013年 tvie. All rights reserved.
//

#import "ShareModalViewController.h"

@interface ShareModalViewController ()

@end

@implementation ShareModalViewController
- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
        self.autoSend = YES;
        self.showCountLabel = YES;
    }
    return self;
}
- (void)setContainerShadow{
    [self.container.layer setShadowColor:[UIColor colorWithWhite:0 alpha:0.6].CGColor];
    [self.container.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.container.layer setShadowRadius:1.0];
    [self.container.layer setShadowOpacity:1.0];
    [self.container.layer setCornerRadius:5.0];
    [self.textView.superview.layer setBorderColor:[UIColor colorWithWhite:0.95 alpha:1.0].CGColor];
    [self.textView.superview.layer setBorderWidth:1.0];
    [self.imageView.layer setBorderColor:[UIColor colorWithWhite:0.9 alpha:1.0].CGColor];
    [self.imageView.layer setBorderWidth:1.0];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
}
- (void) setContent:(NSString *)content{
    //RELEASE(_content);
    _content = /*RETAIN*/(content);
    self.textView.text = content;
}
- (void)setImagePath:(NSString *)imagePath{
    //RELEASE(_imagePath);
    _imagePath = /*RETAIN*/(imagePath);
    
    if ( !imagePath || ( !isURL(imagePath) && ![imagePath fileExists]) ) {
        return;
    }
    NSURL *imageURL = isURL(imagePath) ? [NSURL URLWithString:imagePath] : [NSURL fileURLWithPath:imagePath];
    [self.imageView setImageURL:imageURL];
}
- (IBAction)send:(id)sender{
    BOOL shouldCancel = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:shouldSendContent:withImagePath:)]) {
        shouldCancel = [self.delegate shareView:(id)self shouldSendContent:self.textView.text withImagePath:self.imagePath];
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
