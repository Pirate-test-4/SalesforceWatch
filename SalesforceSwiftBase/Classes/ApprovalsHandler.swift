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



class ApprovalsHandler: NSObject, SFRestDelegate {
    
    var watchInfo : WatchInfo?
    
    func getApprovals() {
        
        
        var sharedInstance = SFRestAPI.sharedInstance()
       
        var request = sharedInstance.requestForQuery("SELECT Id, Status, TargetObjectId, LastModifiedDate, (SELECT Id, StepStatus, Comments FROM Steps) FROM ProcessInstance WHERE CreatedDate >= LAST_N_DAYS:10 AND Status = 'Pending' order by LastModifiedDate")
       

        
       sharedInstance.send(request as SFRestRequest, delegate: self)
   }
    
    func getTargetObjectDetails(targetobjectid: NSString) {
        
        var sharedInstance = SFRestAPI.sharedInstance()
        var request = sharedInstance.requestForQuery("select id, name, amount, Account.name from Opportunity where id = '"+(targetobjectid as String)+"'")
        
        sharedInstance.send(request as SFRestRequest, delegate: self)
        
    }
    
    //TODO
    func updateApproval(targetobjectid: NSString, status: NSString) {
        var sharedInstance = SFRestAPI.sharedInstance()
        var currUserId = SFUserAccountManager.sharedInstance().currentUserId
        var apiUrl = SFUserAccountManager.sharedInstance().currentUser.apiUrl.absoluteString
    
        
        //The salesforce approval schema is pretty complicated. Let's make it easy with an Apex Rest Resource
       // see ApproveProcess.apex contained in the project

        var request = SFRestRequest()
        
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
    
    
    
    func request(request: SFRestRequest?, didLoadResponse jsonResponse: AnyObject) {
        
       // if( jsonResponse != nil) {
            var records = jsonResponse.objectForKey("records") as! NSArray
            println("request:GOT APPROVALS: #records: \(records.count)");
            
            //send the block back to le watch
            if let watchInfo = watchInfo {
                let stuff = ["results" : records]
                watchInfo.replyBlock(stuff)
            }
       // }
       
    }
    
    func request(request: SFRestRequest?, didFailLoadWithError error:NSError) {
        println("In Error: \(error)")
    }
    
    func requestDidCancelLoad(request: SFRestRequest) {
        println("In requestDidCancelLoad \(request)")
    }
    
    
    func requestDidTimeout(request: SFRestRequest) {
        println("In requestDidTimeout \(request)")
    }
    

    
}