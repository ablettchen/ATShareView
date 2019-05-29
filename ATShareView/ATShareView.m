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

@interface ATShareActionCell : UICollectionViewCell
@property (copy, nonatomic) UIImage *icon;
@property (copy, nonatomic) NSString *name;
@end
@interface ATShareActionCell ()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *nameLabel;
@end
@implementation ATShareActionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    ATShareViewConfig *config = [ATShareViewConfig globalConfig];
    
    _iconView = ({
        UIImageView *view = [UIImageView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(config.socailWidth, config.socailWidth));
            make.top.equalTo(self);
            make.centerX.equalTo(self);
        }];
        view;
    });
    
    _nameLabel = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(10);
            make.left.right.equalTo(self);
        }];
        label.font = [UIFont systemFontOfSize:config.socialFontSize];
        label.textColor = config.socialColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label;
    });
    
    return self;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.iconView.image = icon;
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = name?:@"-";
}

@end

@interface ATShareView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDataSource>
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UICollectionView *socialView;
@property (strong, nonatomic) UICollectionView *actionView;
@property (strong, nonatomic) UIButton *cancelBtn;
@end
@implementation ATShareView

#pragma mark - lifecycle

#pragma mark - privite

- (void)setupWithTitle:(nullable NSString *)title
                   res:(id<ATShareResProtocol>)res
               socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
              selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected
              finished:(void(^_Nullable)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social))finished{
    
    NSAssert(res != nil, @"Could not find res.");
    NSAssert(socials.count > 0, @"Could not find any socials.");
    
    self.title = title;
    self.res = res;
    self.socials = socials;
    self.selected = selected;
    self.finished = finished;
    
    self.type = ATPopupTypeSheet;
    
    ATShareViewConfig *config = [ATShareViewConfig globalConfig];
    self.layer.cornerRadius = config.cornerRadius;
    self.clipsToBounds = YES;
    self.layer.borderWidth = AT_SPLIT_WIDTH;
    self.layer.borderColor = config.splitColor.CGColor;
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(config.width);
    }];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    UIVisualEffectView *effectView = \
    [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
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
        self.titleLabel.text = self.title;
        lastAttribute = self.titleLabel.mas_bottom;
    }
    
    BOOL titleIsNil = (self.title.length == 0) ? YES : NO;
    
    UICollectionViewFlowLayout *socialLayout = [UICollectionViewFlowLayout new];
    socialLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    socialLayout.minimumLineSpacing = 10;
    socialLayout.minimumInteritemSpacing = 0;

    self.socialView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:socialLayout];
    [self addSubview:self.socialView];
    [self.socialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(titleIsNil?config.innerMargin:config.titlePadding);
        make.left.right.equalTo(self);
        make.height.equalTo(@(config.socailHeight));
    }];
    self.socialView.dataSource = self;
    self.socialView.delegate = self;
    self.socialView.scrollsToTop = NO;
    self.socialView.showsVerticalScrollIndicator = NO;
    self.socialView.showsHorizontalScrollIndicator = NO;
    [self.socialView registerClass:[ATShareActionCell class] forCellWithReuseIdentifier:NSStringFromClass([ATShareActionCell class])];
    self.socialView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.socialView.backgroundColor = [UIColor clearColor];
    
    lastAttribute = self.socialView.mas_bottom;
    
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
        
        UICollectionViewFlowLayout *actionLayout = [UICollectionViewFlowLayout new];
        actionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        actionLayout.minimumLineSpacing = 10;
        actionLayout.minimumInteritemSpacing = 0;
        
        self.actionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:actionLayout];
        [self addSubview:self.actionView];
        [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);
            make.left.right.equalTo(self);
            make.height.equalTo(@(config.actionHeight));
        }];
        self.actionView.dataSource = self;
        self.actionView.delegate = self;
        self.actionView.scrollsToTop = NO;
        self.actionView.showsVerticalScrollIndicator = NO;
        self.actionView.showsHorizontalScrollIndicator = NO;
        [self.actionView registerClass:[ATShareActionCell class] forCellWithReuseIdentifier:NSStringFromClass([ATShareActionCell class])];
        self.actionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.actionView.backgroundColor = [UIColor clearColor];
        
        lastAttribute = self.actionView.mas_bottom;
    }
    
    self.cancelBtn = [UIButton buttonWithTarget:self action:@selector(cancenAction:)];
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(AT_SPLIT_WIDTH);
        make.left.right.equalTo(self);
        make.height.equalTo(@(config.cancelHeight));
    }];
    [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageWithColor:config.cancelPressedColor] forState:UIControlStateHighlighted];
    [self.cancelBtn setTitle:config.defaultCancelText forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:config.cancelNormalColor forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:config.cancelHighlightColor forState:UIControlStateHighlighted];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:config.buttonFontSize]];
    
    lastAttribute = self.cancelBtn.mas_bottom;
    
    if (IS_IPHONE_X) {
        UIView *view = [UIView new];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute);//.offset(AT_SPLIT_WIDTH);
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

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATShareViewConfig *config = [ATShareViewConfig globalConfig];
    if (collectionView == self.socialView) {
        return CGSizeMake(config.socailWidth, config.socailHeight-20);
    }
    return CGSizeMake(config.actionWidth, config.actionHeight-20);
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.socialView) {
        return self.socials.count;
    }
    return [ATShare defaultWebURLActions].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ATShareActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ATShareActionCell class])
                                                                        forIndexPath:indexPath];
    if (collectionView == self.socialView) {
        cell.icon = self.socials[indexPath.item].icon;
        cell.name = self.socials[indexPath.item].name;
        return cell;
    }
    cell.icon = [ATShare defaultWebURLActions][indexPath.item].icon;
    cell.name = [ATShare defaultWebURLActions][indexPath.item].name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selected) {
        self.selected(self.socials[indexPath.item]);
    }
    if (collectionView == self.socialView) {
        if (self.socials[indexPath.item].type == kATSocialTypeCustom) {
            if (self.selected) {
                self.selected(self.socials[indexPath.item]);
            }
        }else {
            [[ATShare new] shareTo:self.socials[indexPath.item] res:self.res finished:self.finished];
        }
    }else {
        //[ATShare defaultWebURLActions]
    }
}

#pragma mark - overwrite

- (void)show:(ATPopupCompletionBlock)block {
    [self setupWithTitle:self.title res:self.res socials:self.socials selected:self.selected finished:self.finished];
    [super show:block];
}

#pragma mark - public

- (instancetype)initWithRes:(id<ATShareResProtocol>)res
                    socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                   finished:(void(^_Nullable)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social))finished {
    return [self initWithRes:res socials:socials selected:nil finished:finished];
}

- (instancetype)initWithRes:(id<ATShareResProtocol>)res
                    socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                   selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected
                   finished:(void(^_Nullable)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social))finished {
    return [self initWithTitle:nil res:res socials:socials selected:selected finished:finished];
}

- (instancetype)initWithTitle:(nullable NSString *)title
                          res:(id<ATShareResProtocol>)res
                      socials:(nonnull NSArray <id<ATSocialProtocol>> *)socials
                     selected:(void(^_Nullable)(id<ATSocialProtocol> _Nonnull social))selected
                     finished:(void(^_Nullable)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social))finished{
    
    self = [super init];
    if (!self) return nil;
    self.title = title;
    self.res = res;
    self.socials = socials;
    self.selected = selected;
    self.finished = finished;
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

- (__kindof ATShareView *(^)(void(^ _Nullable finished)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social)))withFinished {
    return ^ __kindof ATShareView *(void(^finished)(NSError * _Nullable error, id<ATSocialProtocol> _Nullable social)) {
        self.finished = finished;
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
    self.socailWidth    = 63.0f;
    self.socailHeight   = 120.0f;
    self.actionWidth    = 63.0f;
    self.actionHeight   = 120.0f;
    self.cancelHeight   = 50.0f;
    self.innerMargin    = 15.0f;
    self.cornerRadius   = 0.0f;
    self.titlePadding   = 10.0f;
    
    self.titleFontSize  = 14.0f;
    self.socialFontSize = 11.0f;
    self.buttonFontSize = 17.0f;
    
    self.backgroundColor    = UIColorHex(0xFFFFFFFF);
    self.titleColor         = UIColorHex(0x666666FF);
    self.socialColor        = UIColorHex(0x666666FF);
    self.splitColor         = UIColorHex(0xCCCCCCFF);
    
    self.cancelNormalColor    = UIColorHex(0x333333FF);
    self.cancelHighlightColor = UIColorHex(0x666666FF);
    self.cancelPressedColor   = UIColorHex(0xF5F5F5FF);
    
    self.defaultCancelText  = @"取消";
    
    self.dimBackgroundColor = UIColorHex(0x0000007F);
    self.dimBackgroundBlurEnabled = NO;
    self.dimBackgroundBlurEffectStyle = UIBlurEffectStyleExtraLight;
    
    return self;
}

@end
