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
//  TaxDetailTableViewController.swift
//  Created on 11/15/15.
//  Copyright © 2015 Ekta Mahajan & Aman Gupta. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------

import UIKit

class TaxDetailsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tax Details";
    }

	//--------------------------------------------------------------------------------------------------------------------------------
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
	//--------------------------------------------------------------------------------------------------------------------------------

   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    navigationItem.title = "Tax Details"
   
 
    }

}
