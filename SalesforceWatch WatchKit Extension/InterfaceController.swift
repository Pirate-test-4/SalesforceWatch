//
//  InterfaceController.swift
//  SalesforceWatch WatchKit Extension
//
//  Created by Quinton Wall on 1/6/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import WatchKit
import Foundation



class InterfaceController: WKInterfaceController {

  
    var approvalsResult: NSArray!
    

    @IBOutlet weak var pendingApprovalsButton: WKInterfaceButton!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
         println("awake with context");
        
        // Configure interface objects here.
        
        
       
    }

    override func willActivate() {

        super.willActivate()
        self.getApprovalList()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //grab a list of pending approvals
    //use this to populate the correct approval chevrons
    private func getApprovalList() {
        let requestBundle = ["request-type" : "approval-count"]
        
        WKInterfaceController.openParentApplication(requestBundle, reply: { [unowned self](reply, error) -> Void in
           
            if let reply = reply as? [String: NSArray] {
                self.approvalsResult = reply["results"]
                var resultsCount = String(self.approvalsResult.count)
                self.pendingApprovalsButton.setTitle(resultsCount)
                //max out at 360...but anyone with that many approvals should be fired
                //self.pendingApprovalsButton.setBackgroundImageNamed("glance-"+resultsCount)
                self.pendingApprovalsButton.setBackgroundImageNamed(Chevron.getChevronImage(self.approvalsResult.count))
               
                
        }
            else {
               // self.userNameLabel.setText("No Response")
               println("no response")
               
            }
        })

        
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
            println("seque pressed!")
            return self.approvalsResult
        } else {
            return nil
        }
    }
    
}
