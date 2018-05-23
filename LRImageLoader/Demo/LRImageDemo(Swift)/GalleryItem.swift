//
//  GalleryItem.swift
//  LRImageDemo(Swift)
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

import UIKit

class GalleryItem {
    
    let itemID: String
    let caption: String
    let owner: String
    let imageUrl: String
    
    init(itemID: String, caption: String, owner: String, imageUrl: String) {
        self.itemID = itemID
        self.caption = caption
        self.owner = owner
        self.imageUrl = imageUrl
    }
}
