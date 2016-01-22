//
//  ApprovalsHandler.swift
//  SalesforceWatch
//
// perform all the heavy lifting of communicating with salesforce for approvals related stuff
// See REST API docs: http://www.salesforce.com/us/developer/docs/api_rest/Content/resources_process_approvals.htm#kanchor169
//
//  Created by Quinton Wall on 1/13/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchConnectivity
import SalesforceSDKCore
import SalesforceRestAPI
import SwiftyJSON


class ApprovalsHandler: NSObject, WCSessionDelegate {
    
    var session: WCSession!
    
    func register() {
        
        print("Salesforce Wear Dev Pack for Apple Watch registering for WatchKit sessions")
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
    }
    

    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("heard a request from the watch")
        
        //make sure we are logged in
        if( !SFAuthenticationManager.sharedManager().haveValidSession) {
            print("not logged in")
            replyHandler(["error": "not logged in"])
        } else {
            print("prep request")
            let sharedInstance = SFRestAPI.sharedInstance()

            let reqType = message["request-type"] as! String
            
            if(reqType == "approval-count") {
                let query = String("SELECT Id, Status, TargetObjectId, LastModifiedDate, (SELECT Id, StepStatus, Comments FROM Steps) FROM ProcessInstance WHERE CreatedDate >= LAST_N_DAYS:10 AND Status = 'Pending' order by LastModifiedDate")
                
                sharedInstance.performSOQLQuery(query, failBlock: { error in
                    replyHandler(["error": error])
                    }) { response in  //success
                        //watchos2 only lets us pass primitive types. We need to convert
                        //the dictionary response from salesforce into a json string to pass to 
                        //the watch, and then recreate it on the other side..
                        let json = JSON(response)
                       replyHandler(["success": json.rawString()!])
                }

                
            } else if (reqType == "approval-details") {
                let objid = message["id"] as! String
                let query = String("select id, name, amount, Account.name from Opportunity where id = '"+(objid as String)+"'")
                
                sharedInstance.performSOQLQuery(query, failBlock: { error in
                    replyHandler(["error": error])
                    }) { response in  //success
                        print("sending successful response")
                        //watchos2 only lets us pass primitive types. We need to convert
                        //the dictionary response from salesforce into a json string to pass to
                        //the watch, and then recreate it on the other side..
                        let json = JSON(response)
                        replyHandler(["success": json.rawString()!])
                        
                }
            } else if (reqType == "approval-update") {
                let objid = message["id"] as! String
                
                //The salesforce approval schema is pretty complicated. Let's make it easy with an Apex Rest Resource
                // see ApproveProcess.apex contained in the project
                let request = SFRestRequest()
                
                request.method = SFRestMethodPOST
                request.endpoint = "/services/apexrest/ApproveProcess"
                request.path = "/services/apexrest/ApproveProcess"
                request.queryParams = ["processId" : objid]
                sharedInstance.sendRESTRequest(request, failBlock: {error in
                    replyHandler(["error": "Failed to approve request: \(error)"])
                    }) { response in
                        replyHandler(["success": "approved"])
                }
                replyHandler(["success": "approved"])

                
                
                
            } else if (reqType == "approval-reject") {
                let objid = message["id"] as! String
                let request = SFRestRequest()
                
                request.method = SFRestMethodPOST
                request.endpoint = "/services/apexrest/RejectProcess"
                request.path = "/services/apexrest/RejectProcess"
                request.queryParams = ["processId" : objid]
                sharedInstance.sendRESTRequest(request, failBlock: {error in
                    replyHandler(["error": "Failed to approve request: \(error)"])
                    }) { response in
                        replyHandler(["success": "rejected"])
                }
                replyHandler(["success": "rejected"])

                
            }  else {
                replyHandler(["error": "no such request-type: "+reqType])
            }

        }
    }
    

}