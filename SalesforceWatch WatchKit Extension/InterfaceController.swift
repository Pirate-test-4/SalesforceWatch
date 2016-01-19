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
                    let a:AnyObject = reply["results"] as! NSDictionary
                    self.approvalsResult = a as! NSArray
                
                    let resultsCount = String(self.approvalsResult.count)

                    self.pendingApprovalsButton.setTitle(resultsCount)
                    
                    self.pendingApprovalsButton.setBackgroundImageNamed(Chevron.getChevronImage(self.approvalsResult.count) as String)
                } else {
                    //do error handling
                    print("no response")
                }
            },  errorHandler: {(error ) -> Void in
                // catch any errors here
        })
      }
        
    }
    
 
    
    //notification button has been pressed
    // lets get a list of pending approvals notifications
    @IBAction func pendingApprovalsTapped() {
    }
   
    

/*
    
    private func getCurrentUserId() {
        
        //call parent iphone app
        let requestBundle = ["request-type" : "userid"]
      
        WKInterfaceController.openParentApplication(requestBundle, reply: { [unowned self](reply, error) -> Void in
            
            if let reply = reply as? [String: String] {
                self.userNameLabel.setText("Hello "+reply["username"]!)
            }
            else {
                self.userNameLabel.setText("No Response")
            }
        })
    
    }
  */
    

    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        if segueIdentifier == "showApprovals" {
            print("seque pressed!")
            return self.approvalsResult
        } else {
            return nil
        }
    }
    
}
