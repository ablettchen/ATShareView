//
//  ATShareView.h
//  ATShareView
//  https://github.com/ablettchen/ATShareView
//
//  Created by ablett on 05/10/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ATShare.h>

NS_ASSUME_NONNULL_BEGIN

@class ATShareConf;
@interface ATShareView : UIView

@property (nullable, nonatomic, copy) NSString *title;
@property (nonnull, nonatomic, strong, readonly) ATShare *share;

@property (nonatomic, copy, readonly) void(^update)(void(^block)(ATShareConf *conf));

@property (nullable, nonatomic, copy) void(^didShow)(BOOL finished);
@property (nullable, nonatomic, copy) void(^didHide)(BOOL finished);

+ (instancetype)viewWithTitle:(nullable NSString *)title
                        share:(nonnull ATShare *)share
                 customSocial:(void(^__nullable)(id<ATSocialProtocol>socail))customSocial
                    urlAction:(void(^__nullable)(id<ATWebURLActionProtocol>action))urlAction
                     finished:(nullable ATShareFinishedBlock)finished;

- (void)show;

@end

@interface ATShareConf : NSObject

@property (nonatomic, strong) UIColor *dimBackgroundColor;      ///< default is 0x0000007F
@property (nonatomic, strong) UIColor *backgroundColor;         ///< default is 0xFFFFFFFF

@property (nonatomic, assign) CGFloat width;                    ///< Default is screen width.

@property (nonatomic, assign) UIEdgeInsets insets;              ///< default is UIEdgeInsetsMake(15, 15, 15, 15).

@property (nonatomic, strong) UIFont *titleFont;                ///< default is systemFont(14).
@property (nonatomic, strong) UIColor *titleColor;              ///< default is 0x666666FF;

@property (nonatomic, assign) CGSize itemSize;                  /// default is (80, 80)
@property (nonatomic, strong) UIFont *itemFont;                 ///< default is systemFont(11).
@property (nonatomic, strong) UIColor *itemColor;               ///< Default is #666666.

@property (nonatomic, strong) UIColor *splitColor;              ///< default is 0xE7E7E7FF.
@property (nonatomic, assign) CGFloat splitWidth;               ///< default is 1/[UIScreen mainScreen].scale

@property (nonatomic, assign) CGFloat cancelHeight;             ///< Default is 50.
@property (nonatomic, strong) UIFont *cancelFont;               ///< default is systemFont(17).
@property (nonatomic, strong) UIColor *cancelColor;             ///< Default is 0x333333FF
@property (nonatomic, strong) UIColor *cancelHighlightColor;    ///< Default is 0x666666FF.
@property (nonatomic, strong) UIColor *cancelPressedColor;      ///< Default is 0xF5F5F5FF.
@property (nonatomic, strong) NSString *defaultCancelText;      ///< Default is "取消".

@end

NS_ASSUME_NONNULL_END
