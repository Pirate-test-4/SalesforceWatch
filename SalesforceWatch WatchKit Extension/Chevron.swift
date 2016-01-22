//
//  RingHelper.swift
//  SalesforceWatch
// 
// 
// wrapper to create a chevron-based ring graphic. TODO: use image animations in v2
//
//  Created by Quinton Wall on 1/13/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation


class Chevron {
    
    class func getChevronImage(num: Int) -> NSString {
        
        var imageName: NSString
        
        switch num {
            
        case 0:
            imageName = "ring-0degrees"
        case 1...2:
            imageName = "ring-30degrees"
        case 3...4:
            imageName = "ring-60degrees"
        case 5...6:
            imageName = "ring-90degrees"
        case 7...8:
            imageName = "ring-120degrees"
        case 9...10:
            imageName = "ring-150degrees"
        case 11...12:
            imageName = "ring-180degrees"
        case 13...14:
            imageName = "ring-210degrees"
        case 15...16:
            imageName = "ring-240degrees"
        case 17...18:
            imageName = "ring-270degrees"
        case 19...20:
            imageName = "ring-300degrees"
        case 21...22:
            imageName = "ring-330degrees"
        default:
            imageName = "ring-360degrees"
            
        }
        
        print("Chevron providing image name "+(imageName as String))
        return imageName
    }
}
