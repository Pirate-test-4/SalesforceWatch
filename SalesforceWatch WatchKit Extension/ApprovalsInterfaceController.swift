//
//  ApprovalsInterfaceController.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 1/14/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit

class ApprovalsInterfaceController: WKInterfaceController {
    
    
    @IBOutlet weak var resultsTable: WKInterfaceTable!
    // MARK: Interface Life Cycle
    
    
    
    //if app starts from the glance
    override func handleUserActivity(userInfo: [NSObject : AnyObject]!) {
       
        if let results = userInfo["results"] as? NSArray {
             loadTableData(results)
        }
    }
    
    //if context comes from a prepareForSeque call
    override func awakeWithContext(context: AnyObject?) {
        
        let requestBundle = ["request-type" : "approval-count"]
        
        WKInterfaceController.openParentApplication(requestBundle, reply: { [unowned self](reply, error) -> Void in
            
            if let reply = reply as? [String: NSArray] {
                self.loadTableData(reply["results"]!)
                
            }
        })
    }
    
    /*
    override func willActivate() {
        let requestBundle = ["request-type" : "approval-count"]
        
        WKInterfaceController.openParentApplication(requestBundle, reply: { [unowned self](reply, error) -> Void in
            
            if let reply = reply as? [String: NSArray] {
                self.loadTableData(reply["results"]!)
                
            }
        })
    }
 */
    
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
            row.image.setImageNamed(s["Status"] as? String)
            row.recordid = s["Id"] as? String
            row.opportunityId = s["TargetObjectId"] as? String
            let status = s["Status"] as? String
            row.detailLabel.setText(status! + " "+(SalesforceObjectType.getType(row.opportunityId) as String))
            //row.detailLabel.setText(s["Status"] as? String)
            
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
