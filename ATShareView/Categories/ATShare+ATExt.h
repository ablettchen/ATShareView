//
//  ATShare+ATExt.h
//  ATShareView
//  https://github.com/ablettchen/ATShareView
//
//  Created by ablett on 05/10/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATShare.h"
#import "ATSocialProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATShare (ATExt)

@property (copy, nonatomic, nullable) void(^selected)(id<ATSocialProtocol> _Nonnull social);

- (void)show;
- (void)hide;

@end

NS_ASSUME_NONNULL_END
