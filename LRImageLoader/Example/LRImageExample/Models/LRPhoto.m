//
//  LRPhoto.m
//  LRImageExample
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRPhoto.h"

@implementation LRPhoto

- (instancetype)initWithJSON:(NSDictionary *)jsonDict {
    self = [super init];
    if (self) {
        _photoID = jsonDict[@"id"];
        _title = jsonDict[@"title"];
        _imageUrl = jsonDict[@"url_s"];
        _owner = jsonDict[@"owner"];
    }
    return self;
}

@end
