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
//  CurrentLocationViewController.swift
//
//  Created on 11/15/15.
//  Copyright © 2015 Ekta Mahajan. All rights reserved.
//
//--------------------------------------------------------------------------------------------------------------------------

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController , CLLocationManagerDelegate, NSXMLParserDelegate {
    
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var salesTax: UILabel!
    @IBOutlet weak var useTax: UILabel!
	
    let locationManager = CLLocationManager()    
    private let dbFileName = "locationChangeAlert.db"
	
    var checkXmlError:Bool=false
    var checkXmlZipcode:Bool=false
    var checkXmlState:Bool=false
    var checkXmlTaxRate:Bool=false
    var checkXmlPlace:Bool=false
    var result = ""
    var currentPlace = ""
    var parser = NSXMLParser()
    var previousCityName = ""
    var previousUseTax = ""
    var previousSalesTax = ""
   //--------------------------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Tax.jpg")!)
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
              
		// retrieve previously/default values for previousCityName and its taxes	  
        let defaults = NSUserDefaults.standardUserDefaults()        
        previousCityName = defaults.stringForKey("PreviousCity")!
        previousUseTax = defaults.stringForKey("PreviousUseTax")!
        previousSalesTax = defaults.stringForKey("PreviousSalesTax")!
        
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    func documentsDirectory() -> String {
        let resourcePath = NSBundle.mainBundle().resourceURL!.absoluteString
        return resourcePath
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    //Getting complete address using the current location's coordinates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
	
	
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler:
            {
                (placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                if placemarks!.count > 0 {
                    
                    self.displayLocationInfo(placemarks![0] as CLPlacemark)
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            }
        )
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
	//Displays the complete address retrieved from the coordinates to the UI
    func displayLocationInfo(placemark: CLPlacemark) {
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
       
        
        if(placemark.country != "United States"){
            
            //currentLocation.text?.removeAll()
            let alertController1 = UIAlertController(title: "Invalid Location",
                message:"Either your current location or the location defined by you is outside USA and hence we can not brief you about its Tax Information.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okayButton1 = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil)
            alertController1.addAction(okayButton1)
            self.presentViewController(alertController1, animated: true, completion: nil)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject( "NA", forKey: "PreviousUseTax")
            defaults.setObject( "NA", forKey: "PreviousSalesTax")
            defaults.synchronize()
            //return
        }
            
        else if (placemark.country == "United States")
        {
        currentLocation.text = "\(placemark.name!), \(placemark.locality!) , \(placemark.postalCode!), \(placemark.administrativeArea!), \(placemark.country! )"
        if(placemark.locality != previousCityName){
            let alertController = UIAlertController(title: "Location Alert",
                message:"You have moved from \(previousCityName) to \(placemark.locality!). \n \(previousCityName)'s Use Tax was \(previousUseTax) \n \(previousCityName)'s Sales Tax was \(previousSalesTax)", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okayButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil)            
            alertController.addAction(okayButton)            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let newCity = "\(placemark.locality!)"
            defaults.setObject(newCity, forKey: "PreviousCity")
            defaults.synchronize()
        }
        
     
        
        
        let zip1 = placemark.postalCode!
            //Making a call to the zip2tax API by passing the desired zipcode as the input
        let url:String="https://api.tax.com/TaxRate-USA.xml?zip=\(zip1)&username=username&password=password"        
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
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    // to make sure user authorises to share his current location
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    locationManager.startUpdatingLocation()
                }
            }
        }
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            // Find the current location
            locationManager.startMonitoringSignificantLocationChanges()
            //rest of code...
            
        }
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
        
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    //Parse through the XML provided by the API as a result
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
        
        if(elementName=="place" )
        {
            checkXmlState=true;
        }        
        if(elementName == "taxRate")
        {
            checkXmlTaxRate=true;
        }
        
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    //Parse through the XML provided by the API as a result
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        
      if(checkXmlError)
        {
		// If there is an error while parsing the XML because of invalid zipcode, Alert would be thrown!
           // print(string)
          
        }
        
        if(checkXmlZipcode){
            
            //print(string)
        }
        if(checkXmlState){
            
            //print(string)
            
        }
        
        if(checkXmlPlace){
            
            //print(string)
            currentPlace = string
            
        }
        
        if(checkXmlTaxRate){
            
            result = result + " " + string
        }
        
        let characters1 = result.componentsSeparatedByString(" ")
        let char2 = [String](characters1)
        if(char2.capacity == 7)
        {
            //handle case when zipcode was not corrct
            salesTax.text = "\(char2[1])"
            useTax.text = "\(char2[6])"
            let defaults = NSUserDefaults.standardUserDefaults()
          
            defaults.setObject( (char2[6]), forKey: "PreviousUseTax")
            defaults.setObject( (char2[1]), forKey: "PreviousSalesTax")
            defaults.synchronize()
            return
        }
        
        
    }
    
    //--------------------------------------------------------------------------------------------------------------------------
    //Post parsing, setting tha parameters to false again as by default
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
        
        if(elementName=="place" )
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
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//--------------------------------------------------------------------------------------------------------------------------------

