//
//  WJZoomScrollView.h
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJPhotoProtocol.h"

@class WJPhoto,WJPhotoBrowser;
@interface WJZoomScrollView : UIScrollView

@property (nonatomic, strong) id<WJPhotoProtocol> photo;


@end
