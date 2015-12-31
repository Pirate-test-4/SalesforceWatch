//
//  ApprovalsDetailController.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 1/15/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit

class ApprovalsDetailController: WKInterfaceController {
    
    @IBOutlet weak var optyName: WKInterfaceLabel!
    @IBOutlet weak var accountName: WKInterfaceLabel!
    @IBOutlet weak var optyAmount: WKInterfaceLabel!
    @IBOutlet weak var approveButton: WKInterfaceButton!
    @IBOutlet weak var rejectButton: WKInterfaceButton!
    var id: String!
    
    
    @IBAction func approveTapped() {
        print("Approving record: "+id)
        
        
        let requestBundle = ["request-type" : "approval-update", "id" : id]
        
        WKInterfaceController.openParentApplication(requestBundle, reply: { [unowned self](reply, error) -> Void in
            //back
        })

        //self.popController()  //for push
       self.dismissController()  //for modal
        //self.popToRootController()
    }
    
    @IBAction func rejectTapped() {
        print("Rejecting record: "+id)
        
        let requestBundle = ["request-type" : "approval-reject", "id" : id]
        
        WKInterfaceController.openParentApplication(requestBundle, reply: { [unowned self](reply, error) -> Void in
            //back
            })
         self.dismissController()  //for modal
    }
    
    override func awakeWithContext(context: AnyObject?) {
        precondition(context is Dictionary<String, String> , "Expected class of `context` to be dictionary containing record and targetobjectid.")
        
        //let (recordid, targetobjectid) = context as (String, String)
        let record = context as! Dictionary<String, String>
        print(record["recordid"])
        self.id = record["recordid"]
        let id: NSString = record["targetobjectid"]!
        //println(recordid)
        
        let requestBundle = ["request-type" : "approval-details", "id" : id]
        //let requestBundle = ["request-type" : "approval-details"]
        
        WKInterfaceController.openParentApplication(requestBundle, reply: { [unowned self](reply, error) -> Void in
            
            if let reply = reply as? [String: NSArray] {
                 let results = reply["results"]
                if let results = results as? [NSDictionary] {
                    let results = results[0]
                
                    self.optyName.setText(results["Name"] as? String)
                    
                    
                    //get the nested account name
                    //self.accountName.setText(results["Account"]?["Name"]? as? String)
                    
                   
                    let amt: AnyObject? = results["Amount"] 
                    if let amt = amt as? NSNumber {
                        print(amt)
                        self.optyAmount.setText("$"+amt.stringValue)
                    }
                 //self.optyAmount.setText(amt)
                
                
                
                //   self.userNameLabel.setText("Hello "+reply["username"]!)
                
                //for (key, val) in results {
               //    println("parent app reponse is \(key): \(val)")
              //  }
            }
            else {
                // self.userNameLabel.setText("No Response")
                print("no response")
                
            }
            }
        })

        
        
    }
}
