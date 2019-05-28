//
//  ATShareView.m
//  ATShareView
//  https://github.com/ablettchen/ATShareView
//
//  Created by ablett on 05/10/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATShareView.h"
#import <ATCategories.h>
#import <Masonry.h>
#import <ATPopupView/UIView+ATPopup.h>

NS_INLINE NSBundle *at_share_bundle(void) {
    return [NSBundle at_bundleForClass:[ATShareView class] resource:@"ATShareView" ofType:@"bundle"];
}

NS_INLINE UIImage *at_imageNamed(NSString *name) {
    return [at_share_bundle() at_imageNamed:name];
}

@interface ATShareView ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) UIView *extendView;
@property (strong, nonatomic) UIButton *cancelBtn;
@end
@implementation ATShareView

#pragma mark - lifecycle

#pragma mark - privite

- (void)setupWithTitle:(nullable NSString *)title
                   res:(id<ATShareResProtocol>)res
               socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
              selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected {
    
    NSAssert(res != nil, @"Could not find res.");
    NSAssert(socials.count > 0, @"Could not find any socials.");
    
    self.title = title;
    self.res = res;
    self.socials = socials;
    self.selected = selected;
    
    self.type = ATPopupTypeSheet;
    
    ATShareViewConfig *config = [ATShareViewConfig globalConfig];
    self.layer.cornerRadius = config.cornerRadius;
    self.clipsToBounds = YES;
    //self.backgroundColor = config.backgroundColor;
    self.layer.borderWidth = AT_SPLIT_WIDTH;
    self.layer.borderColor = config.splitColor.CGColor;
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(config.width);
    }];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    
    if (self.title.length > 0) {
        
        self.titleLabel = [UILabel new];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(config.innerMargin);
            make.left.equalTo(self).offset(config.innerMargin);
            make.right.equalTo(self).inset(config.innerMargin);
        }];
        self.titleLabel.font = [UIFont systemFontOfSize:config.titleFontSize];
        self.titleLabel.textColor = config.titleColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //self.titleLabel.backgroundColor = config.backgroundColor;
        
        self.titleLabel.text = self.title;
        lastAttribute = self.titleLabel.mas_bottom;
    }
    
    BOOL titleIsNil = (self.title.length == 0) ? YES : NO;
    
    self.shareView = [UIView new];
    [self addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(titleIsNil?config.innerMargin:config.titlePadding);
        make.left.right.equalTo(self);
        make.height.equalTo(@(config.shareHeight));
    }];
    //self.shareView.backgroundColor = config.backgroundColor;
    
    
    lastAttribute = self.shareView.mas_bottom;
    
    if (self.res.type == ATShareResTypeImage && [self.res.thumb isKindOfClass:[UIImage class]]) {
        
    }else {
        
        UIView *line = [UIView new];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.left.right.equalTo(self);
            make.height.equalTo(@(AT_SPLIT_WIDTH));
        }];
        line.backgroundColor = config.splitColor;
        lastAttribute = line.mas_bottom;
        
        self.extendView = [UIView new];
        [self addSubview:self.extendView];
        [self.extendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute); //.offset(AT_SPLIT_WIDTH);
            make.left.right.equalTo(self);
            make.height.equalTo(@(config.extendHeight));
        }];
        //self.extendView.backgroundColor = config.backgroundColor;
        lastAttribute = self.extendView.mas_bottom;
    }
    
    self.cancelBtn = [UIButton buttonWithTarget:self action:@selector(cancenAction:)];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(AT_SPLIT_WIDTH);
        make.left.right.equalTo(self);
        make.height.equalTo(@(config.buttonHeight));
    }];
    [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:config.actionPressedColor] forState:UIControlStateHighlighted];
    [self.cancelBtn setTitle:config.defaultActionCancel forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:config.actionNormalColor forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:config.actionHighlightColor forState:UIControlStateHighlighted];
    [self.cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:config.buttonFontSize]];
    
    lastAttribute = self.cancelBtn.mas_bottom;
    
    if (IS_IPHONE_X) {
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(AT_SPLIT_WIDTH);
            make.left.right.equalTo(self);
            make.height.equalTo(@(35));
        }];
        view.backgroundColor = config.backgroundColor;
        lastAttribute = view.mas_bottom;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
    
    [[ATPopupWindow sharedWindow] setTouchWildToHide:NO];
    self.attachedView.at_dimBackgroundColor = config.dimBackgroundColor;
    self.attachedView.at_dimBackgroundBlurEnabled = config.dimBackgroundBlurEnabled;
    self.attachedView.at_dimBackgroundBlurEffectStyle = config.dimBackgroundBlurEffectStyle;

}

- (void)cancenAction:(UIButton *)sender {
    [super hide:self.didHideBlock];
}

#pragma mark - overwrite

- (void)show:(ATPopupCompletionBlock)block {
    [self setupWithTitle:self.title res:self.res socials:self.socials selected:self.selected];
    [super show:block];
}

#pragma mark - public

- (instancetype)initWithRes:(id<ATShareResProtocol>)res
                    socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials {
    return [self initWithRes:res socials:socials selected:nil];
}

- (instancetype)initWithRes:(id<ATShareResProtocol>)res
                    socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                   selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected {
    return [self initWithTitle:nil res:res socials:socials selected:selected];
}

- (instancetype)initWithTitle:(nullable NSString *)title
                          res:(id<ATShareResProtocol>)res
                      socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                     selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected {
    
    self = [super init];
    if (!self) return nil;
    self.title = title;
    self.res = res;
    self.socials = socials;
    self.selected = selected;
    return self;
}

///////////////////////////////////////////////////////////////////////////

- (__kindof ATShareView *(^)(NSString * _Nullable title))withTitle {
    return ^ __kindof ATShareView *(NSString * _Nullable title) {
        self.title = title;
        return self;
    };
}

- (__kindof ATShareView *(^)(id<ATShareResProtocol> res))withRes {
    return ^ __kindof ATShareView *(id<ATShareResProtocol> res) {
        self.res = res;
        return self;
    };
}

- (__kindof ATShareView *(^)(NSArray <id<ATSocialProtocol>> * _Nonnull socials))withSocials {
    return ^ __kindof ATShareView *(NSArray <id<ATSocialProtocol>> * _Nonnull socials) {
        self.socials = socials;
        return self;
    };
}

- (__kindof ATShareView *(^)(void(^ _Nullable selected)(id<ATSocialProtocol> _Nonnull social)))withSelected {
    return ^ __kindof ATShareView *(void(^selected)(id<ATSocialProtocol> _Nonnull social)) {
        self.selected = selected;
        return self;
    };
}

@end


@implementation ATShareViewConfig

+ (ATShareViewConfig *)globalConfig {
    static ATShareViewConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [ATShareViewConfig new];
    });
    return config;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.width          = SCREEN_WIDTH;
    self.shareHeight    = 80.0f;
    self.extendHeight   = 80.0f;
    self.buttonHeight   = 50.0f;
    self.innerMargin    = 15.0f;
    self.cornerRadius   = 0.0f;
    self.titlePadding   = 10.0f;
    
    self.titleFontSize  = 14.0f;
    self.socialFontSize = 14.0f;
    self.buttonFontSize = 17.0f;
    
    self.backgroundColor    = UIColorHex(0xFFFFFFFF);
    self.titleColor         = UIColorHex(0x666666FF);
    self.socialColor        = UIColorHex(0x333333FF);
    self.splitColor         = UIColorHex(0xCCCCCCFF);
    
    self.actionNormalColor    = UIColorHex(0x333333FF);
    self.actionHighlightColor = UIColorHex(0xEE873AFF);
    self.actionPressedColor   = UIColorHex(0xF5F5F5FF);
    
    self.defaultActionCancel  = @"取消";
    
    self.dimBackgroundColor = UIColorHex(0x0000007F);
    self.dimBackgroundBlurEnabled = NO;
    self.dimBackgroundBlurEffectStyle = UIBlurEffectStyleExtraLight;
    
    return self;
}

@end
