//
//  ShareView.h
//  iShow
//
//  Created by baboy on 13-7-2.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import "ShareUtils.h"
@class ShareView;

enum  {
    ShareViewTypeShare,
    ShareViewTypeComment
};
typedef int ShareViewType;

@protocol ShareViewDelegate <NSObject>
@optional
- (BOOL)shareView:(ShareView *)shareView shouldSendContent:(NSString *)content withImagePath:(NSString *)imagePath;

@end

@interface ShareView : XUIView
@property (nonatomic, strong) IBOutlet UIView *container;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UITextView *placeholderTextView;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UIButton *cancelBtn;
@property (nonatomic, strong) IBOutlet UIButton *sendBtn;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *placeholders;
@property (nonatomic, assign) BOOL showCountLabel;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL autoSend;
@property (nonatomic, assign) ShareViewType shareViewType;
@property (nonatomic, strong) SharePlatform *sharePlatform;

+ (id)shareView;
- (void)show;
- (void)showInView:(UIView *)container;
- (void) setTitle:(NSString *)title;
- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;

@end
