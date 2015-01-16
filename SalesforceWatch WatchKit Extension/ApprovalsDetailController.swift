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
    
    
    @IBAction func rejectTapped() {
    }
    
    @IBAction func approveTapped() {
    }
    
    override func awakeWithContext(context: AnyObject?) {
        precondition(context is Dictionary<String, String> , "Expected class of `context` to be dictionary containing record and targetobjectid.")
        
        //let (recordid, targetobjectid) = context as (String, String)
        let record = context as Dictionary<String, String>
        println(record["recordid"])
        let id: NSString = record["targetobjectid"]!
        //println(recordid)
        
        //let requestBundle = ["request-type" : "approval-details", "id" : id]
        let requestBundle = ["request-type" : "approval-details"]
        
        WKInterfaceController.openParentApplication(requestBundle, reply: { [unowned self](reply, error) -> Void in
            
            if let reply = reply as? [String: NSArray] {
                 let results = reply["results"]
                
                //self.optyName.setText(results["name"])
                //self.accountName.setText(results["accountname"])
               // self.optyAmount.setText(results["amount"])
                
                
                
                //   self.userNameLabel.setText("Hello "+reply["username"]!)
                
                // for (key, val) in reply {
                //   println("parent app reponse is \(key): \(val)")
                //}
            }
            else {
                // self.userNameLabel.setText("No Response")
                println("no response")
                
            }
        })

        
        
    }
}
