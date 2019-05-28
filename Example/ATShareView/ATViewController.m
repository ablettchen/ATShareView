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
#import <ATShareView.h>

@interface ATViewController ()

@end

@implementation ATViewController

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
    
    ATSocialWechat *social = [ATSocialWechat new];
    social.appKey = @"wx2ae02e63bbc106f9";
    social.appSecret = @"135c066f553499b7acd1549bf679308a";
    social.redirectURL = @"http://mobile.umeng.com/social";
    
    void(^selected)(id<ATSocialProtocol> _Nonnull social) = ^(id<ATSocialProtocol> _Nonnull social) {
        
    };
    
    ATShareView.build.withTitle(@"Share to").withRes(web).withSocials(@[social]).withSelected(selected).showInWindow();
    
}

@end
