//
//  ShareModalViewController.h
//  iVideoForiPad
//
//  Created by baboy on 13-12-1.
//  Copyright (c) 2013年 tvie. All rights reserved.
//

#import "XUIViewController.h"
#import "ShareViewController.h"
@protocol ShareModalViewControllerDelegate;
@interface ShareModalViewController : XUIViewController

@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) BOOL showCountLabel;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BOOL autoSend;
@property (nonatomic, assign) ShareViewType shareViewType;
@property (nonatomic, strong) SharePlatform *sharePlatform;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) id params;
@property (nonatomic, strong) IBOutlet UIView *platformContainer;
@property (nonatomic, assign) int maxTextLength;


@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareUrl;

- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;
@end

@protocol ShareModalViewControllerDelegate <NSObject>
@optional
- (BOOL)shareModalViewController:(ShareModalViewController *)modalController shouldSendContent:(NSString *)content withImagePath:(NSString *)imagePath;

@end