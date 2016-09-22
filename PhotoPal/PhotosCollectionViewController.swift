//
//  PhotosCollectionViewController.swift
//  PhotoPal
//
//  Created by David Nadri on 9/19/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit
import SimpleAuth

class PhotosCollectionViewController: UICollectionViewController {
    
    var accessToken: String?
    var likedArray = NSArray()
    let venueArray = NSMutableArray()
    var photos = [AnyObject]()
    private let reuseIdentifier = "PhotoCell"
    let screenSize = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        collectionView!.collectionViewLayout = layout
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.accessToken = userDefaults.stringForKey("accessToken")
        
        if self.accessToken == nil {
            // Get access token
            SimpleAuth.authorize("foursquare-web", completion: {
                (responseObject, error) in
                
                print("Authorizing...")
                
                if error != nil {
                    print("Error: \(error.localizedDescription)")
                    
                } else {
                    
                    
                    if let object = responseObject as? [String: AnyObject] {
                        //print("responseObject: \(object)")
                        self.accessToken = object["credentials"]?["token"] as? String
                        print("accessToken: \(self.accessToken)")
                        userDefaults.setObject(self.accessToken, forKey: "accessToken")
                        self.refreshPhotos()
                    }
                }
                
            })
            
        } else {
            // Use token
            print("Access token available: \(self.accessToken!)")
            refreshPhotos()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //NativeAPIClient: retrieve photos

    }
    
    func refreshPhotos() {
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "https://api.foursquare.com/v2/users/self/venuelikes/?oauth_token=\(self.accessToken!)&v=\(Constants.Foursquare.DATA_VERSION_DATE)&m=\(Constants.Foursquare.DATA_FORMAT)")
        print("url: \(url!)")
        let request = NSURLRequest(URL: url!)
        
        var task = session.downloadTaskWithRequest(request, completionHandler: {
            location, response, error in
 
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                
                if let data = NSData(contentsOfURL: location!) {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                        print("json: \(json)")
                        
                        self.likedArray = json.valueForKeyPath("response.venues.items.id")! as! NSArray
                        //self.venueArray = NSMutableArray()
                        for id in self.likedArray {
                            let venueURLString = "https://api.foursquare.com/v2/venues/\(id)?oauth_token=\(self.accessToken!)&v=\(Constants.Foursquare.DATA_VERSION_DATE)&m=\(Constants.Foursquare.DATA_FORMAT)"
                            let venueURL = NSURL(string: venueURLString)
                            let venueURLrequest = NSURLRequest(URL: venueURL!)
                            let venueTask = session.downloadTaskWithRequest(venueURLrequest, completionHandler: {
                                location, response, error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                } else {
                                    if let venueData = NSData(contentsOfURL: location!) {
                                        do {
                                            let venueJson = try NSJSONSerialization.JSONObjectWithData(venueData, options: [])
                                            self.venueArray.addObject(venueJson)
                                            
                                            dispatch_async(dispatch_get_main_queue()) {
                                                self.collectionView?.reloadData()
                                            }
                                            
                                        } catch let error as NSError {
                                            print("Error: \(error.localizedDescription)")
                                        }
                                    }
                                }
                            })
                            venueTask.resume()
                            
                        }
                        // store photos in the data source object
                        //self.photos = ?
                        //self.photos = myJSON.valueForKeyPath("data")! as! [AnyObject]
                        
                        // reload collection view on main thread
//                        dispatch_async(dispatch_get_main_queue()) {
//                            self.collectionView?.reloadData()
//                        }
                        
                    } catch let error as NSError {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                
            }
            
        })
        
        task.resume()

    }
    
    // - MARK: UICollectionViewDelegate
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.venueArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        
        cell.backgroundColor = UIColor.lightGrayColor()
        
        cell.photoData = self.venueArray[indexPath.row] as! NSDictionary
        
        
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("didSelectItemAtIndexPath: \(indexPath.row)")
        
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(screenSize.width/3 - 1.0, screenSize.width/3 - 1.0)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var indexPaths = (collectionView?.indexPathsForSelectedItems())! as
                [NSIndexPath]
            let destinationVC = segue.destinationViewController as! UINavigationController
            let detailVC = destinationVC.topViewController as! PhotoDetailViewController
            //detailVC.photo = photos[indexPaths[0].row] as! Media
            collectionView?.deselectItemAtIndexPath(indexPaths[0], animated:
                false)
            
        }

    }
    
//    func getIndexPathForSelectedCell() -> NSIndexPath? {
//        
//        var indexPath: NSIndexPath?
//
//        if collectionView?.indexPathsForSelectedItems()?.count > 0 {
//            indexPath = collectionView?.indexPathsForSelectedItems()?[0]
//        }
//        return indexPath
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
