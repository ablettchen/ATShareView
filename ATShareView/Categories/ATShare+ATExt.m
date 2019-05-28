//
//  ATShare+ATExt.m
//  ATShareView
//  https://github.com/ablettchen/ATShareView
//
//  Created by ablett on 05/10/2019.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATShare+ATExt.h"
#import <objc/runtime.h>

@interface ATShare ()

@end

@implementation ATShare (ATExt)

- (void)setSelected:(void (^)(id<ATSocialProtocol> _Nonnull))selected {
    objc_setAssociatedObject(self, @selector(selected), selected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(id<ATSocialProtocol> _Nonnull))selected {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - privite

#pragma mark - public

- (void)show {
    
}

- (void)hide {
    
}

@end
