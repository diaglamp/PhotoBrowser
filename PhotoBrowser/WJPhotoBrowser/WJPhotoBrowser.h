//
//  WJPhotoBrowser.h
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJPhotoProtocol.h"

@protocol WJPhotoBrowserDataSource;
@protocol WJPhotoBrowserDelegate;
@interface WJPhotoBrowser : UIViewController
{
    
}

@property (nonatomic,weak) id<WJPhotoBrowserDataSource> dataSource;
@property (nonatomic,weak) id<WJPhotoBrowserDelegate> delegate;

//initialize
- (instancetype)initWithDataSource:(id<WJPhotoBrowserDataSource>)dataSource delegate:(id<WJPhotoBrowserDelegate>)delegate;

- (void)reloadData;
@end

#pragma mark - Data Source
@protocol WJPhotoBrowserDataSource <NSObject>
@required
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WJPhotoBrowser *)photoBrowser;
- (id <WJPhotoProtocol>)photoBrowser:(WJPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
@end

#pragma mark - Delegate
@protocol WJPhotoBrowserDelegate <NSObject>


@end