//
//  SalesforceObjectType.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 1/14/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation

class SalesforceObjectType: NSObject {
    
    class func getType(sfdcid: NSString) -> NSString {
        var type: NSString
        
        if  sfdcid.hasPrefix("006")  {
                type = "Opportunity"
        }
        else {
            type = "Unknown"
        }
        
        return type
    }
}
