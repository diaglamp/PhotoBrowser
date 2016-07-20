//
//  WJPhotoBrowser.m
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "WJPhotoBrowser.h"
#import "WJZoomScrollView.h"
#import "WJPhoto.h"

#define ZOOM_INDEX_TAG_OFFSET 1000
#define ZOOM_INDEX(zoom) ([zoom tag] - ZOOM_INDEX_TAG_OFFSET)

@interface WJPhotoBrowser()
<
UIScrollViewDelegate
>
{
    //Container View
    UIScrollView *_pagingScrollView;
    
    //Paging Model
    NSUInteger _photoCount;//
    NSMutableArray *_photoArr;//<WJPhoto *>模型数组
    
    //Paging View
    NSInteger _currentPage;//当前或者即将显示的Page
    NSMutableSet<WJZoomScrollView *> *_visiblePages;//两侧时2，中间3
    NSMutableSet<WJZoomScrollView *> *_recyclePages;//被回收的page
    
    //Flags
    BOOL _performingLayout;//layout status
    BOOL _isViewInteractive;// scrollable
}
@end

@implementation WJPhotoBrowser

- (instancetype)init{
    self = [super init];
    if (self) {
        self.navigationController.navigationBarHidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        
        _photoCount = NSNotFound;
        _photoArr = [[NSMutableArray alloc]init];
        
        _currentPage = 0;
        _visiblePages = [[NSMutableSet alloc]init];
        _recyclePages = [[NSMutableSet alloc]init];
        
        _performingLayout = NO;
        _isViewInteractive = YES;
    }
    return self;
}

- (instancetype)initWithDataSource:(id<WJPhotoBrowserDataSource>)dataSource delegate:(id<WJPhotoBrowserDelegate>)delegate{
    self = [self init];
    if (self) {
        _dataSource = dataSource;
        _delegate = delegate;
    }
    return self;
}

#pragma mark - Life Circle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _pagingScrollView = ({
        UIScrollView *aScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        aScrollView.pagingEnabled = YES;
        aScrollView.delegate = self;
        aScrollView.showsHorizontalScrollIndicator = NO;
        aScrollView.showsVerticalScrollIndicator = NO;
        aScrollView.bounces = NO;
        aScrollView.backgroundColor = [UIColor blackColor];
        aScrollView;
    });
    [self.view addSubview:_pagingScrollView];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    _isViewInteractive = YES;
}

#pragma mark - Layout
- (void)performLayout{
    _performingLayout = YES;
    
    _pagingScrollView.contentOffset = [self contentOffsetAtIndex:_currentPage];
    
    [self layoutZoomScrollViews];
    
    _performingLayout = NO;
}

//布局ZoomScrollView
- (void)layoutZoomScrollViews{
    
    //保留当前页左一右一 的zoom view
    NSInteger startPage = MAX(_currentPage - 1, 0);
    NSInteger endPage = MIN(_currentPage + 1, [self numberOfPhotos]);
    
    //回收脱离显示区域的zoom ScrollView
    NSInteger zoomIndex;
    for (WJZoomScrollView *zoom in _visiblePages) {
        zoomIndex = ZOOM_INDEX(zoom);
        if (zoomIndex < startPage || zoomIndex > endPage) {
            [_recyclePages addObject:zoom];
            [zoom removeFromSuperview];
        }
    }
    [_visiblePages minusSet:_recyclePages];
    
    //添加进入显示区域的zoom ScrollView
    for (NSInteger index = startPage; index <= endPage; index ++) {
        if (![self isDisplayingZoomAtIndex:index]) {
            WJZoomScrollView *zoom = [self dequeueZoomScrollView];
            if (!zoom) {
                zoom = [[WJZoomScrollView alloc]init];
            }
            [self configureZoom:zoom atIndex:index];
            [_visiblePages addObject:zoom];
            [_pagingScrollView addSubview:zoom];
        }
    }
}

#pragma mark - Zoom ScrollView
//初始化配置Zoom frame tag
- (void)configureZoom:(WJZoomScrollView *)zoom atIndex:(NSInteger)index{
    zoom.frame = [self frameForZoomAtIndex:index];
    zoom.tag = ZOOM_INDEX_TAG_OFFSET + index;
    zoom.backgroundColor = [self randomColor];
}

- (BOOL)isDisplayingZoomAtIndex:(NSInteger)index{
    for (WJZoomScrollView *zoom in _visiblePages)
        if (ZOOM_INDEX(zoom) == index)  return YES;
    return NO;
}

- (WJZoomScrollView *)dequeueZoomScrollView{
    WJZoomScrollView *zoom = [_recyclePages anyObject];
    if (zoom) {
        [_recyclePages removeObject:zoom];
    }
    return zoom;
}


#pragma mark - Data

- (void)reloadData{
    _photoCount = NSNotFound;
    
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    [_photoArr removeAllObjects];
    
    for (NSInteger i = 0; i < numberOfPhotos; i++) {
        [_photoArr addObject:[NSNull null]];
    }

    if (numberOfPhotos > 0) {
        _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
        [self performLayout];
    }
    [self.view setNeedsLayout];
}

- (NSUInteger)numberOfPhotos{
    if (_photoCount == NSNotFound) {
        if ([self.dataSource respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
            _photoCount = [self.dataSource numberOfPhotosInPhotoBrowser:self];
        }
    }
    
    if (_photoCount == NSNotFound) {
        _photoCount = 0;
    }
    
    return _photoCount;
}


#pragma mark - Calculate Frame
- (CGSize)contentSizeForPagingScrollView{
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPhotos], bounds.size.height);
}

- (CGPoint)contentOffsetAtIndex:(NSInteger)index{
    CGFloat pageWidth = _pagingScrollView.bounds.size.width;
    CGFloat newOffset = index * pageWidth;
    return CGPointMake(newOffset, 0);
}

- (CGRect)frameForZoomAtIndex:(NSInteger)index{
    CGRect bounds = _pagingScrollView.bounds;
    CGRect zoomFrame = bounds;
    zoomFrame.origin.x = bounds.size.width * index;
    return zoomFrame;
}

#pragma mark - Scroll View delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //checks
    if (!_isViewInteractive || _performingLayout) return;
    
    ////计算当前pagingScrollView最左和最右分别属于哪一页
    CGRect visibleBounds = _pagingScrollView.bounds;
    
    NSInteger leftIndex = (int)floorf((CGRectGetMinX(visibleBounds)+1)/CGRectGetWidth(visibleBounds));
    NSInteger rightIndex = (int)floorf((CGRectGetMaxX(visibleBounds)-1)/CGRectGetWidth(visibleBounds));
    
    leftIndex = [self value:leftIndex setMax:[self numberOfPhotos] min:0];
    rightIndex = [self value:rightIndex setMax:[self numberOfPhotos] min:0];
    
    if (_currentPage != leftIndex && _currentPage != rightIndex) {
        if (leftIndex > _currentPage) {
            _currentPage = leftIndex;
        }
        else if (rightIndex < _currentPage){
            _currentPage = rightIndex;
        }
        [self layoutZoomScrollViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

#pragma mark - Tools

- (NSInteger)value:(NSInteger)value setMax:(NSInteger)max min:(NSInteger)min{
    value = MAX(value, min);
    value = MIN(value, max);
    return value;
}

- (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
