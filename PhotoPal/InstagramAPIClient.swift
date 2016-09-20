//
//  InstagramAPIClient.swift
//  PhotoPal
//
//  Created by David Nadri on 9/19/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//
import UIKit

typealias InstagramGetUserCallback = (Media) -> Void
typealias ErrorCallback = (NSError) -> Void

protocol InstagramAPIClient {
    
    static func requestMediaWithAccessToken(accessToken: String,
                             onSuccess: InstagramGetUserCallback?,
                             onError: ErrorCallback?)
    
}



