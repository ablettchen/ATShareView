//
//  ATViewController.m
//  ATShareView
//  https://github.com/ablettchen/ATShareView
//
//  Created by ablett on 05/10/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATViewController.h"
#import <ATCategories/ATCategories.h>
#import <ATShareView/ATShareView.h>
#import "ATCustomSocails.h"
#import <UIView+ATToast.h>

#define wechat_appkey       @"wx2ae02e63bbc106f9"
#define wechat_appSecret    @"135c066f553499b7acd1549bf679308a"

#define qq_appkey           @"1105877074"
#define qq_appSecret        @"ljoV3ksZld58bjl6"

#define sina_appkey         @"3368355118"
#define sina_appSecret      @"d92a7808288a3100a611b2208f095839"

#define umeng_redirectUrl   @"http://mobile.umeng.com/social"
#define sina_redirectUrl    @"http://sns.whalecloud.com/sina2/callback"

@interface ATViewController ()

@end

@implementation ATViewController

NS_INLINE UIWindow *at_keyWindow() {
    return [UIApplication sharedApplication].keyWindow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"ATShareView";
    
    UIButton *shareBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:view];
        view.at_size = CGSizeMake(200, 50);
        view.at_top = self.view.at_top + (IS_IPHONE_X?135:100);
        view.at_centerX = self.view.at_centerX;
        [view setTitle:@"share action" forState:UIControlStateNormal];
        [view setTitleColor:UIColorHex(0x0067d8FF) forState:UIControlStateNormal];
        [view setTitleColor:UIColorHex(0xFFFFFFFF) forState:UIControlStateHighlighted];
        [view setBackgroundImage:[UIImage imageWithColor:UIColorHex(0x0067d8FF)] forState:UIControlStateHighlighted];
        [view.titleLabel setFont:[UIFont systemFontOfSize:18]];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = UIColorHex(0x0067d8FF).CGColor;
        view.layer.cornerRadius = 5.f;
        view.layer.masksToBounds = YES;
        view;
    });
    
    [shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shareAction:(UIButton *)sender {
    
    ATShareResWeb *web = [ATShareResWeb new];
    web.title = @"ATShareView";
    web.desc = @"Social share view";
    web.thumb = [UIImage imageNamed:@"avatar"];
    web.urlString = @"https://github.com/ablettchen/ATShareView";
    
    ATSocialWechat *wechat = [ATSocialWechat new];
    wechat.appKey = wechat_appkey;
    wechat.appSecret = wechat_appSecret;
    wechat.redirectURL = umeng_redirectUrl;
    
    ATSocialWechatTimeline *wechatTimeline = [ATSocialWechatTimeline new];
    wechatTimeline.appKey = wechat_appkey;
    wechatTimeline.appSecret = wechat_appSecret;
    wechatTimeline.redirectURL = umeng_redirectUrl;
    
    ATSocialQQ *qq = [ATSocialQQ new];
    qq.appKey = qq_appkey;
    qq.appSecret = qq_appSecret;
    qq.redirectURL = umeng_redirectUrl;
    
    ATSocialQZone *qZone = [ATSocialQZone new];
    qZone.appKey = qq_appkey;
    qZone.appSecret = qq_appSecret;
    qZone.redirectURL = umeng_redirectUrl;
    
    ATSocialSina *sina = [ATSocialSina new];
    sina.appKey = sina_appkey;
    sina.appSecret = sina_appSecret;
    sina.redirectURL = sina_redirectUrl;
    
    ATSocailAblett *ablett = [ATSocailAblett new];
    ablett.customAction = ^(id<ATSocialProtocol>  _Nullable obj) {
        NSString *msg = [NSString stringWithFormat:@"%@ clicked", obj.description];
        [at_keyWindow() makeToast:msg];
    };
    
    ATShare *share = [ATShare new];
    share.res = web;
    
    [share addSocial:ablett];
    [share addSocial:wechat];
    [share addSocial:wechatTimeline];
    [share addSocial:qq];
    [share addSocial:qZone];
    [share addSocial:sina];
    
    ATWebURLActionCopy *copy = [ATWebURLActionCopy new];
    copy.action = ^(id<ATWebURLActionProtocol>  _Nullable obj) {
        [at_keyWindow() makeToast:obj.description];
    };
    ATWebURLActionRefresh *refresh = [ATWebURLActionRefresh new];
    refresh.action = ^(id<ATWebURLActionProtocol>  _Nullable obj) {
        [at_keyWindow() makeToast:obj.description];
    };
    ATWebURLActionOpenInSafari *safari = [ATWebURLActionOpenInSafari new];
    safari.action = ^(id<ATWebURLActionProtocol>  _Nullable obj) {
        [at_keyWindow() makeToast:obj.description];
    };
    
    [share addWebURLAction:copy];
    [share addWebURLAction:refresh];
    [share addWebURLAction:safari];
    
    ATShareView *shareView = \
    [ATShareView viewWithTitle:@"页面由github.com提供"
                         share:share
                      finished:^(NSError * _Nullable error, id<ATSocialProtocol>  _Nullable social) {
                          
                          NSString *msg = error?error.localizedDescription:@"succeed";
                          [at_keyWindow() makeToast:msg];

    }];
    shareView.validEnable = YES;
    [shareView show];
    
}

@end
