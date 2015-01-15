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
    
    override func awakeWithContext(context: AnyObject?) {
        precondition(context is NSArray, "Expected class of `context` to be NSArray.")
        
        let approvals = context as NSArray
       // listDocument = ListDocument(fileURL: listInfo.URL)
        
        // Set the title of the interface controller based on the list's name.
        //setTitle("Approvals"+String(approvals.count))
        println("Approvals"+String(approvals.count))
        loadTableData(approvals)
        
        
        
        // Fill the interface table with the current list items.
        //setupInterfaceTable()
    }
    
    override func didDeactivate() {
        //listDocument.closeWithCompletionHandler(nil)
    }
    
    private func loadTableData(results: NSArray) {
        
        //withRowType needs to be the identifier you give the table in your storyboard
        resultsTable.setNumberOfRows(results.count, withRowType: "ApprovalRows")
        println(resultsTable.numberOfRows)
        
        for (index, record) in enumerate(results) {
           let row = resultsTable.rowControllerAtIndex(index) as ApprovalDetailsRowController
       
            var s: NSDictionary = record as NSDictionary
            row.image.setImageNamed(s["Status"] as? String)
            row.opportunityId = s["TargetObjectId"] as? String
            var status = s["Status"] as? String
            row.detailLabel.setText(status! + " "+SalesforceObjectType.getType(row.opportunityId))
            //row.detailLabel.setText(s["Status"] as? String)
            
        }
        
    }

}
