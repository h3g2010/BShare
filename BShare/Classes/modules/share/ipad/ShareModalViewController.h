//
//  ShareModalViewController.h
//  iVideoForiPad
//
//  Created by baboy on 13-12-1.
//  Copyright (c) 2013年 tvie. All rights reserved.
//

#import "XUIViewController.h"
#import "ShareViewController.h"
@interface ShareModalViewController : XUIViewController

@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL showCountLabel;
@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BOOL autoSend;
@property (nonatomic, assign) ShareViewType shareViewType;
@property (nonatomic, strong) SharePlatform *sharePlatform;
@property (nonatomic, strong) UIView *backgroundView;

- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;
@end

