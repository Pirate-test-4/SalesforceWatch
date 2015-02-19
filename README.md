#Building A Salesforce Wear App For Apple Watch

Apple Watch is the latest in a growing trend of next generation smart watches which include Android Wear-powered devices like the Motorola Moto 360,  LG G Watch R, and Samsung Gear Live.  These recent crop of devices have put an emphasis on aesthetics in both the watch, and OS. Not surprisingly, the Apple Watch has made this a priority.  

WatchKit is..
  
##An Intro to Apple Watch App Development
Before we jump into the code, building apps for the Apple Watch requires a quick introduction to a [few important design concepts](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/WatchKitProgrammingGuide/index.html).

###WatchKit apps are an extension to your phone.
WatchKit apps are an extension to the app running on your iPhone. This statement often surprises developers, but it is critical in understanding how you design your Apple Watch apps. WatchKit provides interface components and manages bluetooth connectivity, but at the time of writing, the actual app you develop is bundled with an accompanying iOS app. 

###Glance Interface
Glance interfaces  should be used to display important information. Glances do not allow any user interaction elements such as buttons, switches etc and can not scroll. They are intended to inform the wearer of the most important information *at a glance*. Think of the lock screen on your iphone: It displays the date and time, but in order to do anything else you have unlock it and *enter the app*. Glances are similar to this.  In practice, I have not found glances to be particularly useful.

###Notification Interface
Notification Interfaces manage notifications pushed the watch via the phone. Notification interfaces are actually made up of two parts: short-look interfaces and long-look interfaces. 

Short-look interfaces function similar to notification on your phone. They present an icon of your app, a short message (known as the title), and your apps name. A short-look interface is what you get if you don't create a custom notification interface.

Long-look interfaces allow you to create your own notification  interface. It allows the developer to add app-specific content and actions (buttons). Long-look interfaces are your friend. You will use them a lot.

###Standard Interface 
The standard interface functions similar to interface controllers within a traditional iOS app. They allow the developer to create a custom interface using the provided UI controls. It is worth noting that WatchKit provides separate UI controls to those provided by iOS, and it's own layout system for arranging these on the screen. 

The past year has seen a lot of changes in how app screens are laid out on iOS with auto-layout having been introduced to support the different dimensions of each of the iPhone and iPad versions. WatchKit does not use auto-layout, by the nature of the watch, it is much simpler however I do expect that different WatchKit layout and auto-layout to influence each other heavily in the near future (eg: WatchKit groups will likely show up on iOS apps soon, and as more versions of the Apple Watch are produced, the need for auto-layout for WatchKit will present itself)


##Salesforce Wear App Blueprint
WatchKit apps and Salesforce Wear all follow a similar app blueprint on how to authenticate and interact with the Salesforce1 platform. No matter what your intended use case is, you can follow this standard blueprint. We will use this blueprint to create a simple tasks-based app to demonstrate how to use Salesforce Wear.

![Salesforce Wear Blueprint](images/blueprint.png)

###Communicating with your iOS App
As mentioned previously, WatchKit apps are an extension to your iOS App. WatchKit provides the underlying bluetooth communication between watch and phone, but as a developer, it is your responsibility to handle messaging. Generally, there are two approaches: App Groups and Observers. 

App Groups allow the sharing of data between different apps within a single project/bundle (remember an iOS app and Apple Watch app are created in the same project, or bundle). Once enabled, App Groups work like a key/value store. In practice, I have found they are a little cumbersome to work with on bigger watch kit apps. 

![App Bundles](images/app-bundles.png)

Observers work similar to selectors and delegates in iOS: you register an observer to handle a specific request, implement handleWatchKitNotification in your iOS app, create a response block, and you are good to go. Observers allow a more object-oriented and modern approach to handling communications. It's personal preference, but in the sample app provided below, we will use observers. The code is intentionally simple, but would not take much to make it much more extensible with a [chain of responsibility pattern](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern).


##Sample App
 This Salesforce Wear developer pack provides a complete implementation of  a basic task list app that uses the existing tasks functionality within Salesforce. Because the purpose of the tutorial is to demonstrate WatchKit integration, the iOS app will be extremely basic from a User Interface perspective - support for authentication and that is about it.  You can grab the app from [GitHub](https://github.com/quintonwall/SalesforceWatch).

<INSERT YOUTUBE VIDEO HERE>

##iOS App 
Our iOS app is pretty simple. It supports authentication and a storyboard with a view controller for you to extend. The code includes all the hooks, and sample code you need to implement your own Apple Watch logic. Let's walk through the logic now.

###AppDelegate.m
The AppDelegate, the start of your application, is provided by the MobileSDK when you create a new project using forceios. To support WatchKit, we've implemented the handleWatchKitExtensionRequest:

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
{
    NSLog(@"WATCHKIT: %@", userInfo);
    
    NSString *reqType = [userInfo objectForKey:@"request-type"];
    
    WatchInfo *winfo = [[WatchInfo alloc] initWithUserInfo:userInfo reply:reply];
    [[NSNotificationCenter defaultCenter] postNotificationName: reqType object:winfo];
    
 
}






