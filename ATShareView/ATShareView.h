//
//  ATShareView.h
//  ATShareView
//  https://github.com/ablettchen/ATShareView
//
//  Created by ablett on 05/10/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPopupView.h"
#import <ATShare.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATShareView : ATPopupView

@property (copy, nonatomic, nullable) NSString *title;
@property (strong, nonatomic, nonnull) id<ATShareResProtocol> res;
@property (strong, nonatomic, nonnull) NSArray <id<ATSocialProtocol>> *socials;
@property (copy, nonatomic, nullable) void(^selected)(id<ATSocialProtocol> _Nonnull social);
@property (copy, nonatomic, nullable) void(^finished)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social);

- (instancetype)initWithRes:(id<ATShareResProtocol>)res
                    socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                   finished:(void(^_Nullable)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social))finished;;

- (instancetype)initWithRes:(id<ATShareResProtocol>)res
                    socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                   selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected
                   finished:(void(^_Nullable)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social))finished;

- (instancetype)initWithTitle:(nullable NSString *)title
                          res:(id<ATShareResProtocol>)res
                      socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                     selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected
                     finished:(void(^_Nullable)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social))finished;

///////////////////////////////////////////////////////////////////////////

- (__kindof ATShareView *(^)(NSString * _Nullable title))withTitle;
- (__kindof ATShareView *(^)(id<ATShareResProtocol> res))withRes;
- (__kindof ATShareView *(^)(NSArray <id<ATSocialProtocol>> * _Nonnull socials))withSocials;
- (__kindof ATShareView *(^)(void(^ _Nullable selected)(id<ATSocialProtocol> _Nonnull social)))withSelected;
- (__kindof ATShareView *(^)(void(^ _Nullable finished)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social)))withFinished;

@end

@interface ATShareViewConfig : NSObject

+ (ATShareViewConfig*)globalConfig;

@property (nonatomic, assign) CGFloat width;                ///< Default is screen width.
@property (nonatomic, assign) CGFloat socailWidth;
@property (nonatomic, assign) CGFloat socailHeight;          ///< default 80
@property (nonatomic, assign) CGFloat actionHeight;         ///< default 80
@property (nonatomic, assign) CGFloat actionWidth;

@property (nonatomic, assign) CGFloat cancelHeight;         ///< Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          ///< Default is 25.
@property (nonatomic, assign) CGFloat cornerRadius;         ///< Default is 0.

@property (nonatomic, assign) CGFloat titlePadding;         ///< Default is 5.

@property (nonatomic, assign) CGFloat titleFontSize;        ///< Default is 18.
@property (nonatomic, assign) CGFloat socialFontSize;       ///< Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       ///< Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     ///< Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          ///< Default is #666666.
@property (nonatomic, strong) UIColor *socialColor;         ///< Default is #666666.
@property (nonatomic, strong) UIColor *splitColor;          ///< Default is #CCCCCC.

@property (nonatomic, strong) UIColor *cancelNormalColor;       ///< Default is #333333. effect with ATPopupActionStyleNormal
@property (nonatomic, strong) UIColor *cancelHighlightColor;    ///< Default is #666666. effect with ATPopupActionStyleHighlighted
@property (nonatomic, strong) UIColor *cancelPressedColor;      ///< Default is #F5F5F5.

@property (nonatomic, strong) NSString *defaultCancelText;    ///< Default is "取消".

@property (nonatomic, strong) UIColor *dimBackgroundColor;                       ///< Default is 0x0000007F
@property (nonatomic, assign) BOOL dimBackgroundBlurEnabled;                     ///< Default is NO
@property (nonatomic, assign) UIBlurEffectStyle dimBackgroundBlurEffectStyle;    ///< Default is UIBlurEffectStyleExtraLight

@end

NS_ASSUME_NONNULL_END
