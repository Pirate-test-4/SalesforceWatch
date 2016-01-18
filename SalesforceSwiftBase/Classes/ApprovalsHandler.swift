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
            let reqType = message["request-type"] as! String
            
            if(notification.name == "approval-count") {
                self.getApprovals()
                
            } else if (notification.name == "approval-details") {
                let objid = message["param1"] as! String
                self.getTargetObjectDetails(objid)
            } else if (notification.name == "approval-update") {
                let objid = message["param1"] as! String
               self.updateApproval(objid, status: "Approve")
            } else if (notification.name == "approval-reject") {
                let objid = message["param1"] as! String
                self.updateApproval(objid, status: "Reject")
            }  else {
                replyHandler(["error": "no such request-type: "+reqType])
            }

        }
    }
    
    
    func getApprovals() {
        
        
        let sharedInstance = SFRestAPI.sharedInstance()
       
        let request = sharedInstance.requestForQuery("SELECT Id, Status, TargetObjectId, LastModifiedDate, (SELECT Id, StepStatus, Comments FROM Steps) FROM ProcessInstance WHERE CreatedDate >= LAST_N_DAYS:10 AND Status = 'Pending' order by LastModifiedDate")
       

        sharedInstance.performSOQLQuery(query, failBlock: { error in
            replyHandler(["error": error])
            }) { response in  //success
                print("sending successful response")
                replyHandler(["success": response])
        }
       
   }
    
    func getTargetObjectDetails(targetobjectid: NSString) {
        
        let sharedInstance = SFRestAPI.sharedInstance()
        let request = sharedInstance.requestForQuery("select id, name, amount, Account.name from Opportunity where id = '"+(targetobjectid as String)+"'")
        
         sharedInstance.performSOQLQuery(query, failBlock: { error in
            replyHandler(["error": error])
            }) { response in  //success
                print("sending successful response")
                replyHandler(["success": response])
        }
        
    }
    
    func updateApproval(targetobjectid: NSString, status: NSString) {
        let sharedInstance = SFRestAPI.sharedInstance()
        var currUserId = SFUserAccountManager.sharedInstance().currentUserId
        var apiUrl = SFUserAccountManager.sharedInstance().currentUser.apiUrl.absoluteString
    
        
        //The salesforce approval schema is pretty complicated. Let's make it easy with an Apex Rest Resource
       // see ApproveProcess.apex contained in the project

        let request = SFRestRequest()
        
        request.method = SFRestMethodPOST

        if(status == "Approve") {
            request.endpoint = "/services/apexrest/ApproveProcess"
            request.path = "/services/apexrest/ApproveProcess"
        } else if (status == "Reject") {
            request.endpoint = "/services/apexrest/RejectProcess"
            request.path = "/services/apexrest/RejectProcess"
        }
        request.queryParams = ["processId" : targetobjectid]
        
        sharedInstance.send(request, delegate: nil)  //we dont need to handle the response
        
        
    }
    
}