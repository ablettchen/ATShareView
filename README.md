# ATShareView

[![CI Status](https://img.shields.io/travis/ablettchen@gmail.com/ATShareView.svg?style=flat)](https://travis-ci.org/ablettchen@gmail.com/ATShareView)
[![Version](https://img.shields.io/cocoapods/v/ATShareView.svg?style=flat)](https://cocoapods.org/pods/ATShareView)
[![License](https://img.shields.io/cocoapods/l/ATShareView.svg?style=flat)](https://cocoapods.org/pods/ATShareView)
[![Platform](https://img.shields.io/cocoapods/p/ATShareView.svg?style=flat)](https://cocoapods.org/pods/ATShareView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objectiveC
#import <ATShareView/ATShareView.h>
```

```objectiveC
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

```

## Requirements

## Installation

ATShareView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATShareView'
```

## Author

ablett, ablett.chen@gmail.com

## License

ATShareView is available under the MIT license. See the LICENSE file for more info.
