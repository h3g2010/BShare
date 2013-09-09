//
//  ShareView.m
//  iShow
//
//  Created by baboy on 13-7-2.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "ShareView.h"
#define CountLabelTextColor [UIColor blackColor]
#define CountLabelTextHighLightColor [UIColor redColor]

@interface ShareView()<UITextViewDelegate>
@property (nonatomic, strong) UIView *backgroundView;
@end
@implementation ShareView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
    
    self.backgroundView = /*AUTORELEASE*/([[UIView alloc] initWithFrame:self.bounds]);
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self insertSubview:self.backgroundView belowSubview:self.container];
    
    
    UITapGestureRecognizer *tap = /*AUTORELEASE*/([[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)]);
    [self.backgroundView addGestureRecognizer:tap];
    [self setContainerShadow];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
- (id)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (void)awakeFromNib{
    [self setup];
    self.container.backgroundColor = [Theme colorForKey:@"share-view-background"];
    self.cancelBtn.backgroundColor = [Theme colorForKey:@"button-cancel-background"];
    self.cancelBtn.titleLabel.font = [Theme fontForKey:@"button-cancel-title"];
    self.cancelBtn.titleLabel.textColor = [Theme colorForKey:@"button-cancel-title"];
    
    self.sendBtn.backgroundColor = [Theme colorForKey:@"button-submit-background"];
    self.sendBtn.titleLabel.font = [Theme fontForKey:@"button-submit-title"];
    self.sendBtn.titleLabel.textColor = [Theme colorForKey:@"button-submit-title"];
    [self.textView.superview.layer setBorderColor:[UIColor colorWithWhite:0.85 alpha:1.0].CGColor];
    
    [self.textView.superview.layer setBorderWidth:1.0];
}
- (void)setContainerShadow{
    [self.container.layer setShadowColor:[UIColor colorWithWhite:0 alpha:0.6].CGColor];
    [self.container.layer setShadowOffset:CGSizeMake(0, -2)];
    [self.container.layer setShadowRadius:3.0];
    [self.container.layer setShadowOpacity:1.0];
    
}
- (void) setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
- (void) setContent:(NSString *)content{
    //RELEASE(_content);
    _content = /*RETAIN*/(content);
    self.textView.text = content;
}
- (void)setPlaceholders:(NSString *)placeholders{
    //RELEASE(_placeholders);
    _placeholders = placeholders;
    self.placeholderTextView.text = placeholders;
}
- (void)setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    if ( !imagePath || ( !isURL(imagePath) && ![imagePath fileExists]) ) {
        return;
    }
    NSURL *imageURL = isURL(imagePath) ? [NSURL URLWithString:imagePath] : [NSURL fileURLWithPath:imagePath];
    [self.imageView setImageURL:imageURL];
}
- (void)layout{
    CGRect containerFrame = self.container.frame;
    containerFrame.size.height = self.countLabel.frame.origin.y+5;
    CGRect textFrame = self.textView.superview.bounds;
    
    self.countLabel.hidden = !self.showCountLabel;
    self.imageView.hidden = !(self.imagePath ? YES : NO);
    
    if (self.showCountLabel) {
        containerFrame.size.height += 25;
    }
    if (self.imagePath) {
        textFrame.size.width -= self.imageView.frame.size.width + 10;
    }
    containerFrame.origin.y = self.bounds.size.height - containerFrame.size.height;
    self.textView.frame = textFrame;
    self.placeholderTextView.frame = textFrame;
    self.container.frame = containerFrame;
}
+ (id)shareView{
    return (ShareView*)loadViewFromNib([self class], nil);
}
- (void)show{
    [self showInView:[APP keyWindow]];
}
- (void)showInView:(UIView *)container{
    self.frame = container.bounds;
    [self layout];
    [self updateCountLabel];
    DLOG(@"show");
    CGRect containerFrame = self.container.frame;
    containerFrame.origin.y = self.bounds.size.height;
    self.container.frame = containerFrame;
    [container addSubview:self];
    
    [self.textView becomeFirstResponder];
    return;
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
                         CGRect frame = self.container.frame;
                         frame.origin.y = self.bounds.size.height - frame.size.height;
                         self.container.frame = frame;
                         
                         CGAffineTransform transform = CGAffineTransformMakeScale(  0.97,  0.97 );
                         [[APPRootController view] setTransform:transform];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (IBAction)send:(id)sender{
    BOOL shouldCancel = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareView:shouldSendContent:withImagePath:)]) {
        shouldCancel = [self.delegate shareView:self shouldSendContent:self.textView.text withImagePath:self.imagePath];
    }
    if (self.autoSend && self.sharePlatform) {
        //分享
        NSString *imagePath = isURL(self.imagePath) ? [UIImageView cachePathForURL:[NSURL URLWithString:self.imagePath]] : self.imagePath;
        [ShareUtils shareOnPlatform:[NSArray arrayWithObject:self.sharePlatform]
                        withContent:self.textView.text
                      withImagePath:imagePath
                           callback:^(NSError *error) {
                               DLOG(@"Share error:%@", error);
                           }];
    }
    if (shouldCancel) {
        [self cancel:nil];
    }
}
- (IBAction)cancel:(id)sender{
    self.textView.text = nil;
    self.imagePath = nil;
    [self.textView resignFirstResponder];
}

#pragma keyboard listener
- (void)keyboardWillShow:(NSNotification *)noti{
    CGRect keyboardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = self.container.frame;
    containerFrame.origin.y = self.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	// set views with new info
	self.container.frame = containerFrame;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    CGAffineTransform transform = CGAffineTransformMakeScale(  0.97,  0.97 );
    [[APPRootController view] setTransform:transform];
	
	// commit animations
	[UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notif{
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.backgroundColor = [UIColor clearColor];
                         CGRect frame = self.container.frame;
                         frame.origin.y = self.bounds.size.height;
                         self.container.frame = frame;
                         
                         CGAffineTransform transform = CGAffineTransformMakeScale(  1.0,  1.0 );
                         [[APPRootController view] setTransform:transform];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
- (void)updateCountLabel{
    int textCount = 140 - [self.textView.text textCount];
    self.textView.textColor = textCount >= 0 ? CountLabelTextColor : CountLabelTextHighLightColor;
    self.countLabel.text = [NSString stringWithFormat:@"%d", textCount];
}
#pragma UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    [self updateCountLabel];
    self.placeholderTextView.text = [textView.text length] > 0 ? nil : self.placeholders;
}
@end
