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
typedef void(^LRImageCompletionBlock)(UIImage *_Nullable image, NSError *_Nullable error);

/**
 * 'LRImageStore' have convenience methods for image loading and caching
 */
@interface LRImageStore : NSObject

/// Singleton
+ (nonnull LRImageStore *)sharedStore;

#pragma mark - Convenience Methods

/**
 Load an image into imageView
 
 @param url             web URL of image
 @param placeholder     image to display as placeholder
 @param imageView       imageView to load the image into
 */
- (void)loadImage:(nonnull NSString *)url
      placeholder:(nullable UIImage *)placeholder
             into:(nonnull UIImageView *)imageView;

/**
 Download the image if not present in cache
 
 @param url                 web URL of image
 @param progressBlock       Block to receive update. Called on the session queue
 @param completionBlock     Block to handle completion. Called on the main queue
 */
- (void)fetchImageForURL:(nonnull NSString *)url
                progress:(nullable LRImageProgressBlock)progressBlock
              completion:(nullable LRImageCompletionBlock)completionBlock;


#pragma mark - Image Cache Methods

/**
 Return the unique cache key for a given URL
 */
- (nonnull NSString *)keyForURL:(nonnull NSString *)urlString;

/**
 Store an image into memory and disk cache
 
 @param image   image to store
 @param key     unique image cache key
 */
- (void)setImage:(nonnull UIImage *)image
          forKey:(nonnull NSString *)key;

/**
 Query the image from memory and disk cache
 
 @param key     unique image cache key
 @return        the image
 */
- (nullable UIImage *)imageForKey:(nonnull NSString *)key;

/**
 Remove the image from memory and disk cache
 
 @param key     unique image cache key
 */
- (void)deleteImageForKey:(nonnull NSString *)key;

/**
 Get the image cache path for a given key
 
 @param key     unique image cache key
 @return        the cache path
 */
- (nonnull NSString *)imagePathForKey:(nonnull NSString *)key;


#pragma mark - Cache Clear Methods

/**
 Clear all memory cached images
 */
- (void)clearMemoryCache;

/**
 Clear all disk cached images
 */
- (void)clearDiskCache;

@end
