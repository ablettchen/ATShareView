//
//  ATSocailCustoms.m
//  ATShareView_Example
//
//  Created by ablett on 2019/5/29.
//  Copyright © 2019 ablettchen@gmail.com. All rights reserved.
//

#import "ATCustomSocails.h"

@implementation ATSocailAblett
@synthesize name;
@synthesize icon;
@synthesize enable;
@synthesize appKey;
@synthesize appSecret;
@synthesize redirectURL;
@synthesize customAction;

- (enum ATSocialType)type {
    return kATSocialTypeCustom;
}

- (NSString *)name {
    return @"发送给\nablett";
}

- (UIImage *)icon {
    return [UIImage imageNamed:@"atshare_social_custom"];
}

- (BOOL)enable {
    return YES;
}

- (NSString *)description {
    return @"ablett";
}

@end
