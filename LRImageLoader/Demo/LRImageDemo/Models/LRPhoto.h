//
//  LRPhoto.h
//  LRImageDemo
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRPhoto : NSObject

@property (nonatomic, readonly, strong) NSString *photoID;
@property (nonatomic, readonly, strong) NSString *title;
@property (nonatomic, readonly, strong) NSString *imageUrl;
@property (nonatomic, readonly, strong) NSString *owner;

- (void)readFromJSON:(NSDictionary *)jsonDict;

@end
