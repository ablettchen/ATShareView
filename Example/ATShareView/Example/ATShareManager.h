//
//  ATShareManager.h
//  ATShareView_Example
//
//  Created by ablett on 2019/6/4.
//  Copyright © 2019 ablettchen@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ATShareView/ATShareView.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SocialType) {
    SocialTypeAblett            = 1,
    SocialTypeWechat            = 2,
    SocialTypeWechatTimeline    = 3,
    SocialTypeQQ                = 4,
    SocialTypeQZone             = 5,
    SocialTypeSina              = 6,
};

@interface ATShareManager : NSObject

/**
 社会化分享

 @param socials 分享平台，传 nil 则为所有平台。如：@[@(SocialTypeAblett), @(SocialTypeWechat)];
 @param res 资源
 @param finished 回调
 */
- (void)shareToSocials:(nullable NSArray <NSNumber *>*)socials
                   res:(nonnull id<ATShareResProtocol>)res
              finished:(nullable ATShareFinishedBlock)finished;

+ (ATShareManager *)defaultManager;
+ (void)releaseManager;

@end

NS_ASSUME_NONNULL_END
