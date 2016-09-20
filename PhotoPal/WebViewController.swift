//
//  WebViewController.swift
//  PhotoPal
//
//  Created by David Nadri on 9/20/16.
//  Copyright © 2016 David Nadri. All rights reserved.
//

import UIKit
import OAuthSwift

typealias WebView = UIWebView

class WebViewController: OAuthWebViewController, UIWebViewDelegate {
    
    var targetURL : NSURL = NSURL()
    let webView : WebView = WebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        self.webView.frame = UIScreen.mainScreen().bounds
        self.webView.scalesPageToFit = true
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        loadAddressURL()
        
    }
    
    override func handle(url: NSURL) {
        targetURL = url
        super.handle(url)
        
        loadAddressURL()
    }
    
    func loadAddressURL() {
        let req = NSURLRequest(URL: targetURL)
        self.webView.loadRequest(req)
        print("loaded url: \(targetURL)...")

    }
    
    // MARK: delegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL {
            print("***shouldStartLoadWithRequest: requestURL: \(url)***")
            UIApplication.sharedApplication().
            // Call here AppDelegate.sharedInstance.applicationHandleOpenURL(url) if necessary ie. if AppDelegate not configured to handle URL scheme
            // compare the url with your own custom provided one in `authorizeWithCallbackURL`
            //self.dismissWebViewController()
        }
        return true
    }
}

