//
//  WebViewController.swift
//  ofo
//
//  Created by 吴灶洲 on 2017/7/4.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "热门活动"
        let url = URL.init(string: "http://m.ofo.so/active.html")
        let request = URLRequest.init(url: url!)
//        webView.loadRequest(request);
        webView.frame = view.bounds
        view.addSubview(webView)
        webView.load(request)
        
        
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
