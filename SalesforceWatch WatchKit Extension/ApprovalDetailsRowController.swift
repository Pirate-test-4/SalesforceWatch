//
//  ApprovalDetailsRowController.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 1/14/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit

class ApprovalDetailsRowController: NSObject {
    
    //use this for setting the step identifier
    @IBOutlet weak var image: WKInterfaceImage!
    //use this for setting step comment from process
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    
    var opportunityId: String!
    
    
    
}