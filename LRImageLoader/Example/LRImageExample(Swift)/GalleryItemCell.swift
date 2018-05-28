//
//  GalleryItemCell.swift
//  LRImageExample(Swift)
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

import UIKit
import LRImageLoader

class GalleryItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setGalleryItem(_ item: GalleryItem) {
        LRImageStore.shared().loadImage(item.imageUrl,
                                        placeholder: #imageLiteral(resourceName: "placeholder"),
                                        into: imageView)
    }
}
