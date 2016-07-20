//
//  WJZoomScrollView.m
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "WJZoomScrollView.h"
#import "WJPhotoLoadingView.h"
#import "WJPhoto.h"

@interface WJZoomScrollView()
<
UIScrollViewDelegate
>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WJPhotoLoadingView *loadingView;

@end

@implementation WJZoomScrollView

- (instancetype)init{
    self = [super init];
    if (self) {
        
        //Image View
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        
        //init
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)showImage{
    if (_photo && !_imageView.image) {
        self.userInteractionEnabled = YES;
        //reset
        self.maximumZoomScale = 1;
        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.contentSize = CGSizeZero;
        
        UIImage *image = [_photo underlyingImage];
        if (image) {
            [_loadingView removeFromSuperview];
            
            //Set image
            _imageView.image = image;
            _imageView.hidden = NO;
            
            
        }
        else{
            //Show loading view
            _imageView.hidden = YES;
            [self setupLoadingView];
            [_photo loadUnderlyingImageAndNotify];
        }
    }
}

- (void)setupLoadingView{
    [_loadingView removeFromSuperview];
    _loadingView = [[WJPhotoLoadingView alloc]init];
    _loadingView.frame = self.bounds;
    [self addSubview:_loadingView];
}

@end
