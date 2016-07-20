//
//  WJPhoto.h
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJPhotoProtocol.h"

//zoomScrollView数据模型 
@interface WJPhoto : NSObject
<WJPhotoProtocol>
{
    
}

@property (nonatomic, strong, readonly) UIImage *underlyingImage;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSURL *photoURL;
@property (nonatomic, assign) NSInteger reviewNum; //review number
@property (nonatomic, assign) BOOL collected; //collected status



@end
