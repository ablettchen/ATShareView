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

- (instancetype)initWithRes:(id<ATShareResProtocol>)res
                    socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials;

- (instancetype)initWithRes:(id<ATShareResProtocol>)res
                    socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                   selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected;

- (instancetype)initWithTitle:(nullable NSString *)title
                          res:(id<ATShareResProtocol>)res
                      socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                     selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected;

///////////////////////////////////////////////////////////////////////////

- (__kindof ATShareView *(^)(NSString * _Nullable title))withTitle;
- (__kindof ATShareView *(^)(id<ATShareResProtocol> res))withRes;
- (__kindof ATShareView *(^)(NSArray <id<ATSocialProtocol>> * _Nonnull socials))withSocials;
- (__kindof ATShareView *(^)(void(^ _Nullable selected)(id<ATSocialProtocol> _Nonnull social)))withSelected;

@end

@interface ATShareViewConfig : NSObject

+ (ATShareViewConfig*)globalConfig;

@property (nonatomic, assign) CGFloat width;                ///< Default is screen width.
@property (nonatomic, assign) CGFloat shareHeight;          ///< default 80
@property (nonatomic, assign) CGFloat extendHeight;         ///< default 80
@property (nonatomic, assign) CGFloat buttonHeight;         ///< Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          ///< Default is 25.
@property (nonatomic, assign) CGFloat cornerRadius;         ///< Default is 0.

@property (nonatomic, assign) CGFloat titlePadding;         ///< Default is 5.

@property (nonatomic, assign) CGFloat titleFontSize;        ///< Default is 18.
@property (nonatomic, assign) CGFloat socialFontSize;       ///< Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       ///< Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     ///< Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          ///< Default is #666666.
@property (nonatomic, strong) UIColor *socialColor;         ///< Default is #333333.
@property (nonatomic, strong) UIColor *splitColor;          ///< Default is #CCCCCC.

@property (nonatomic, strong) UIColor *actionNormalColor;       ///< Default is #333333. effect with ATPopupActionStyleNormal
@property (nonatomic, strong) UIColor *actionHighlightColor;    ///< Default is #E76153. effect with ATPopupActionStyleHighlighted
@property (nonatomic, strong) UIColor *actionPressedColor;      ///< Default is #F5F5F5.

@property (nonatomic, strong) NSString *defaultActionCancel;    ///< Default is "取消".

@property (nonatomic, strong) UIColor *dimBackgroundColor;                       ///< Default is 0x0000007F
@property (nonatomic, assign) BOOL dimBackgroundBlurEnabled;                     ///< Default is NO
@property (nonatomic, assign) UIBlurEffectStyle dimBackgroundBlurEffectStyle;    ///< Default is UIBlurEffectStyleExtraLight

@end

NS_ASSUME_NONNULL_END
