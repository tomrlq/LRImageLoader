//
//  LRGalleryItem.h
//  LRImageExample
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRGalleryItem : NSObject

@property (nonatomic, readonly, copy) NSString *itemID;
@property (nonatomic, readonly, copy) NSString *caption;
@property (nonatomic, readonly, copy) NSString *imageUrl;
@property (nonatomic, readonly, copy) NSString *owner;

- (instancetype)initWithJSON:(NSDictionary *)jsonDict;

@end
