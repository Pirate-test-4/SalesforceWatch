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
}
