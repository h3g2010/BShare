//
//  ShareViewController.h
//  iVideo
//
//  Created by baboy on 13-8-27.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "XUIViewController.h"
#import "ShareView.h"

@protocol ShareViewControllerDelegate;

@interface ShareViewController : XUIViewController
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


@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, assign) int maxTextLength;

- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;
@end


@protocol ShareViewControllerDelegate<NSObject>
- (void)shareControllerDidCancel:(id)controller;
- (void)shareControllerDidSend:(id)controller;
@end