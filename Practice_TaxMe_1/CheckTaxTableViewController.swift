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
//--------------------------------------------------------------------------------------------------------------------------------
// Used FMDB wrapper for Database functions
// References:
// FMDB- https://github.com/ccgus/fmdb.git
// Taxrates- http://taxfoundation.org/article/state-individual-income-tax-rates-and-brackets-2015
//--------------------------------------------------------------------------------------------------------------------------------
//  CheckTaxTableViewController.swift
//	This File has development code for Check Tax table view controller. It is an independent file.
//  Created on 11/15/15.
//  Copyright © 2015 Ekta Mahajan. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------

import UIKit

class CheckTaxTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       title = "Check Tax";
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Tax.jpg")!)
        self.tableView.separatorStyle = .None
        self.tableView.separatorColor = UIColor.clearColor()
    }

	//--------------------------------------------------------------------------------------------------------------------------------
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	//--------------------------------------------------------------------------------------------------------------------------------   

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
         navigationItem.title = "Check Tax"
    
    }
    

}
//--------------------------------------------------------------------------------------------------------------------------------