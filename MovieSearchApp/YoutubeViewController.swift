//
//  YoutubeViewController.swift
//  MovieSearchApp
//
//  Created by Sun&KK on 10/16/17.
//  Copyright © 2017 Washtinton University in St. Louis. All rights reserved.
//

import UIKit
import WebKit

class YoutubeViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var spaner: UIActivityIndicatorView!
    var website_url: String = "https://www.youtube.com/results?search_query="
    var movieTitle: String = ""
    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView! //A view that shows that a task is in progress.
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup processing indicator
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.isHidden = false
        activityIndicator.color = UIColor.cyan
        activityIndicator.startAnimating()
        
        
        movieTitle = movieTitle.replacingOccurrences(of: " ", with: "+")
        let url = URL(string:website_url+movieTitle)!
        let myUrlRequest = URLRequest(url: url)
        webView.load(myUrlRequest)
        webView.allowsBackForwardNavigationGestures = true
        
        
        activityIndicator.stopAnimating()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
