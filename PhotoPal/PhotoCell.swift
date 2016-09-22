//
//  PhotoCell.swift
//  PhotoPal
//
//  Created by David Nadri on 9/19/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
 
    var photoData: NSDictionary? {
        didSet {
            let size = "100x100"
            let urlString = String(format: "%@%@%@", (self.photoData!.valueForKeyPath("response.venue.bestPhoto.prefix")! as? String)!, size, (self.photoData!.valueForKeyPath("response.venue.bestPhoto.suffix")! as? String)!)
            
            self.downloadPhotoWithURL(urlString)
        }
    }
    
    func downloadPhotoWithURL(urlString: String) {
        print("photoURL: \(urlString)")
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: url!)
        
        var task = session.downloadTaskWithRequest(request, completionHandler: {
            location, response, error in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                let data = NSData(contentsOfURL: location!)
                let image = UIImage(data: data!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.photoImageView.image = image
                }
                
            }
        })
        task.resume()
        
    }
    
}
