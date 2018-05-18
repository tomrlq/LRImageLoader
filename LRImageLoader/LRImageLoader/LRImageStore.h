//
//  LRImageStore.h
//  LRImageLoader
//
//  Created by Ruan Lingqi on 14/11/17.
//  Copyright © 2017年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// progress callback
typedef void(^LRImageProgressBlock)(NSProgress *_Nonnull progress, UIImage *_Nullable partialImage);
/// completion callback
typedef void(^LRImageCompletionBlock)(UIImage *_Nullable image, NSString *_Nullable error);

/**
 * An ImageStore with convenience methods for image loading and caching
 */
@interface LRImageStore : NSObject

/// Singleton
+ (nonnull LRImageStore *)sharedStore;

/// convenience method for fetching image
- (void)fetchImageForURL:(nonnull NSURL *)url
                progress:(nullable LRImageProgressBlock)progressBlock
              completion:(nullable LRImageCompletionBlock)completionBlock;

/* image cache methods */
- (nonnull NSString *)keyForURL:(nonnull NSURL *)url;
- (void)setImage:(nonnull UIImage *)image
          forKey:(nonnull NSString *)key;
- (nullable UIImage *)imageForKey:(nonnull NSString *)key;
- (void)deleteImageForKey:(nonnull NSString *)key;
- (nonnull NSString *)imagePathForKey:(nonnull NSString *)key;

/* clear cache methods */
- (void)clearMemoryCache;
- (void)clearDiskCache;

@end
