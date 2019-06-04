#
# Be sure to run `pod lib lint ATShareView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
    s.name                    = 'ATShareView'
    s.version                 = '0.1.4'
    s.summary                 = 'Social share view'
    s.homepage                = 'https://github.com/ablettchen/ATShareView'
    s.license                 = { :type => 'MIT', :file => 'LICENSE' }
    s.author                  = { 'ablett' => 'ablettchen@gmail.com' }
    s.source                  = { :git => 'https://github.com/ablettchen/ATShareView.git', :tag => s.version.to_s }
    s.social_media_url        = 'https://twitter.com/ablettchen'
    s.ios.deployment_target   = '8.0'
    s.source_files            = 'ATShareView/**/*.{h,m}'
    s.public_header_files     = 'ATShareView/**/*.{h}'
    #s.resource                = 'ATShareView/ATShareView.bundle'
    s.requires_arc            = true

    s.dependency 'ATShare'
    s.dependency 'Masonry'

end
