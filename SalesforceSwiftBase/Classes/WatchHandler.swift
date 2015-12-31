//
//  WatchHandler.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 12/31/15.
//  Copyright © 2015 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchConnectivity


class WatchHandler: NSObject, WCSessionDelegate {
    
    var session: WCSession!
    
    func register() {
        
        print("Salesforce Wear Dev Pack for Apple Watch registering for WatchKit sessions")
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
    }
}
