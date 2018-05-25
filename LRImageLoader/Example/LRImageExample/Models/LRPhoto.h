//
//  LRPhoto.h
//  LRImageDemo
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LRPhoto : NSObject

@property (nonatomic, readonly, copy) NSString *photoID;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *imageUrl;
@property (nonatomic, readonly, copy) NSString *owner;

- (instancetype)initWithJSON:(NSDictionary *)jsonDict;

@end
