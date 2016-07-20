//
//  WJPhotoProtocol.h
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#ifndef WJPhotoProtocol_h
#define WJPhotoProtocol_h

#import <UIKit/UIKit.h>

#define NOTI_PB_ImageDidStartLoad @"NOTI_PB_ImageDidStartLoad"
#define NOTI_PB_ImageDidFinishLoad @"NOTI_PB_ImageDidFinishLoad"
#define NOTI_PB_ImageDidFailLoad @"NOTI_PB_ImageDidFailLoad"
#define NOTI_PB_ImageDidStartReload @"NOTI_PB_ImageDidStartReload"

@protocol WJPhotoProtocol <NSObject>

@required

- (UIImage *)underlyingImage;
- (void)loadUnderlyingImageAndNotify;

@optional

- (UIView *)photoLoadingView;
//Notify
- (void)notifyImageDidStartLoad;
- (void)notifyImageDidFinishLoad;
- (void)notifyImageDidFailLoadWithError:(NSError *)error;
- (void)notifyImageDidStartReload;

@end


#endif /* WJPhotoProtocol_h */
