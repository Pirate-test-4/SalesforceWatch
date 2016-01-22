#Salesforce Wear Developer Pack v2 for Apple Watch
The [Salesforce Wear](https://developer.salesforce.com/wear) Developer Pack for [Apple Watch](https://www.apple.com/watch/) provides a sample app that uses [WatchKit](https://developer.apple.com/watchkit/) and the [Salesforce Mobile SDK for iOS](https://github.com/forcedotcom/SalesforceMobileSDK-iOS) to build connected apps. The app, which uses Salesforce approval requests,  demonstrates typical patterns developers will face when building these connected apps and is intended as a starter project to accelerate the creation of more fully featured apps using the benefits of Apple Watch and the Salesforce AppCloud. V2 of the Developer Pack has been updated to use Salesforce Mobile SDK 4.0.2, Apple WatchOS2, and Swift 2.0.

![Salesforce Wear Watch App](https://github.com/developerforce/SalesforceWear-DevPack-For-AppleWatch/blob/master/watch-mockup.png)

Before we jump into the code, building apps for the Apple Watch requires a quick introduction to a [few important architectural concepts](http://devstreaming.apple.com/videos/watch/Getting_Started_With_Watchkit/Getting_Started_With_Watchkit_hd.mp4). 

###WatchKit apps are an extension to your phone.
WatchKit apps are an extension to the app running on your iPhone. This statement often surprises developers, but it is critical in understanding how you design your Apple Watch apps. WatchKit provides interface components and manages bluetooth connectivity, but at the time of writing, the actual app you develop is bundled with an accompanying iOS app. 

###Glance Interface
Glance interfaces should be used to display important information. Glances do not allow any user interaction elements such as buttons, switches etc and can not scroll. They are intended to inform the wearer of the most important information *at a glance*. They are lightweight, and more memory/energy efficient because they do not load your entire app, but just a glance so-to-speak. Think of the lock screen on your iPhone: It displays the date and time, but in order to do anything else you have unlock it and *enter the app*. Glances are similar to this.  

###Notification Interface
Notification Interfaces manage notifications pushed the watch via the phone. Notification interfaces are actually made up of two parts: short-look interfaces and long-look interfaces. 

Short-look interfaces function similar to notification on your phone. They present an icon of your app, a short message (known as the title), and your apps name. A short-look interface is what you get if you don't create a custom notification interface. Apple has done a great job on making short-look interfaces look very stylish. 

Long-look interfaces allow you to create your own notification  interface. It allows the developer to add app-specific content and actions (buttons). Long-look interfaces are your friend. You will use them a lot.

###Standard Interface 
The standard interface functions similar to interface controllers within a traditional iOS app. They allow the developer to create a custom interface using the provided UI controls. It is worth noting that WatchKit provides separate UI controls to those provided by iOS, and it's own layout system for arranging these on the screen. 

The past year has seen a lot of changes in how app screens are laid out on iOS with auto-layout having been introduced to support the different dimensions of each of the iPhone and iPad versions. WatchKit does not use auto-layout, by the nature of the watch, it is much simpler however I do expect that different WatchKit layout and auto-layout to influence each other heavily in the near future (eg: WatchKit style groups will likely show up on iOS apps soon, and as more versions of the Apple Watch are produced, the need for auto-layout for WatchKit will present itself)

##WatchOS2
WatchOS2, launched in 2015 along with Swift 2.0, brought a number of changes and improvements to how developing apps for the Apple Watch functions. Most notably is the change to how you  register for messages and communicate between the watch and paired iPhone. The Salesforce Wear for Apple Watch Developer Pack has been updated for WatchOS2 and Swift 2.1.

##Salesforce Wear App Blueprint
WatchKit apps and Salesforce Wear all follow a similar app blueprint on how to authenticate and interact with the Salesforce App Cloud. No matter what your intended use case is, you can follow this standard blueprint. We will use this blueprint to create a simple tasks-based app to demonstrate how to use Salesforce Wear. 


###Communicating with your iOS App
As mentioned previously, WatchKit apps are an extension to your iOS App. WatchKit provides the underlying bluetooth communication between watch and phone, but as a developer, it is your responsibility to handle messaging. Generally, there are two approaches: App Groups and Messages. 

App Groups allow the sharing of data between different apps within a single project/bundle (remember an iOS app and Apple Watch app are created in the same overall). Once enabled, App Groups work like a key/value store. In practice, I have found they are a little cumbersome to work with on bigger WatchKit apps. 

![App Bundles](https://github.com/developerforce/SalesforceWear-DevPack-For-AppleWatch/blob/master/readme-images/app-bundles.png)

One of the major changes in WatchOS2 is the greatly simplified send/receive message functions. In order to send or receive messages, you must first ensure a phone or watch is available and establish a session:

'' var session: WCSession!
'' if (WCSession.isSupported()) {
			'' session = WCSession.defaultSession()
			'' session.delegate = self;
			'' session.activateSession()
'' }

Once a session is established, messages can be sent via a code block:
 
		'' if (WCSession.defaultSession().reachable) {
			'' session.sendMessage(applicationData, replyHandler: { reply in
				'' //add your code here
			'' },  errorHandler: {(error ) -> Void in
				'' // catch any errors here
		'' })
		'' }

Or receive a message, and send a response using a replyHandler:

''  func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
''  //add your code here
'' }


As to whether you use App Groups of the WCSession for communication, it often comes down to personal preference. The developer pack uses WCSession. We’ve found that this works better with code blocks and the Mobile SDK. We like them. You should too.

##Sample App
 This Salesforce Wear developer pack provides a complete implementation of  a basic approvals app that uses the existing tasks functionality within Salesforce. The app demonstrates WatchOS2 communications, and retrieving and updating data from the Salesforce App Cloud. The app demonstrates user authentication using Mobile SDK delegates and the use of SOQL statements as well as custom Apex REST endpoints via code blocks. In addition, the app relies on Cocoapods to install any dependencies. Cocoapods make it super easy to add and update dependencies as need.  You can grab the app from [GitHub](https://github.com/developerforce/SalesforceWear-DevPack-For-AppleWatch), and watch a video of the finished app [here](http://www.youtube.com/watch?v=cQRvR6PFdhU).
 
*Note:* This the code and dev park uses Salesforce Mobile SDK 4.0.2, iOS 9.2, WatchOS2 and Swift 2.1. It has been tested using  Xcode 7.2. Make sure that you check your versions to ensure things work correctly. If you have any issues, please create a pull request for review, or send [me] a tweet.

##iOS App 
Our iOS app is pretty simple. It supports authentication and a storyboard with a view controller for you to extend. The code includes all the hooks, and sample code you need to implement your own WatchKit logic. Let's walk through the logic on the phone now.

###AppDelegate
The AppDelegate, the start of your application, is provided by the MobileSDK when you create a new project using *forceios*. However, forceios creates an Objective-C class. The Apple Watch Dev Pack is written in Swift. As such, I rewrote the Objective-C AppDelegate entirely in Swift. 

Now that WatchOS2 provides a more democratized send/receive messages approach instead of the *handleWatchKitExtensionRequest* approach in WatchOS1, the AppDelegate is pretty independent of watch specific code. The AppDelegate is still a great place to initialize the Mobile SDK:

''  override init()
	'' {
		'' super.init()
		'' 
		'' 
		'' //let appGroupID = "group.com.gyspycode.SFTasks"
		'' //let defaults = NSUserDefaults(suiteName: appGroupID)
		'' 
		'' 
		'' SFLogger.setLogLevel(SFLogLevel.Debug)
		'' 
		'' 
		'' SalesforceSDKManager.sharedManager().connectedAppId = RemoteAccessConsumerKey
		'' SalesforceSDKManager.sharedManager().connectedAppCallbackUri = OAuthRedirectURI
		'' SalesforceSDKManager.sharedManager().authScopes = scopes
		'' SalesforceSDKManager.sharedManager().postLaunchAction = {
			'' [unowned self] (launchActionList: SFSDKLaunchAction) in
			'' let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
			'' self.log(SFLogLevel.Info, msg:"Post-launch: launch actions taken: \(launchActionString)");
		'' }
		'' SalesforceSDKManager.sharedManager().launchErrorAction = {
			'' [unowned self] (error: NSError?, launchActionList: SFSDKLaunchAction) in
			'' if let actualError = error {
				'' self.log(SFLogLevel.Error, msg:"Error during SDK launch: \(actualError.localizedDescription)")
			'' } else {
				'' self.log(SFLogLevel.Error, msg:"Unknown error during SDK launch.")
			'' }
''   
		'' }
		'' SalesforceSDKManager.sharedManager().postLogoutAction = {
			'' [unowned self] in
			'' self.handleSdkManagerLogout()
		'' }
		'' SalesforceSDKManager.sharedManager().switchUserAction = {
			'' [unowned self] (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
			'' self.handleUserSwitch(fromUser, toUser: toUser)
		'' }
		'' 
		'' 
		'' approvalsHelper.register()
	'' }

This code is typical Mobile SDK initialization (but written in Swift - yay!) with two items to note:
1. There is no call to *self.setupRootViewController()* that typically gets generated using *forceios*. In practice, I found that I want to use a button to kick of the Salesforce login flow vs showing the Salesforce login screen as soon as my app loads. Check out the *RootVC.swift* *connectTapped* function for where the login flow actually starts
2. To keep the logic that interacts with Salesforce for approvals, I’ve encapsulated the logic in a separate class *ApprovalsHandler*. *ApprovalsHandler* also knows how to register for WatchKit sessions with the call to *approvalsHelper.register()*. 


##RootVC.swift
The RootVC is the view controller of our extremely simple user interface. In fact, there is really no need to have an interface at all, but a typical Apple Watch app would have a counterpart app on the phone. When designing Apple Watch apps, always keep in mind the functionality that you want to include. For example, if we wanted to create new approvals, doing this on the Watch would be pretty painful (would you want a keyboard that small even if you could?).  

Right now the iPhone portion of the Approvals app doesn’t do much of anything. As soon as I have some more time, I will build it out more to  allow the user to create approvals on the phone and have access to any approvals assigned to them via the Watch for quick approve/decline requests on the go. (If you are interested in learning how to make a complete app, check out the enterprise ios tutorials [here](http://quintonwall.github.io/enterprise-ios))

Our sample app uses the *RootVC.swift* controller to let the user authenticate with Salesforce. In WatchOS1 and v1 of the Dev Pack, we used *RootVC.swift* to register for WatchKit notifications using *NSNotificationCenter*. You no longer need to do this. The result is much cleaner, more encapsulated code. Now, all our RootVC.swift controller is responsible for is UI interactions such as allowing the user to tap a button to start the Salesforce auth flow and perform appropriate nagivation once logged in.

''  @IBAction func connectTapped(sender: AnyObject) {
		'' 
		''  SalesforceSDKManager.sharedManager().launch()
	'' }
	'' 
	'' func authManagerDidFinish(manager: SFAuthenticationManager!, info: SFOAuthInfo!) {
		'' 
		'' //need to perform this check at the end of the authmanager lifecycle
		'' //because SFRootViewManager removes the current view after didAUthenticate gets called :(
		'' 
		'' if SFAuthenticationManager.sharedManager().haveValidSession {
			'' 
			'' self.performSegueWithIdentifier("loggedin", sender: nil)
		'' }
	'' }

##HomeTableViewController.swift
This controller will contain logic to display and approve/reject opportunities from the iPhone. It has not been fully implemented yet, but will use the same functions as the watch app via the ApprovalsHandler.

##ApprovalsHandler.swift
To encapsulate logic that handles communicating via the MobileSDK, we've created a handler class, *ApprovalsHandler*. Let's look at the getApprovals function. 

First, let’s import the Salesforce Mobile SDK, WatchOS2 frameworks, and specify this class as a Delegate to accept communications from a paired Apple Watch.

```swift
'' import Foundation
'' import WatchConnectivity
'' import SalesforceSDKCore
'' import SalesforceRestAPI
'' import SwiftyJSON
'' 
'' 
'' class ApprovalsHandler: NSObject, WCSessionDelegate {
''  
```


And register for a WatchKit session.
```swift
''  var session: WCSession!
	'' 
	'' func register() {
		'' 
		'' print("Salesforce Wear Dev Pack for Apple Watch registering for WatchKit sessions")
		'' 
		'' if (WCSession.isSupported()) {
			'' session = WCSession.defaultSession()
			'' session.delegate = self;
			'' session.activateSession()
		'' }
	'' }

```


Now that our class is all set up, all of our logic is contained in the *didReceiveMessage* func provided by *WCSessionDelegate*. Similar to WatchOS1, messages are passed back and forth using Dictionaries. The Dev pack uses a key-value pair of **request-type** to identify which action (retrieve approvals, approve or reject an approval etc) is required. Let’s look at one of these requests, approval-count. 
```swift
'' let sharedInstance = SFRestAPI.sharedInstance()
'' 
			'' let reqType = message["request-type"] as! String
			'' 
			'' if(reqType == "approval-count") {
				'' let query = String("SELECT Id, Status, TargetObjectId, LastModifiedDate, (SELECT Id, StepStatus, Comments FROM Steps) FROM ProcessInstance WHERE CreatedDate >= LAST_N_DAYS:10 AND Status = 'Pending' order by LastModifiedDate")
				'' 
				'' sharedInstance.performSOQLQuery(query, failBlock: { error in
					'' replyHandler(["error": error])
					'' }) { response in  //success
						'' //watchos2 only lets us pass primitive types. We need to convert
						'' //the dictionary response from salesforce into a json string to pass to 
						'' //the watch, and then recreate it on the other side..
						'' let json = JSON(response)
					''    replyHandler(["success": json.rawString()!])
				'' }
'' 
				'' 
			'' }
			'' 
			 ```

Once we determine that the request is for an approval-count, we create a SOQL query and use the Mobile SDK performSOQLQuery func to retrieve data from Salesforce and a code block to handle the response. 

WatchOS2 uses a replyhandler dictionary to marshall payloads back to the Watch. The great thing about the WatchConnectivity framework in WatchOS2 is that it takes care of all the network communications for us. However, it isn’t the greatest when working with objects. It’s kind of designed to use primitives like String. This is one of the benefits of using AppGroups - you stick your object in the AppGroup, then tell the Watch to go pull it out. 

The MobileSDK returns a nicely nested Dictionary already based on a API call that returns JSON. It’s basically a dictionary of Strings. Unfortunately WatchKit doesn’t like it much. In order to pass our response back to the Watch using replayHandler (rather than AppGroups), we need to *flatten* things back to JSON. The Dev Pack uses SwiftyJSON, an open source framework that makes working with JSON in Swift incredibly easy

```swift
'' let json = JSON(response)
'' replyHandler(["success": json.rawString()!])

``` 



The app also uses custom Apex Rest endpoints to make it easy to work with the Salesforce Approval Process schema. This is a great example of using Salesforce as an MBaaS - you add cloud logic where it makes sense. In order to use the app add ApproveProcess.apex and RejectProcess.apex to your Salesforce org. The code below shows how the ApprovalHandler.swift calls these Restful endpoints.
```swift
''  let request = SFRestRequest()
				'' 
				'' request.method = SFRestMethodPOST
				'' request.endpoint = "/services/apexrest/ApproveProcess"
				'' request.path = "/services/apexrest/ApproveProcess"
				'' request.queryParams = ["processId" : objid]
				'' sharedInstance.sendRESTRequest(request, failBlock: {error in
					'' replyHandler(["error": "Failed to approve request: \(error)"])
					'' }) { response in
						'' replyHandler(["success": "approved"])
				'' }
				'' replyHandler(["success": "approved"])
'' 
				'' 
```

##WatchKit App
Now it is time to look at the actual app running on the watch. Our simple sample app doesn't current use notifications (I'll be adding these soon and rolling them into the larger tutorial [here](http://quintonwall.github.io/enterprise-ios).) We are using standard long-look interfaces. Here is the storyboard for the app:

![watch app storyboard](https://github.com/developerforce/SalesforceWear-DevPack-For-AppleWatch/blob/master/readme-images/storyboard-glances.png)

Let's look at our glance controller, *GlanceController*. As soon as the app is about to activate, we fetch the list of approvals and display them in a funky little graphical representation plus some indication of which records are approved, pending, rejected.

**Note**: The sample app uses a glance, but it also includes another controller, *InterfaceController* to demonstrate an alternate view for the user. Both *InterfaceController* and *GlanceController* direct to the main controller, *ApprovalsInterfaceController* as defined in the storyboard.

WatchOS2 gives us the ability to check for a paired phone, and if available, establish a valid session. If we have a session, we can make a call to *getApprovalList()* to fetch information from Salesforce.

```swift
'' override func willActivate() {
		'' 
		'' super.willActivate()
		'' 
		'' if (WCSession.isSupported()) {
			'' session = WCSession.defaultSession()
			'' session.delegate = self
			'' session.activateSession()
			''  self.getApprovalList()
		'' }
		'' 
	''    
	'' }
```

*getApprovalsList* is a typical pattern on how to communicate with the iOS app, and eventually Salesforce. It calls *session.sendMessage* which provides a block to handle the response. You will note that we create a simple Dictionary object to set the request-type to ensure that our iOS app knows how to route the request properly.

```swift

'' let applicationData = ["request-type":"approval-count"]
		'' 
		'' 
		'' if (WCSession.defaultSession().reachable) {
			'' session.sendMessage(applicationData, replyHandler: { reply in
				'' //handle iphone response here
				'' if(reply["success"] != nil) {
					'' 
					'' 
					'' let x:String = reply["success"] as! String
					'' 
					'' 
					'' let res = SalesforceObjectType.convertStringToDictionary(x)
					'' //code abbreviated in readme
			'' 
'' 
```

Remember earlier in ApprovalsHandler we had to serialize the Dictionary object to JSON. Now we need to deserialize it back. The Dev pack contains a helper function *convertStringToDictionary* to take care of it for you.


###Running the app
At the time of writing, WatchKit apps, operate as a separate target within your xCode project. In order to run the sample app, you must: 
* Run the SalesforceWatch (iPhone) target first and log into the app via the simulator. (Remember an Apple Watch app is an extension to an iPhone app. We are still using the iPhone and the Salesforce Mobile SDK for iOS to handle authentication and communications to the Salesforce App Cloud.
* Ensure that you have the Apple Watch simulator visible. To enable this, select Hardware->External Displays->Apple Watch 38/42mm from the iOS simulator app menu.
* Switch targets within your xCode project, choosing "SalesforceWatch WatchKit App" and run your app. The watch simulator will now run (you should see a little update animation and eventually a ring with the number of approvals in your Salesforce org)

###Further implementations
The code walkthrough above provides an overview of the typical patterns when working with WatchKit apps and iOS apps that use the Mobile SDK for Salesforce. You can check out the *ApprovalsInterfaceController.swift* and *ApprovalsDetailsController.swift* for more examples, but the pattern is identical to those described above.

##Summary
The Salesforce Wear Developer Pack for Apple Watch provides a sample implementation and typical patterns when connecting Apple Watch devices to the App Cloud.  Using this app you can quickly jumpstart your own Apple Watch development projects to take advantage of Salesforce’s App Cloud.

And don't forget that building apps for Apple Watch is different to building apps for iOS devices like the iPhone or iPad. I encourage you to spend some time looking at [Apple's Human Interface Design Guidelines](http://thinkapps.com/blog/design/apple-watch-apps-important-design-principles/) before you start your app.

If you are new to iOS and Salesforce Mobile SDK development, be sure to check out the complete enterprise iOS tutorial [here](http://quintonwall.github.io/enterprise-ios).


