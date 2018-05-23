//
//  PhotoGalleryViewController.swift
//  LRImageDemo(Swift)
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

import UIKit

class PhotoGalleryViewController: UICollectionViewController,
UICollectionViewDelegateFlowLayout {
    
    private var currentItems = [GalleryItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        GalleryStore.shared.fetchRecentPhotos { (galleryResult) in
            switch galleryResult {
            case let .success(galleryItems):
                self.currentItems = galleryItems
                self.collectionView?.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }

    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let galleryItem = currentItems[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryItemCell", for: indexPath) as! GalleryItemCell
        cell.setGalleryItem(galleryItem)
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth / 3.0, height: 120)
    }
}
