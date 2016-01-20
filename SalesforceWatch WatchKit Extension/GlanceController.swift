//
//  GlanceController.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 3/4/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity  //new for watchOS2


class GlanceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var headerImage: WKInterfaceImage!
    @IBOutlet weak var counterRing: WKInterfaceImage!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    
    //used to register the watch and paired phone
    var session : WCSession!
    
    var approvalsResult: NSArray!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        print("awake with context");
        
        // Configure interface objects here.
        counterRing.setImageNamed("glance-")
        
    
        
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
        
        
        let applicationData = ["request-type":"approval-count"]
        
        
        if (WCSession.defaultSession().reachable) {
            session.sendMessage(applicationData, replyHandler: { reply in
                //handle iphone response here
                if(reply["success"] != nil) {
                    
                    
                    let x:String = reply["success"] as! String
                    
                    
                    let res = SalesforceObjectType.convertStringToDictionary(x)
                    
                    print(res?.count)
                    self.approvalsResult = res!["records"] as! NSArray
                    
                    //print(self.approvalsResult)
                    

                     _ = String(self.approvalsResult.count)
                  
                    
                    var approvedCount = 0
                    var pendingCount = 0
                    let rejectedCount = 0
                    
                    for (_, record) in self.approvalsResult.enumerate() {
                        
                        let s: NSDictionary = record as! NSDictionary
                        
                        let str:String = s["Status"] as! String
                        switch str {
                            case "Approved":
                                approvedCount++
                            case "Pending":
                                pendingCount++
                            case "Rejected":
                                pendingCount++
                            default:
                                print("Missed a status:"+str)
                        }
                
                }
                    
                    self.titleLabel.setText(String(approvedCount)+"/"+String(pendingCount)+"/"+String(rejectedCount))
                    
                    var cnt = self.approvalsResult.count as Int
                    cnt = cnt * 10  //simple multiple to make the animation visible
                    if ( cnt > 360 ) { cnt = 360 }
                    
                    self.counterRing.startAnimating()
                    //repeat count of 0 = infinite looping
                    self.counterRing.startAnimatingWithImagesInRange(NSMakeRange(0, cnt), duration: 1.0, repeatCount: 1)
                     self.updateUserActivity("com.salesforce", userInfo: ["results": self.approvalsResult], webpageURL: nil)
                }
            },
                    
                 errorHandler: {(error ) -> Void in
                // catch any errors here
                     print("Something went wrong: \(error)")
            })
        }

        
    }
    
   
    
}

