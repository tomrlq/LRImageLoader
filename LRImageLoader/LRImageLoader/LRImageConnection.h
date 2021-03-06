//
//  LRImageConnection.h
//  LRImageLoader
//
//  Created by Ruan Lingqi on 14/11/17.
//  Copyright © 2017年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LRImageStore.h"

/**
 *  Image Download Task
 */
@interface LRImageConnection : NSObject
/// connection's corresponding request
@property (nonatomic, readonly, strong) NSURLRequest *request;

/// initialize connection
+ (instancetype)connectionWithRequest:(NSURLRequest *)request;
/// start connection
- (void)startWithProgress:(LRImageProgressBlock)progressBlock
               completion:(LRImageCompletionBlock)completionBlock;
@end




/**
 *  internal data delegate
 */
@interface LRImageSessionDelegate : NSObject <NSURLSessionDataDelegate>

@end
