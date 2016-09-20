//
//  NativeAPIClient.swift
//  PhotoPal
//
//  Created by David Nadri on 9/19/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit

class NativeAPIClient: InstagramAPIClient {
    
    static func requestMediaWithAccessToken(accessToken: String,
                             onSuccess: InstagramGetUserCallback? = nil,
                             onError: ErrorCallback? = nil) {
        let urlString = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)"
        let url = NSURL(string: urlString)!
        
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let dataTask = defaultSession.dataTaskWithURL(url) { data, response, error in
            if let error = error {
                onError?(error)
            } else if let data = data {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                    print("json: \(json)")
                    
                } catch let error as NSError {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
}
