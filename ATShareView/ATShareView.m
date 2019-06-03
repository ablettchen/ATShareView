//
//  ATShareView.m
//  ATShareView
//  https://github.com/ablettchen/ATShareView
//
//  Created by ablett on 05/10/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATShareView.h"
#if __has_include(<ATCategories/ATCategories.h>)
#import <ATCategories/ATCategories.h>
#else
#import "ATCategories.h"
#endif

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@interface ATShareActionCell : UICollectionViewCell
@property (copy, nonatomic) UIImage *icon;
@property (copy, nonatomic) NSString *name;
@end
@interface ATShareActionCell ()
@property (strong, nonatomic) UIButton *iconView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (copy, nonatomic) void(^selectedBlock)(void);
@end
@implementation ATShareActionCell

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    [self.iconView setBackgroundImage:icon forState:UIControlStateNormal];
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name?:@"-";
}

- (void)buttonAction:(UIButton *)sender {
    if (self.selectedBlock) {
        self.selectedBlock();
    }
}

@end

@interface ATShareView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDataSource>

@property (nonnull, nonatomic, strong, readwrite) ATShare *share;
@property (nullable, nonatomic, copy) void(^customSocial)(id<ATSocialProtocol>socail);
@property (nullable, nonatomic, copy) void(^urlAction)(id<ATWebURLActionProtocol>action);
@property (nullable, nonatomic, copy) ATShareFinishedBlock finished;

@property (nonatomic, strong, readonly) ATShareConf *conf;

@property (nonatomic, strong, readonly) UIView *backgroundView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *socialView;
@property (nonatomic, strong, readonly) UIView *actionView;
@property (nonatomic, strong, readonly) UIButton *cancelBtn;

@end

@implementation ATShareView

@synthesize conf = _conf;
@synthesize backgroundView = _backgroundView;
@synthesize titleLabel = _titleLabel;
@synthesize socialView = _socialView;
@synthesize actionView = _actionView;
@synthesize cancelBtn = _cancelBtn;

#pragma mark - Lifecycle

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - %s", (int)__LINE__, __func__);
#endif
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.clipsToBounds = YES;
    self.alpha = 0.001f;
    self.update(^(ATShareConf * _Nonnull conf) {});
    
    return self;
}

#pragma mark - Setter, Getter

- (void (^)(void (^ _Nonnull)(ATShareConf * _Nonnull)))update {
    @weakify(self);
    return ^void(void(^block)(ATShareConf *config)) {
        @strongify(self);
        if (!self) return;
        if (block) block(self.conf);
        ///backgroundView
        self.backgroundView.backgroundColor = self.conf.dimBackgroundColor;
        ///contentView
        self.backgroundColor = self.conf.backgroundColor;
        self.layer.borderWidth = self.conf.splitWidth;
        self.layer.borderColor = self.conf.splitColor.CGColor;
        ///titleLabel
        self.titleLabel.backgroundColor = self.conf.backgroundColor;
        self.titleLabel.font = self.conf.titleFont;
        self.titleLabel.textColor = self.conf.titleColor;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        ///socialView
        self.socialView.backgroundColor = self.conf.backgroundColor;
        ///actionView
        self.actionView.backgroundColor = self.conf.backgroundColor;
        
        /// 刷新 socialView、actionView
    };
}

- (ATShareConf *)conf {
    if (_conf) return _conf;
    _conf = [ATShareConf new];
    return _conf;
}

- (UIView *)backgroundView  {
    if (_backgroundView) return _backgroundView;
    _backgroundView = [UIView new];
    _backgroundView.clipsToBounds = YES;
    _backgroundView.alpha = 0.001f;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
    gesture.cancelsTouchesInView = NO;
    gesture.delegate = self;
    [_backgroundView addGestureRecognizer:gesture];
    return _backgroundView;
}

- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 0;
    return _titleLabel;
}

- (UIView *)socialView {
    if (_socialView) return _socialView;
    _socialView = [UIView new];
    return _socialView;
}

- (UIView *)actionView {
    if (_actionView) return _actionView;
    _actionView = [UIView new];
    return _actionView;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn) return _cancelBtn;
    _cancelBtn = [UIButton buttonWithTarget:self action:@selector(hide)];
    [_cancelBtn setTitle:self.conf.defaultCancelText forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:self.conf.cancelColor forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[UIImage imageWithColor:self.conf.backgroundColor] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[UIImage imageWithColor:self.conf.cancelPressedColor] forState:UIControlStateHighlighted];
    [_cancelBtn.titleLabel setFont:self.conf.cancelFont];
    return _cancelBtn;
}

#pragma mark - Privite

- (void)setupViewIn:(UIView *)view {
    
    
    
    [view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    [self.backgroundView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.centerX.equalTo(self.backgroundView);
    }];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    
    if (self.title.length > 0) {
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).inset(self.conf.insets.top);
            make.left.right.equalTo(self).insets(self.conf.insets);
        }];
        self.titleLabel.text = self.title;
        CGFloat labelWidth = self.conf.width-self.conf.insets.left-self.conf.insets.right;
        CGFloat labeHeight = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, HUGE)].height;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(labeHeight);
        }];
        lastAttribute = self.titleLabel.mas_bottom;
    }
    
    [self addSubview:self.socialView];
    [self.socialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset((self.title.length > 0) ? 10 : self.conf.insets.top);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.conf.itemSize.height);
    }];

    [self addSubview:self.actionView];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.socialView.mas_bottom).offset(self.conf.splitWidth);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.conf.itemSize.height);
    }];
    
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.actionView.mas_bottom).offset(self.conf.splitWidth);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.conf.cancelHeight);
    }];
    
    CGFloat height = IS_IPHONE_X ? 33 : 0;
    UIView *extraView = ({
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cancelBtn.mas_bottom);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(height);
        }];
        view.backgroundColor = self.conf.backgroundColor;
        view;
    });
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(extraView.mas_bottom);
    }];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundView).offset(self.backgroundView.superview.at_height);
    }];
    
    [self.backgroundView layoutIfNeeded];
}

- (void)actionTap:(UITapGestureRecognizer *)gesture {
    [self hide];
}

- (void)hide {
    [self hide:self.didHide];
}

- (void)hide:(void(^ __nullable)(BOOL finished))completion {
    // hide aanimation
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.backgroundView.alpha = 0.001f;
                         [self mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.bottom.equalTo(self.backgroundView.mas_bottom).offset(self.backgroundView.superview.at_height);
                         }];
                         [self.backgroundView layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview],
                             [self.backgroundView removeFromSuperview], _backgroundView = nil;
                         }
                         if (completion) {completion(finished);}
                     }];
}

- (void)show:(void(^ __nullable)(BOOL finished))completion {
    [self showIn:[[UIApplication sharedApplication] keyWindow] completion:completion];
}

- (void)showIn:(UIView *)view completion:(void(^)(BOOL finished))completion {
    // setup views
    [self setupViewIn:view];
    // show animation
    self.alpha = 1.0f;
    [self bringSubviewToFront:view];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.backgroundView.alpha = 1.0f;
                         [self mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.bottom.equalTo(self.backgroundView).offset(0);
                         }];
                         [self.backgroundView layoutIfNeeded];
                     }
                     completion:completion];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (touch.view == self.backgroundView);
}

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

#pragma mark - Public

+ (instancetype)viewWithTitle:(nullable NSString *)title
                        share:(nonnull ATShare *)share
                 customSocial:(void(^__nullable)(id<ATSocialProtocol>socail))customSocial
                    urlAction:(void(^__nullable)(id<ATWebURLActionProtocol>action))urlAction
                     finished:(nullable ATShareFinishedBlock)finished {
    if (!share || !share.res || share.socials.count == 0) {return nil;}
    ATShareView *view = [ATShareView new];
    view.title = title;
    view.share = share;
    view.customSocial = customSocial;
    view.urlAction = urlAction;
    view.finished = finished;
    return view;
}

- (void)show {
    [self show:self.didShow];
}

@end

@implementation ATShareConf

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    [self reset];
    
    return self;
}

- (void)reset {
    
    _dimBackgroundColor     = UIColorHex(0x0000007F);
    _backgroundColor        = UIColorHex(0xE7E7E7FF);
    _width                  = SCREEN_WIDTH;
    
    _insets                 = UIEdgeInsetsMake(15, 15, 15, 15);
    
    _titleFont              = [UIFont systemFontOfSize:14];
    _titleColor             = UIColorHex(0x666666FF);
    
    _itemSize               = CGSizeMake(80, 80);
    _itemFont               = [UIFont systemFontOfSize:11];
    _itemColor              = UIColorHex(0x666666FF);
    
    _splitColor             = UIColorHex(0xE7E7E7FF);
    _splitWidth             = 1/[UIScreen mainScreen].scale;
    
    _cancelHeight           = 50.f;
    _cancelFont             = [UIFont systemFontOfSize:17];
    _cancelColor            = UIColorHex(0x333333FF);
    _cancelHighlightColor   = UIColorHex(0x666666FF);
    _cancelPressedColor     = UIColorHex(0xF5F5F5FF);
    _defaultCancelText      = @"取消";
}

@end
