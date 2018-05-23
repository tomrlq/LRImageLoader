//
//  GalleryStore.swift
//  LRImageDemo(Swift)
//
//  Created by Ruan Lingqi on 23/05/18.
//  Copyright © 2018年 tomrlq. All rights reserved.
//

import UIKit

fileprivate let EndPoint = "https://api.flickr.com/services/rest"
fileprivate let APIKey = "a6d819499131071f158fd740860a5a88"
fileprivate let FetchRecentsMethod = "flickr.photos.getRecent"

enum GalleryResult {
    case success([GalleryItem])
    case failure(Error)
}

class GalleryStore {
    
    static let shared = GalleryStore()
    
    private var recentItems = [GalleryItem]()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    
    // MARK: - Networking
    
    func fetchRecentPhotos(completion: @escaping (GalleryResult) -> Void) {
        if recentItems.count > 0 {
            DispatchQueue.main.async {
                completion(.success(self.recentItems))
            }
            return
        }
        let url = recentPhotoURL()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let errorMessage = error {
                DispatchQueue.main.async {
                    completion(.failure(errorMessage))
                }
            } else {
                self.parseItems(&self.recentItems, jsonData: data!)
                DispatchQueue.main.async {
                    completion(.success(self.recentItems))
                }   
            }
        }
        task.resume()
    }
    
    
    // MARK: - URL Serialization
    
    private func recentPhotoURL() -> URL {
        return flickrURL(method: FetchRecentsMethod, params: nil)
    }
    
    private func flickrURL(method: String, params: [String: String]?) -> URL {
        var components = URLComponents(string: EndPoint)!
        var queryItems = [URLQueryItem]()
        let baseParams = [
            "api_key": APIKey,
            "format": "json",
            "nojsoncallback": "1",
            "extras": "url_s",
            "method": FetchRecentsMethod
        ]
        for (key, object) in baseParams {
            let item = URLQueryItem(name: key, value: object)
            queryItems.append(item)
        }
        if let moreParams = params {
            for (key, object) in moreParams {
                let item = URLQueryItem(name: key, value: object)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    // MARK: - Parse JSON Results
    
    private func parseItems(_ items: inout [GalleryItem], jsonData: Data) {
        items.removeAll()
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String : Any]
            let jsonObject = json["photos"] as! [String : Any]
            let jsonArray = jsonObject["photo"] as! [[String : Any]]
            for jsonDict in jsonArray {
                if let item = parseItemFrom(json: jsonDict) {
                    items.append(item)
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    private func parseItemFrom(json: [String : Any]) -> GalleryItem? {
        guard
            let itemID = json["id"] as? String,
            let caption = json["title"] as? String,
            let owner = json["owner"] as? String,
            let imageUrl = json["url_s"] as? String else {
                return nil
        }
        return GalleryItem(itemID: itemID, caption: caption, owner: owner, imageUrl: imageUrl)
    }
}
