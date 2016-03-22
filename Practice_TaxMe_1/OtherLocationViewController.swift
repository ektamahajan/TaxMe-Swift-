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
//  OtherLocationViewController.swift
//
//  Created on 11/15/15.
//  Copyright © 2015 Ekta Mahajan. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------

import UIKit

class OtherLocationViewController: UIViewController, NSXMLParserDelegate, UITextFieldDelegate {

    var checkXmlError:Bool=false
    var checkXmlZipcode:Bool=false
    var checkXmlState:Bool=false
    var checkXmlTaxRate:Bool=false
    var result = ""
    
    
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var salesTax: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var useTax: UILabel!
    
    var parser = NSXMLParser()
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Tax.jpg")!)
          self.zipCode.delegate = self
        
    }
    //--------------------------------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    // to calculate tax as per the user input
    @IBAction func checkTax(sender: UIButton) {
        
        let zip1 = zipCode.text
        let zipInt = Int(zipCode.text!)
        
        if(zipInt < 01001 || zipInt > 99929){
            let alertController = UIAlertController(title: "Invalid Location",
                message:"Please make sure that you have entered a valid pincode. Pincode should belong to USA.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okayButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil)
            
            alertController.addAction(okayButton)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            checkXmlError=false;
            
        }
        // Calling the API with requested zipcode
        let url:String="https://api.ax.com/TaxRate-USA.xml?zip=\(zip1!)&username=username&password=password"
        
        let urlToSend: NSURL = (NSURL(string: url))!
        
        do
        {
            let teststrinf = try NSString(contentsOfURL: urlToSend, encoding: NSUTF8StringEncoding)
            let newString = teststrinf.stringByReplacingOccurrencesOfString("utf-16", withString: "utf-8")
            let data = newString.dataUsingEncoding(NSUTF8StringEncoding)
            let parser = NSXMLParser(data: data!)
            parser.delegate = self
            
            let success:Bool = parser.parse()
            
            if success {
                print("parse success!")
                
                
            } else {
                print("parse failure!")
            }
        }
            
        catch
        {
            print(error)
        }

    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    // clicking reset button clears all the fields
    @IBAction func reset(sender: AnyObject) {
        
        zipCode.text?.removeAll()
        salesTax.text?.removeAll()
        useTax.text?.removeAll()
        stateLabel.text?.removeAll()
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    //TO parse through the XML provided by the API as the output
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        
        if(elementName=="errorMessage" )
        {
            checkXmlError=true;
        }
        
        
        if(elementName=="zipCode" )
        {
            checkXmlZipcode=true;
        }
        if(elementName=="state" )
        {
            checkXmlState=true;
        }
        
        if(elementName == "taxRate")
        {
            checkXmlTaxRate=true;
        }
        
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    //TO parse through the XML provided by the API as the output
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
        if(checkXmlError)
        {
           // print(string)
            
                    }
        
        if(checkXmlZipcode){
            
            //print(string)
        }
        if(checkXmlState){
            
            //print(string)
            stateLabel.text = "\(string)"
        }
        if(checkXmlTaxRate){
            
            result = result + " " + string
            
        }
        
        let characters1 = result.componentsSeparatedByString(" ")
        let char2 = [String](characters1)
         if((char2.capacity >= 7) && (!zipCode.text!.isEmpty))
        {
            salesTax.text = "\(char2[1])"
            useTax.text = "\(char2[6])"
            return
        }
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    //TO parse through the XML provided by the API as the output
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        if(elementName=="errorMessage" )
        {
            checkXmlError=false;
        }
        
        if(elementName=="zipCode" )
        {
            checkXmlZipcode=false;
        }
        if(elementName=="state" )
        {
            checkXmlState=false;
        }
        
        if(elementName=="taxRate")
        {
            checkXmlTaxRate=false;
        }
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
      

    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        zipCode.resignFirstResponder()
        return true;
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func backgroundActivated(sender :AnyObject) {
        view.endEditing(true)
    }

    //--------------------------------------------------------------------------------------------------------------------------
}


//------------------------------------------------------------------------------------------------------------------------------