//
//  ApprovalsHandler.swift
//  SalesforceWatch
//
// perform all the heavy lifting of communicating with salesforce for approvals related stuff
//
//  Created by Quinton Wall on 1/13/15.
//  Copyright (c) 2015 Salesforce, Inc. All rights reserved.
//

import Foundation


class ApprovalsHandler: NSObject, SFRestDelegate {
    
    var watchInfo : WatchInfo?
    
    func getApprovals() {
        
        var sharedInstance = SFRestAPI.sharedInstance()
        //var approvalsPath: String = "/v"+sharedInstance.apiVersion+"/process/approvals/"
        //var request: AnyObject! = SFRestRequest.requestWithMethod(SFRestMethodGET, path: approvalsPath, queryParams: nil)
        var request = sharedInstance.requestForQuery("SELECT Id, Status, TargetObjectId, LastModifiedDate, (SELECT Id, StepStatus, Comments FROM Steps) FROM ProcessInstance order by LastModifiedDate")
        
       sharedInstance.send(request as SFRestRequest, delegate: self)
   }
    
    
    
    func request(request: SFRestRequest?, didLoadResponse jsonResponse: AnyObject) {
        var records = jsonResponse.objectForKey("records") as NSArray
        println("request:GOT APPROVALS: #records: \(records.count)");
        
        //send the block back to le watch
        if let watchInfo = watchInfo {
            let stuff = ["results" : records]
            watchInfo.replyBlock(stuff)
        }
       
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