//
//  LRPhotoStore.h
//  LRImageDemo
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRPhotoStore : NSObject

+ (LRPhotoStore *)sharedStore;

- (void)fetchRecentPhotosWithCompletion:(void (^)(NSArray *photos, NSError *error))completion;

@end
