//                                     TaxME
//                              ===================
//
//  iOS Application for all the Apple devices that provides following features:
//      a) Display Use Tax and Sales Tax for either your current location or for any other zipcode
//      b) Calculate your in hand salary based on parameters like- marital status, state, etc.
//      c) Notify user if the current location changes along with the changes in the taxes
//      d) Allows user to send feedback to the developers via email directly from the app
//
// Programming langauge Swift 2.0
// Platform Macbook Pro
// Tool Xcode 7.1.1
//
//  AboutUs.swift
//  TaxMe
//
//  Created by New User on 12/5/15.
//  Copyright © 2015 Ekta Mahajan. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Tax.jpg")!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
