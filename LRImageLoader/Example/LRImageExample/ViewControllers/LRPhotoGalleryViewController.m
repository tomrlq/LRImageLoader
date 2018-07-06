//
//  LRPhotoGalleryViewController.m
//  LRImageExample
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRPhotoGalleryViewController.h"
#import "LRGalleryItemCell.h"
#import "LRGalleryStore.h"
#import "LRGalleryItem.h"

@interface LRPhotoGalleryViewController () <UICollectionViewDelegateFlowLayout>
{
    NSArray *currentItems;
}
@end

@implementation LRPhotoGalleryViewController

#pragma mark - UICollectionViewController Overrides

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        currentItems = nil;
    }
    return self;
}

- (instancetype)init {
    return [self initWithCollectionViewLayout:[UICollectionViewLayout new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"LRImageLoader Example";
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LRGalleryItemCell" bundle:nil] forCellWithReuseIdentifier:@"LRGalleryItemCell"];
    [[LRGalleryStore sharedStore] fetchRecentPhotosWithCompletion:^(NSArray *galleryItems, NSError *error) {
        if (!error) {
            currentItems = galleryItems;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return currentItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LRGalleryItem *galleryItem = currentItems[indexPath.item];
    LRGalleryItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LRGalleryItemCell" forIndexPath:indexPath];
    [cell setGalleryItem:galleryItem];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    return CGSizeMake(screenWidth / 3.0, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

@end
