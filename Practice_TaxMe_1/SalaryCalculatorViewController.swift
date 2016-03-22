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
//  SalaryCalculatorViewController.swift
//
//  Created on 11/15/15.
//  Copyright © 2015 Ekta Mahajan. All rights reserved.
//
//-----------------------------------------------------------------------------------------------------------------
import UIKit


class SalaryCalculatorViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
   
     private let dbFileName = "taxRates.db"
    
    @IBOutlet weak var income: UITextField!
    
    @IBOutlet weak var deductions: UILabel!
    @IBOutlet weak var salary: UILabel!
    @IBOutlet weak var taxRateLabel: UILabel!
    @IBOutlet weak var salaryType: UISwitch!
    @IBOutlet weak var maritalStatus: UILabel!
	
	//Picker for the user to select state for his salary calculations
    @IBOutlet weak var StatePicker: UIPickerView!
    var stateName1 = ""
    var stateName = ["Alabama","Alaska","Arizona","Arkansas","California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
        "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York",       "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin","Wyoming"]
    
    
    //-----------------------------------------------------------------------------------------------------------------
    
   override func viewDidLoad() {
        super.viewDidLoad()
    self.income.delegate = self
   // self.state.delegate = self
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Tax.jpg")!)
    StatePicker.dataSource = self
    StatePicker.delegate = self
    StatePicker.setValue(UIColor.blackColor(), forKeyPath: "textColor")
    }

    //-----------------------------------------------------------------------------------------------------------------
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    //-----------------------------------------------------------------------------------------------------------------
    //switch button for marital status
    @IBAction func maritalSwitch(sender: AnyObject) {
        
        if salaryType.on
        {
            maritalStatus.text = "Married"
        }
        else
        {
            maritalStatus.text = "Single"
        }
    }
    
    //-----------------------------------------------------------------------------------------------------------------
    
    func documentsDirectory() -> String {
       let resourcePath = NSBundle.mainBundle().resourceURL!.absoluteString
        return resourcePath
    }
    
    //-----------------------------------------------------------------------------------------------------------------
 // this is the main module of this file, it takes user's salary and state and the marital status
 // creates a DB query accordingly and then fires it to the static DB that we have made using SQLite3
    @IBAction func calculateSalary(sender: AnyObject)
    
    {
        income.resignFirstResponder()
       // state.resignFirstResponder()
        
        let filemgr = NSFileManager.defaultManager()
        
        let databasePath = (documentsDirectory() as NSString).stringByAppendingPathComponent(dbFileName)
        
        print (databasePath)
        
        if !filemgr.fileExistsAtPath(databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            
             if contactDB.open() {
                
                print ("Database is open")
                
                if salaryType.on
                {
                let querySQL = "SELECT stateName , taxPercent FROM SALARYTAX WHERE (stateName = '\(stateName1)') AND ('\(income.text!)' BETWEEN lowSalFamily AND highSalFamily)"

                    let results:FMResultSet? = contactDB.executeQuery(querySQL,withArgumentsInArray: nil)
                   
                    if results?.next() == true {
                        
                        print(results?.stringForColumn("stateName"))
                        print(results?.stringForColumn("taxPercent"))
                        
                        let taxPercent = results?.stringForColumn("taxPercent")!
                        
                        let taxRates1 =  Float(income.text!)!
                        let  taxRates2 = Float(taxPercent!)!
                        let  taxRates = (taxRates1 * taxRates2)/100
                        
                        taxRateLabel.text = String(taxRates2)
                        deductions.text = String(taxRates)
                        
                      
                        let  taxRates3 = Float(deductions.text!)!
                
                        
                        let salary1 = taxRates1 - taxRates3
                        salary.text = String(salary1)
                        
                        print("Record Found")
                    }
                    
                    else {

                        print("Record not found")
                        
                        let alertController = UIAlertController(title: "Invalid Input",
                            message:"Please make sure that the salary entered is in number format and valid state name is entered.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okayButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil)
                        
                        alertController.addAction(okayButton)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                }
                
                else
                {
                   
                    let querySQL = "SELECT stateName , taxPercent FROM salaryTax WHERE (stateName = '\(stateName1)') AND ('\(income.text!)' BETWEEN lowSal AND highSal)"
                    
                    
                    let results:FMResultSet? = contactDB.executeQuery(querySQL,withArgumentsInArray: nil)
                    
                    if results?.next() == true {
                        
                        print(results?.stringForColumn("stateName"))
                        print(results?.stringForColumn("taxPercent"))
                        
                        
                        let taxPercent = results?.stringForColumn("taxPercent")!
                        
                        let taxRates1 =  Float(income.text!)!
                        let  taxRates2 = Float(taxPercent!)!
                        let  taxRates = (taxRates1 * taxRates2)/100
                        
                        taxRateLabel.text = String(taxRates2)
                        deductions.text = String(taxRates)
                        
                        
                        let  taxRates3 = Float(deductions.text!)!
                        
                        
                        let salary1 = taxRates1 - taxRates3
                        salary.text = String(salary1)
                        
                        print("Record Found")
                    }
                        
                    else {
                        
                        print("Record not found")
                        let alertController = UIAlertController(title: "Invalid Input",
                            message:"Please make sure that the salary entered is in number format and valid state name is entered.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        let okayButton = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil)
                        
                        alertController.addAction(okayButton)
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                    
                }
                
                
            contactDB.close()
                print ("Database is closed")
                
             }
             
             else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
        
    }
    
    //-----------------------------------------------------------------------------------------------------------------
    //reset button clears all the text boxes
    @IBAction func reset(sender: AnyObject) {
        
        income.text?.removeAll()      
        deductions.text?.removeAll()
        salary.text?.removeAll()
        taxRateLabel.text?.removeAll()
        salaryType.setOn(true, animated: true)
		if salaryType.on
        {
            maritalStatus.text = "Married"
        }
        else
        {
            maritalStatus.text = "Single"
        }
        
    }

    //-----------------------------------------------------------------------------------------------------------------
    // for configuring the pickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateName.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stateName[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateName1 = stateName[row]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-----------------------------------------------------------------------------------------------------------------
    
    @IBAction func backgroundActivated(sender :AnyObject) {
        view.endEditing(true)
    }
    
    //-----------------------------------------------------------------------------------------------------------------
    //clicking on return key should make the keyboard disappear
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        income.resignFirstResponder()
      //  state.resignFirstResponder()
        return true;
    }

    

}
//-----------------------------------------------------------------------------------------------------------------