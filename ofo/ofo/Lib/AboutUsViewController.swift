//
//  AboutUsViewController.swift
//  ofo
//
//  Created by 吴灶洲 on 2017/7/6.
//  Copyright © 2017年 吴灶洲. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let revealVC = revealViewController() {
            revealVC.rearViewRevealWidth = 251
            navigationItem.leftBarButtonItem?.target = self
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:) )
            view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
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
