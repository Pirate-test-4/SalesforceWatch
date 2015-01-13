//
//  Approvals.swift
//  SalesforceWatch
// 
// Marshalling object to pass reply blocks back to the watch app
//
//  Created by Quinton Wall on 1/12/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation


class WatchInfo: NSObject, SFRestDelegate {
    
    let replyBlock: ([NSObject : AnyObject]!) -> Void
    
    init(userInfo: [NSObject : AnyObject], reply: ([NSObject : AnyObject]!) -> Void) {
        
        
        replyBlock = reply
    }
       
}
