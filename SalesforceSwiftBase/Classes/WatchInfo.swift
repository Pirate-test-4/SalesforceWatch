//
//  Approvals.swift
//  SalesforceWatch
// 
// Marshalling object to pass reply blocks back to the watch app.
// you shouldn't need to touch this
//
//  Created by Quinton Wall on 1/12/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation


class WatchInfo: NSObject, SFRestDelegate {
    
    var userInfo: [NSObject : AnyObject]!
    
    let replyBlock: ([NSObject : AnyObject]!) -> Void
    
    
    init(userInfo: [NSObject : AnyObject], reply: ([NSObject : AnyObject]!) -> Void) {
        
        self.userInfo = userInfo
        replyBlock = reply
    }
       
}
