//
//  ShareViewController.m
//  iVideo
//
//  Created by baboy on 13-8-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    /*
    RELEASE(_sharePlatform);
    RELEASE(_backgroundView);
    RELEASE(_container);
    RELEASE(_imageView);
    RELEASE(_imagePath);
    RELEASE(_textView);
    RELEASE(_countLabel);
    [super dealloc];
     */
}

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
        [self setup];
        self.autoSend = YES;
        self.showCountLabel = YES;
    }
    return self;
}
- (void)setup{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
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
    [self layout];
    [self updateCountLabel];
    self.textView.text = self.content;
    self.imagePath = self.imagePath;
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
- (void)layout{
    CGRect textViewWrapperFrame = CGRectInset(self.container.bounds, 10, 10);
    self.countLabel.hidden = !self.showCountLabel;
    self.imageView.hidden = !(self.imagePath ? YES : NO);
    
    if (self.showCountLabel) {
        textViewWrapperFrame.size.height -= 20;
    }
    self.textView.superview.frame = textViewWrapperFrame;
    
    CGRect textViewFrame = self.textView.superview.bounds;
    if (self.imagePath) {
        textViewFrame.size.width -= self.imageView.bounds.size.width + 10;
    }
    self.textView.frame = textViewFrame;
}

- (IBAction)send:(id)sender{
    NSString *content = self.textView.text;
    if ([content length]>self.maxTextLength) {
        NSString *msg = [NSString stringWithFormat:@"不能超过%d个字符",self.maxTextLength];
        [BIndicator showMessageAndFadeOut:NSLocalizedString(msg, nil)];
        return;
    }
    BOOL shouldCancel = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:shouldSendContent:withImagePath:)]) {
        shouldCancel = [self.delegate shareView:(id)self shouldSendContent:self.textView.text withImagePath:self.imagePath];
    }
    if (self.autoSend && self.sharePlatform) {
        //分享
        __block BOOL isSend = NO;
        [ShareUtils shareOnPlatform:[NSArray arrayWithObject:self.sharePlatform]
                          withTitle:self.shareTitle
                            withUrl:self.shareUrl
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

#pragma keyboard listener
- (void)keyboardWillShow:(NSNotification *)noti{
    CGRect keyboardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = self.container.frame;
    containerFrame.size.height = self.view.bounds.size.height - (keyboardBounds.size.height + 20);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	// set views with new info
	self.container.frame = containerFrame;
    //CGAffineTransform transform = CGAffineTransformMakeScale(  0.97,  0.97 );
    //[[APPRootController view] setTransform:transform];
	
	// commit animations
	[UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notif{
}
- (int)maxTextLength{
    return _maxTextLength>0?_maxTextLength:140;
}
- (void)updateCountLabel{
    int textCount = self.maxTextLength - [self.textView.text length];
    self.countLabel.text = [NSString stringWithFormat:@"%d", textCount];
    self.countLabel.textColor = textCount>=0 ? [UIColor blackColor] : [UIColor redColor];
}
#pragma UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    [self updateCountLabel];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [APP setStatusBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [APP setStatusBarHidden:NO];
}

#pragma delegate
- (void)didCancel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareControllerDidCancel:)]) {
        [self.delegate shareControllerDidCancel:self];
    }
    [self dismissModalViewControllerAnimated:NO];
}
- (void)didSend{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareControllerDidSend:)]) {
        [self.delegate shareControllerDidSend:self];
    }
    [self dismissModalViewControllerAnimated:NO];
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate{
    return NO;
}
@end
