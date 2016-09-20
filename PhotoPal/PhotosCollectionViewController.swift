//
//  PhotosCollectionViewController.swift
//  PhotoPal
//
//  Created by David Nadri on 9/19/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit
import OAuthSwift

class PhotosCollectionViewController: UICollectionViewController {

    var photos = [Media?]()
    
    private let reuseIdentifier = "PhotoCell"
    let screenSize = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        collectionView!.collectionViewLayout = layout
        
        runOauth()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //NativeAPIClient: retrieve photos
    }
    
    func runOauth() {
        let oauth = OAuth2Swift(
            consumerKey:    Constants.consumerKey,
            consumerSecret: Constants.consumerSecret,
            authorizeUrl:   "https://api.instagram.com/oauth/authorize",
            responseType:   "token"
            // or
            // accessTokenUrl: "https://api.instagram.com/oauth/access_token",
            // responseType:   "code"
        )
        
        oauth.authorize_url_handler = WebViewController()
        print("authorized_url_handler...")
        oauth.authorizeWithCallbackURL(
            NSURL(string: "https://instagram.com/")!,
            scope: "",
            state: "INSTAGRAM",
            success: { credential, response, paramaters in
                print("token: \(credential.oauth_token)")
            },
            failure: { error in
                print("OAuth2 Error: \(error.localizedDescription)")
            }
        )
    }
    
    // - MARK: UICollectionViewDelegate
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        
        //cell.photoImageView.image = ?
        
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
        let destinationVC = segue.destinationViewController as! PhotoDetailViewController
        if let indexPath = getIndexPathForSelectedCell() {
            destinationVC.photo = photos[indexPath.row]
        }
    }
    
    func getIndexPathForSelectedCell() -> NSIndexPath? {
        
        var indexPath: NSIndexPath?

        if collectionView?.indexPathsForSelectedItems()?.count > 0 {
            indexPath = collectionView?.indexPathsForSelectedItems()?[0]
        }
        return indexPath
    }
    
}
