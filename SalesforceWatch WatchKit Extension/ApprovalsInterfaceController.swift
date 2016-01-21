//
//  ApprovalsInterfaceController.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 1/14/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity  //new for watchOS2

class ApprovalsInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    @IBOutlet weak var resultsTable: WKInterfaceTable!
    // MARK: Interface Life Cycle
    
    
    //used to register the watch and paired phone
    var session : WCSession!
    
    //if app starts from the glance
    override func handleUserActivity(userInfo: [NSObject : AnyObject]!) {
       
        if let results = userInfo["results"] as? NSArray {
             loadTableData(results)
        }
    }
    
    //if context comes from a prepareForSeque call
    override func awakeWithContext(context: AnyObject?) {
        
        
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            self.getApprovalList()
        }
        
    }
    
    private func getApprovalList() {
        
        let applicationData = ["request-type":"approval-count"]
        
        if (WCSession.defaultSession().reachable) {
            session.sendMessage(applicationData, replyHandler: { reply in
                //handle iphone response here
                if(reply["success"] != nil) {
                    let x:String = reply["success"] as! String
                    
                    
                    let res = SalesforceObjectType.convertStringToDictionary(x)
                    self.loadTableData(res!["records"] as! NSArray)
                }
            },
            errorHandler: {(error ) -> Void in
                    // catch any errors here
                print("Something went wrong: \(error)")
            })
        }
            
    }

    override func didDeactivate() {
        //listDocument.closeWithCompletionHandler(nil)
    }
    
    private func loadTableData(results: NSArray) {
        
        //withRowType needs to be the identifier you give the table in your storyboard
        resultsTable.setNumberOfRows(results.count, withRowType: "ApprovalRows")
        print(resultsTable.numberOfRows)
        
        for (index, record) in results.enumerate() {
           let row = resultsTable.rowControllerAtIndex(index) as! ApprovalDetailsRowController
       
            let s: NSDictionary = record as! NSDictionary
            //row.image.setImageNamed(s["Status"] as? String)
            row.image.setImageNamed("Tag")
            row.recordid = s["Id"] as? String
            row.opportunityId = s["TargetObjectId"] as? String
            let status = s["Status"] as? String
            row.detailLabel.setText(status! + " "+(SalesforceObjectType.getType(row.opportunityId) as String))
            
            
        }
        
    }
    

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        let row = table.rowControllerAtIndex(rowIndex) as? ApprovalDetailsRowController
        //cant return a tuple for an AnyObject :(
        //let selectedProcess = (processid: row?.recordid, targetobjectid: row?.opportunityId)
        
        var selectedProcess : Dictionary<String, String> = Dictionary()
        selectedProcess["recordid"] = row?.recordid
        selectedProcess["targetobjectid"] = row?.opportunityId
        
    
        return selectedProcess
    }
    
    // MARK: Table Actions
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
       
        let row = resultsTable.rowControllerAtIndex(rowIndex) as? ApprovalDetailsRowController
        self.pushControllerWithName("processSelected", context: row?.opportunityId)
       // self.contextForSegueWithIdentifier("processSelected")
       
    }

}
