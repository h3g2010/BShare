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
@property (nonatomic, retain) IBOutlet UIView *container;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, assign) BOOL showCountLabel;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL autoSend;
@property (nonatomic, assign) ShareViewType shareViewType;
@property (nonatomic, retain) SharePlatform *sharePlatform;
@property (nonatomic, retain) UIView *backgroundView;

- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;
@end


@protocol ShareViewControllerDelegate<NSObject>
- (void)shareControllerDidCancel:(id)controller;
- (void)shareControllerDidSend:(id)controller;
@end