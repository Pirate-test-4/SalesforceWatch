//
//  ApprovalsDetailController.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 1/15/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class ApprovalsDetailController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var optyName: WKInterfaceLabel!
    @IBOutlet weak var accountName: WKInterfaceLabel!
    @IBOutlet weak var optyAmount: WKInterfaceLabel!
    @IBOutlet weak var approveButton: WKInterfaceButton!
    @IBOutlet weak var rejectButton: WKInterfaceButton!
    var id: String!
    
    //used to register the watch and paired phone
    var session : WCSession!


    
    @IBAction func approveTapped() {
        print("Approving record: "+id)
        
        let requestBundle = ["request-type" : "approval-update", "id" : id]
        
        if (WCSession.defaultSession().reachable) {
            session.sendMessage(requestBundle, replyHandler: { reply in
                self.dismissController()
            },
            errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
    }
    
    @IBAction func rejectTapped() {
        print("Rejecting record: "+id)
        
        let requestBundle = ["request-type" : "approval-reject", "id" : id]
        
        if (WCSession.defaultSession().reachable) {
            session.sendMessage(requestBundle, replyHandler: { reply in
                self.dismissController()
                },
                errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
    
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
        
        if (WCSession.defaultSession().reachable) {
            session.sendMessage(requestBundle, replyHandler: { reply in
                if(reply["success"] != nil) {
                   let a:AnyObject = reply["results"] as! NSDictionary
                    if let results = a as? [NSDictionary] {
                        let results = results[0]
                        self.optyName.setText(results["Name"] as? String)
                        
                        let amt: AnyObject? = results["Amount"]
                        if let amt = amt as? NSNumber {
                            print(amt)
                            self.optyAmount.setText("$"+amt.stringValue)
                        }
                    }
                } else {
                    print("no response")
                }},
                errorHandler: {(error ) -> Void in
                    // catch any errors here
            })
        }
    }
}
