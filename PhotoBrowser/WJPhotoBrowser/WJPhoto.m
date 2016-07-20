//
//  WJPhoto.m
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "WJPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WJPhoto()
{
    NSString *_photoPath;
}
@end

@implementation WJPhoto
@synthesize underlyingImage = _underlyingImage;

#pragma mark - Class Methods
+ (instancetype)photoWithImage:(UIImage *)image{
    return [[self alloc] initWithImage:image];
}

+ (instancetype)photoWithURL:(NSURL *)url{
    return [[self alloc] initWithURL:url];
}

#pragma mark - Instance Initialize
- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        _underlyingImage = image;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url{
    self = [super init];
    if (self) {
        _photoURL = [url copy];
    }
    return self;
}

#pragma mark - Get Image

- (UIImage *)underlyingImage{
    return _underlyingImage;
}

- (void)loadUnderlyingImageAndNotify{
    if (_underlyingImage) {
        [self notifyImageDidFinishLoad];
    }
    else{
        if (_photoURL) {
            //load async from web
            [self asyncLoadImageWithURL:_photoURL];
        }
        else if (_photoPath){
            //load async from file
            [self asyncLoadImageWithFilePath:_photoPath];
        }
        else{
            //no source - failed
            _underlyingImage = nil;
            [self notifyImageDidFailLoadWithError:nil];
        }
    }
}

#pragma mark - Async Loading Image
- (void)asyncLoadImageWithURL:(NSURL *)url{
    [self notifyImageDidStartLoad];
    
    //TODO:load image
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:url
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize){
                             
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            if (!error)
                            {
                                _underlyingImage = image;
                                
                                [self notifyImageDidFinishLoad];
                            }
                            else
                            {
                                [self notifyImageDidFailLoadWithError:error];
                            }
                            
                        }];
}

- (void)asyncLoadImageWithFilePath:(NSString *)path{
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:&error];
    if (!error) {
        _underlyingImage = [UIImage imageWithData:data];
        [self notifyImageDidFinishLoad];
    }
    else{
        _underlyingImage = nil;
        [self notifyImageDidFailLoadWithError:error];
    }
}

#pragma mark - CXPhotoProtocol Notify
- (void)notifyImageDidStartLoad
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PB_ImageDidStartLoad object:self];
    });
}

- (void)notifyImageDidFinishLoad
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PB_ImageDidFinishLoad object:self];
    });
}

- (void)notifyImageDidFailLoadWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *notifyInfo = [NSDictionary dictionaryWithObjectsAndKeys:error,@"error", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PB_ImageDidFailLoad object:self userInfo:notifyInfo];
    });
}

- (void)notifyImageDidStartReload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PB_ImageDidStartReload object:self userInfo:nil];
    });
}

@end
