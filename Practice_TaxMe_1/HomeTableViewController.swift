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
//
//  HomeTableViewController.swift
//  Practice_TaxMe_1
//
//  Created by New User on 11/15/15.
//  Copyright © 2015 Ekta Mahajan. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------------

import UIKit
import CoreLocation
import MessageUI

class HomeTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Tax.jpg")!)
        // to display the title of controller
        title = "TaxMe";
       
       self.tableView.separatorStyle = .None
       self.tableView.separatorColor = UIColor.clearColor()
    }
    
//--------------------------------------------------------------------------------------------------------------------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//--------------------------------------------------------------------------------------------------------------------------------
    // To make compose email window
	// This feature does not work while using simulator. It works well on Apple devices.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 0 && indexPath.row == 2 )
        {
            print("feedback row tapped!")
            
            let mailComposerViewController = mailComposeViewController()
            
            if MFMailComposeViewController.canSendMail()
            {
                presentViewController(mailComposerViewController, animated: true, completion: nil)
            }
            
            else
            {
                mailErrorAlert()
            }
        }
        
    }
	
//--------------------------------------------------------------------------------------------------------------------------------    
    // To send email to the developers through the App
	// This feature does not work while using simulator. It works well on Apple devices.
    func mailComposeViewController() -> MFMailComposeViewController
    
    {
      let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["agupta15@syr.edu", "ektamahajan.cse@gmail.com"])
        mailComposer.setSubject("TaxMe App Feedback")
        mailComposer.setMessageBody("Hi Team, I would like to share the following feedback!", isHTML: false)
        return mailComposer
    }
    
    //--------------------------------------------------------------------------------------------------------------------------------
    // To hand Email alert errors
	// This feature does not work while using simulator. It works well on Apple devices.
    @IBAction func mailErrorAlert() {
        let mailAlertController = UIAlertController(title: "Could not Send Email", message: "Your device could not send email. Please check e-mail configuration and try again", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        mailAlertController.addAction(defaultAction)
        
        presentViewController(mailAlertController, animated: true, completion: nil)
    }
    
	//--------------------------------------------------------------------------------------------------------------------------------
    // To send email to the developers through the App
	// This feature does not work while using simulator. It works well on Apple devices.
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    
        switch result.rawValue {
            
        case MFMailComposeResultCancelled.rawValue:
                print("Cancelled mail")
            
        case MFMailComposeResultSent.rawValue:
                print("Mail Sent")
            
        default:
            break
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//--------------------------------------------------------------------------------------------------------------------------------

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
         navigationItem.title = "Tax Me"
   
        
    }    

}
//--------------------------------------------------------------------------------------------------------------------------------