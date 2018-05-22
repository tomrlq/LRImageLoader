//
//  LRPhoto.m
//  LRImageDemo
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRPhoto.h"

@implementation LRPhoto
@synthesize photoID, title, imageUrl, owner;

- (void)readFromJSON:(NSDictionary *)jsonDict {
    photoID = jsonDict[@"id"];
    title = jsonDict[@"title"];
    imageUrl = jsonDict[@"url_s"];
    owner = jsonDict[@"owner"];
}

@end
