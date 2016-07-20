//
//  WJPhoto.m
//  PhotoBrowser
//
//  Created by 邓伟杰 on 16/7/19.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "WJPhoto.h"

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
    [self notifyImageDidFinishLoad];
    
    //TODO:load image
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

@end
