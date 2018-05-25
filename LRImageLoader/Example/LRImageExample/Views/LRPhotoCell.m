//
//  LRPhotoCell.m
//  LRImageDemo
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRPhotoCell.h"
#import "LRPhoto.h"
#import <LRImageLoader/LRImageLoader.h>

@interface LRPhotoCell ()
{
    __weak IBOutlet UIImageView *imageView;
}
@end

@implementation LRPhotoCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    imageView.image = nil;
}

- (void)setPhoto:(LRPhoto *)photo {
    [[LRImageStore sharedStore] loadImage:photo.imageUrl
                              placeholder:[UIImage imageNamed:@"placeholder"]
                                     into:imageView];
}

@end
