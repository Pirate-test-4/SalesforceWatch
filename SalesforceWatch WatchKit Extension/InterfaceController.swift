//
//  InterfaceController.swift
//  SalesforceWatch WatchKit Extension
//
//  Created by Quinton Wall on 1/6/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity  //new for watchOS2





class InterfaceController: WKInterfaceController, WCSessionDelegate {

  
    var approvalsResult: NSArray!
    //used to register the watch and paired phone
    var session : WCSession!
    

    @IBOutlet weak var pendingApprovalsButton: WKInterfaceButton!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
         print("awake with context");
        
        // Configure interface objects here.
        
        
       
    }

    override func willActivate() {

        super.willActivate()
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            self.getApprovalList()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //grab a list of pending approvals
    //use this to populate the correct approval chevrons
    private func getApprovalList() {
        
        let applicationData = ["request-type" : "approval-count"]
        
        if (WCSession.defaultSession().reachable) {
            session.sendMessage(applicationData, replyHandler: { reply in
                //handle iphone response here
                if(reply["success"] != nil) {
                    let x:String = reply["success"] as! String
                   
                    
                     let res = SalesforceObjectType.convertStringToDictionary(x)
                    
                    print(res?.count)
                    let resultsCount = String(res!.count)
                    self.approvalsResult = res!["records"] as! NSArray
                
                    //print(self.approvalsResult)

                    self.pendingApprovalsButton.setTitle(resultsCount)
                    
                    self.pendingApprovalsButton.setBackgroundImageNamed(Chevron.getChevronImage(self.approvalsResult.count) as String)
                } else {
                    //do error handling
                    print("no response")
                }
            },  errorHandler: {(error ) -> Void in
                // catch any errors here
                print("Something went wrong: \(error)")
        })
      }
        
    }
    
 
    
    //notification button has been pressed
    // lets get a list of pending approvals notifications
    @IBAction func pendingApprovalsTapped() {
    }
   
    

    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        if segueIdentifier == "showApprovals" {
            print("seque pressed!")
            return self.approvalsResult
        } else {
            return nil
        }
    }
    
    
}
