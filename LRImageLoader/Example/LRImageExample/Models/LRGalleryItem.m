//
//  LRGalleryItem.m
//  LRImageExample
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRGalleryItem.h"

@implementation LRGalleryItem

- (instancetype)initWithJSON:(NSDictionary *)jsonDict {
    self = [super init];
    if (self) {
        _itemID = jsonDict[@"id"];
        _caption = jsonDict[@"title"];
        _imageUrl = jsonDict[@"url_s"];
        _owner = jsonDict[@"owner"];
    }
    return self;
}

@end
