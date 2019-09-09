//
//  ATShareManager.m
//  ATShareView_Example
//
//  Created by ablett on 2019/6/4.
//  Copyright © 2019 ablettchen@gmail.com. All rights reserved.
//

#import "ATShareManager.h"
#import <UIView+ATToast.h>
#import "ATCustomSocails.h"

#define wechat_appkey       @"xxx"
#define wechat_appSecret    @"xxx"

#define qq_appkey           @"xxx"
#define qq_appSecret        @"xxx"

#define sina_appkey         @"xxx"
#define sina_appSecret      @"xxx"

#define umeng_redirectUrl   @"http://mobile.umeng.com/social"
#define sina_redirectUrl    @"http://sns.whalecloud.com/sina2/callback"

@implementation ATShareManager

NS_INLINE UIWindow *at_keyWindow() {
    return [UIApplication sharedApplication].keyWindow;
}

static ATShareManager *defaultManager = nil;

+ (ATShareManager *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

+ (void)releaseManager {
    defaultManager = nil;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [super allocWithZone:zone];
    });
    return defaultManager;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)shareToSocials:(nullable NSArray <NSNumber *>*)socials
                   res:(nonnull id<ATShareResProtocol>)res
              finished:(nullable ATShareFinishedBlock)finished {
    
    ATShare *share = [ATShare new];
    
    if (!socials || socials.count == 0) {
        socials = @[@(SocialTypeAblett),
                    @(SocialTypeWechat),
                    @(SocialTypeWechatTimeline),
                    @(SocialTypeQQ),
                    @(SocialTypeQZone),
                    @(SocialTypeSina)];
    }
    
    for (NSNumber *obj in socials) {
        switch ([obj unsignedIntegerValue]) {
            case SocialTypeAblett:{
                ATSocailAblett *social = [ATSocailAblett new];
                social.customAction = ^(id<ATSocialProtocol>  _Nullable obj) {
                    [at_keyWindow() makeToast:[NSString stringWithFormat:@"请处理自定义平台 - %@ 事件", obj.description]];
                };
                [share addSocial:social];
            }break;
            case SocialTypeWechat:{
                ATSocialWechat *social = [ATSocialWechat new];
                social.appKey = wechat_appkey;
                social.appSecret = wechat_appSecret;
                social.redirectURL = umeng_redirectUrl;
                [share addSocial:social];
            }break;
            case SocialTypeWechatTimeline:{
                ATSocialWechatTimeline *social = [ATSocialWechatTimeline new];
                social.appKey = wechat_appkey;
                social.appSecret = wechat_appSecret;
                social.redirectURL = umeng_redirectUrl;
                [share addSocial:social];
            }break;
            case SocialTypeQQ:{
                ATSocialQQ *social = [ATSocialQQ new];
                social.appKey = qq_appkey;
                social.appSecret = qq_appSecret;
                social.redirectURL = umeng_redirectUrl;
                [share addSocial:social];
            }break;
            case SocialTypeQZone:{
                ATSocialQZone *social = [ATSocialQZone new];
                social.appKey = qq_appkey;
                social.appSecret = qq_appSecret;
                social.redirectURL = umeng_redirectUrl;
                [share addSocial:social];
            }break;
            case SocialTypeSina:{
                ATSocialSina *social = [ATSocialSina new];
                social.appKey = sina_appkey;
                social.appSecret = sina_appSecret;
                social.redirectURL = sina_redirectUrl;
                [share addSocial:social];
            }break;
            default:
                break;
        }
    }
    
    ATWebURLActionCopy *copy = [ATWebURLActionCopy new];
    copy.action = ^(id<ATWebURLActionProtocol>  _Nullable obj) {
        [at_keyWindow() makeToast:[NSString stringWithFormat:@"请处理 URL Action - %@ 事件", obj.description]];
    };
    ATWebURLActionRefresh *refresh = [ATWebURLActionRefresh new];
    refresh.action = ^(id<ATWebURLActionProtocol>  _Nullable obj) {
        [at_keyWindow() makeToast:[NSString stringWithFormat:@"请处理 URL Action - %@ 事件", obj.description]];
    };
    ATWebURLActionOpenInSafari *safari = [ATWebURLActionOpenInSafari new];
    safari.action = ^(id<ATWebURLActionProtocol>  _Nullable obj) {
        [at_keyWindow() makeToast:[NSString stringWithFormat:@"请处理 URL Action - %@ 事件", obj.description]];
    };
    [share addWebURLAction:copy];
    [share addWebURLAction:refresh];
    [share addWebURLAction:safari];
    
    share.res = res;
    
    ATShareView *shareView = \
    [ATShareView viewWithTitle:@"分享到"
                         share:share
                      finished:^(NSError * _Nullable error, id<ATSocialProtocol>  _Nullable social) {
                          NSString *msg = error?@"分享失败":@"分享成功";
                          NSError *aError = error?[NSError errorWithDomain:@"com.ablett.atshare"
                                                                      code:1001
                                                                  userInfo:@{NSLocalizedDescriptionKey:msg}]:nil;
                          if (finished) {finished(aError, social);}
                          [at_keyWindow() makeToast:msg];
                      }];
    shareView.validEnable = NO; ///< 设置为YES, 只显示已经安装了的平台
    
    
    shareView.update(^(ATShareConf * _Nonnull conf) {
        
    });
    [shareView show];
}

@end
