//
//  LRGalleryItemCell.m
//  LRImageExample
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRGalleryItemCell.h"
#import "LRGalleryItem.h"
#import <LRImageLoader/LRImageLoader.h>

@interface LRGalleryItemCell ()
{
    __weak IBOutlet UIImageView *imageView;
}
@end

@implementation LRGalleryItemCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    imageView.image = nil;
}

- (void)setGalleryItem:(LRGalleryItem *)galleryItem {
    [[LRImageStore sharedStore] loadImage:galleryItem.imageUrl
                              placeholder:[UIImage imageNamed:@"placeholder"]
                                     into:imageView];
}

@end
