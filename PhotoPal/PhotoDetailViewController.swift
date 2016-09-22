//
//  PhotoDetailViewController.swift
//  PhotoPal
//
//  Created by David Nadri on 9/19/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var photoDetailImageView: UIImageView!
    
    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoDetailImageView.image = photo
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
