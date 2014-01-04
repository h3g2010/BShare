//
//  ShareUtils.h
//  iShow
//
//  Created by baboy on 13-6-4.
//  Copyright (c) 2013年 baboy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
extern NSString *SharePlatformSinaWeibo;
extern NSString *SharePlatformSohuWeibo;
extern NSString *SharePlatformTencentWeibo;
extern NSString *SharePlatformQZone;
extern NSString *SharePlatformDouban;
extern NSString *SharePlatformRenRen;
extern NSString *SharePlatformWeChat;
extern NSString *SharePlatformQQ;

@interface SharePlatform : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *platform;
@property (nonatomic, retain) NSString *platformId;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *appId;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;
@property (nonatomic, retain) NSString *redirectUri;
@property (nonatomic, assign) BOOL login;
@property (nonatomic, assign) BOOL bind;
@property (nonatomic, assign) BOOL canBind;
@property (nonatomic, assign) int shareType;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL onekeyShare;
@property (nonatomic, strong) UIColor *backgroundColor;

- (id) initWithDictionary:(NSDictionary*)dict;
- (NSDictionary *) dict;
- (BOOL) hasAuthorized;
- (BOOL) cancelAuth;
@end



@interface ShareUtils : NSObject
+ (void)setupWithKey:(NSString *)key;
+ (NSArray *)platforms;
+ (NSArray *)bindPlatforms;
+ (NSArray *)loginPlatforms;
+ (SharePlatform *)platform:(NSString *)platformId;
+ (SharePlatform *)platformWithType:(int)shareType;
+ (void)loginWithPlatform:(SharePlatform *)platform callback:(void (^)(id user, NSError *error))callback;
+ (BOOL) hasAuthorizedWithPlatform:(SharePlatform *)platform;
+ (BOOL) cancelAuthWithPlatform:(SharePlatform *)platform;

+ (id)authOptions;
+ (void) shareOnPlatform:(NSArray *)platforms withTitle:(NSString *)title withUrl:(NSString *)url withContent:(NSString *)content withImagePath:(NSString *)imagePath callback:(void (^)(NSError *error))callback;
+ (void) shareOnPlatform:(NSArray *)platforms withContent:(NSString *)content withImagePath:(NSString *)imagePath callback:(void (^)(NSError *error))callback;
@end
