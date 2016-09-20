//
//  Media.swift
//  PhotoPal
//
//  Created by David Nadri on 9/19/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit

class Media {
    
    var type: String?
    var user: NSDictionary?
    var createdTime: String?
    var images: NSDictionary?
    var location: NSDictionary?
    var caption: NSDictionary?
    
    init(type: String?, user: NSDictionary?, createdTime: String?, images: NSDictionary?, location: NSDictionary?, caption: NSDictionary?) {
        self.type = type
        self.user = user
        self.createdTime = createdTime
        self.images = images
        self.location = location
        self.caption = caption
    }
    
}

