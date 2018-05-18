//
//  LRImageStore.m
//  LRImageLoader
//
//  Created by Ruan Lingqi on 14/11/17.
//  Copyright © 2017年 tomrlq. All rights reserved.
//

#import "LRImageStore.h"
#import "LRImageConnection.h"
#import <CommonCrypto/CommonCrypto.h>

@interface LRImageStore ()
{
    NSMutableDictionary *memoryCache;
}
@end

@implementation LRImageStore

#pragma mark - Life Cycle

+ (LRImageStore *)sharedStore {
    static LRImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[super allocWithZone:NULL] init];
    });
    return sharedStore;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedStore];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        memoryCache = [NSMutableDictionary dictionary];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(clearMemoryCache)
                       name:UIApplicationDidReceiveMemoryWarningNotification
                     object:nil];
        [self checkImageDirectoryExist];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Convenience Methods

- (void)fetchImageForURL:(NSURL *)url progress:(LRImageProgressBlock)progress completion:(LRImageCompletionBlock)completion {
    if (!url) {
        completion ? completion(nil, @"URL is nil") : nil;
        return;
    }
    // check cache first
    NSString *key = [self keyForURL:url];
    UIImage *image = [self imageForKey:key];
    if (image) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion ? completion(image, nil) : nil;
        }];
        return;
    }
    // if not cached, then download
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    LRImageConnection *connection = [LRImageConnection connectionWithRequest:request];
    [connection startWithProgress:progress completion:^(UIImage *image, NSString *error) {
        if (!error) {
            [self setImage:image forKey:key];
        }
        completion ? completion(image, error) : nil;
    }];
}

#pragma mark - Image Cache Methods

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
    [memoryCache setObject:image forKey:key];
    NSString *imagePath = [self imagePathForKey:key];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    [imageData writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key {
    UIImage *result = [memoryCache objectForKey:key];
    if (!result) {
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:key]];
        if (result) {
            [memoryCache setObject:result forKey:key];
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)key {
    [memoryCache removeObjectForKey:key];
    NSString *path = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:path
                                               error:nil];
}

- (NSString *)imagePathForKey:(NSString *)key {
    NSString *path = [self imageDirectory];
    path = [path stringByAppendingPathComponent:key];
    path = [path stringByAppendingPathExtension:@"jpg"];
    return path;
}

- (NSString *)keyForURL:(NSURL *)url {
    NSString *urlString = [url absoluteString];
    const char *str = [urlString UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *key = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    return key;
}

#pragma mark - Directory Related Methods

- (NSString *)imageDirectory {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                              NSUserDomainMask,
                                                              YES).firstObject;
    return [cachePath stringByAppendingPathComponent:@"imageCache"];
}

- (void)checkImageDirectoryExist {
    NSString *directoryPath = [self imageDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
}

#pragma mark - Clear Related Methods

- (void)clearMemoryCache {
    NSLog(@"flushing %d images out of the cache", (int)memoryCache.count);
    [memoryCache removeAllObjects];
}

- (void)clearDiskCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self imageDirectory] error:nil];
    [fileManager createDirectoryAtPath:[self imageDirectory]
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
}

@end
