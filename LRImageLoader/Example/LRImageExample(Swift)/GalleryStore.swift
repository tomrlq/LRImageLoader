//
//  GalleryStore.swift
//  LRImageExample(Swift)
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

enum FlickrError: Error {
    case invalidJSONData
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
                let result = self.parseItemsFrom(jsonData: data!)
                DispatchQueue.main.async {
                    completion(result)
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
    
    private func parseItemsFrom(jsonData: Data) -> GalleryResult {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            guard
                let jsonBody = json as? [String: Any],
                let jsonObject = jsonBody["photos"] as? [String: Any],
                let jsonArray = jsonObject["photo"] as? [[String: Any]] else {
                    return .failure(FlickrError.invalidJSONData)
            }
            
            var items = [GalleryItem]()
            for jsonDict in jsonArray {
                if let item = parseItemFrom(jsonDict: jsonDict) {
                    items.append(item)
                }
            }
            return .success(items)
        } catch let error {
            return .failure(error)
        }
    }
    
    private func parseItemFrom(jsonDict: [String: Any]) -> GalleryItem? {
        guard
            let itemID = jsonDict["id"] as? String,
            let caption = jsonDict["title"] as? String,
            let owner = jsonDict["owner"] as? String,
            let imageUrl = jsonDict["url_s"] as? String else {
                return nil
        }
        return GalleryItem(itemID: itemID, caption: caption, owner: owner, imageUrl: imageUrl)
    }
}
