//
//  WJDataSourceVC.m
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "WJDataSourceVC.h"
#import "WJPhotoBrowser.h"
#import "WJPhoto.h"

@interface WJDataSourceVC ()
<
WJPhotoBrowserDataSource,
WJPhotoBrowserDelegate
>

@property (nonatomic, strong) WJPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray<id<WJPhotoProtocol>> *photoDataSource;

@end

@implementation WJDataSourceVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.browser = [[WJPhotoBrowser alloc]initWithDataSource:self delegate:self];
    [self.view addSubview:self.browser.view];
    
    [self setupInfoData];
}

- (void)setupInfoData{
    _photoDataSource = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        WJPhoto *photo = [WJPhoto new];
        photo.title = [@(i) stringValue];
        [_photoDataSource addObject:photo];
    }
    [self.browser reloadData];
}

#pragma mark - Network Request


#pragma mark - PhotoBrowser DataSource & Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WJPhotoBrowser *)photoBrowser{
    return [_photoDataSource count];
}

- (id<WJPhotoProtocol>)photoBrowser:(WJPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    return [_photoDataSource objectAtIndex:index];
}

@end
