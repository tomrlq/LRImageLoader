//
//  LRPhotosViewController.m
//  LRImageDemo
//
//  Created by Ruan Lingqi on 22/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

#import "LRPhotosViewController.h"
#import "LRPhotoCell.h"
#import "LRPhotoStore.h"
#import "LRPhoto.h"

@interface LRPhotosViewController () <UICollectionViewDelegateFlowLayout>
{
    NSArray *currentPhotos;
}
@end

@implementation LRPhotosViewController

#pragma mark - UICollectionViewController Overrides

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self = [super initWithCollectionViewLayout:flowLayout];
    if (self) {
        currentPhotos = nil;
    }
    return self;
}

- (instancetype)init {
    return [self initWithCollectionViewLayout:[UICollectionViewLayout new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LRPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"LRPhotoCell"];
    [[LRPhotoStore sharedStore] fetchRecentPhotosWithCompletion:^(NSArray *photos, NSError *error) {
        if (!error) {
            currentPhotos = photos;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return currentPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LRPhoto *photo = currentPhotos[indexPath.item];
    LRPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LRPhotoCell" forIndexPath:indexPath];
    [cell setPhoto:photo];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    return CGSizeMake(screenWidth / 3.0, 120);
}

@end
