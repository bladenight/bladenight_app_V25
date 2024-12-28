import UIKit
import Flutter
import AVKit
//import app_links
import BackgroundTasks
import WatchConnectivity
//import workmanager

@main
@objc class AppDelegate: FlutterAppDelegate {
    var session: WCSession?
    var appTerminatedFlag: Bool = false
    
    let methodChannelName: String = "bladenightchannel"
    let backgroundTaskName: String = "workmanager.background.task"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        NSLog("Starting BladeNightApp Runner")
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
            //not working on iOS registerBackgroundPlugins()
        }
        initFlutterChannel()
        
        if WCSession.isSupported() {
            session = WCSession.default;
            session!.delegate = self;
            session!.activate();
        }
        clearOldWatchTransfers()
        
        GeneratedPluginRegistrant.register(with: self);
        
        /*if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
              // We have a link, propagate it to your Flutter app or not
              AppLinks.shared.handleLink(url: url)
              return true // Returning true will stop the propagation to other packages
            }*/
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationDidFinishLaunching(_ application: UIApplication) {
        //Show notifications in foreground
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    /* func registerBackgroundPlugins(){
     //update Event in background
     WorkmanagerPlugin.registerTask(withIdentifier: backgroundTaskName)
     //important next lines-> when not registered backgroundtask fails with MissingPluginException
     WorkmanagerPlugin.setPluginRegistrantCallback { registry in
     GeneratedPluginRegistrant.register(with: registry)
     }
     }*/
    
    override func applicationWillTerminate(_ application: UIApplication) {
        guard let watchSession = self.session, watchSession.isPaired else {
            print("applicationWillTerminate received - error on init watchsession")
            return;
        }
        let watchData: [String: Any] = ["method" : "phoneAppWillTerminate" , "data": "true"]
        watchSession.transferUserInfo(watchData)
        print("applicationWillTerminate received")
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert) // shows banner even if app is in foreground
    }
    
    private func showTestNotification(text:String?){
        let content = UNMutableNotificationContent()
        content.title = text ?? "Notification"
        content.subtitle = "Bladenight App"
        content.body = "new information"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    private func clearOldWatchTransfers(){
        guard let watchSession = self.session, watchSession.isPaired else {
            return
            
        }
        let outStanding = watchSession.outstandingUserInfoTransfers
        print("Canceling  \(outStanding.count) outstandings" )
        for  item in outStanding{
            
            item.cancel()
            
        }
        
    }
    
    
    private func initFlutterChannel() {
        if let controller = window?.rootViewController as? FlutterViewController {
            
            let channel = FlutterMethodChannel(
                name: "bladenightchannel",
                binaryMessenger: controller.binaryMessenger)
            
            channel.setMethodCallHandler({ [weak self] (
                call: FlutterMethodCall,
                result: @escaping FlutterResult) -> Void in
                switch call.method {
                case "flutterToWatchTransferUserInfo":
                    //debugPrint("flutterToWatchTransferUserInfo channel called")
                    guard let watchSession = self?.session, watchSession.isPaired, let methodData = call.arguments as? [String: Any], let method = methodData["method"], let data = methodData["data"] else {
                        result(false)
                        //debugPrint("flutterToWatchTransferUserInfo failed. ")
                        return
                    }
                    
                    let watchData: [String: Any] = ["method": method, "data": data]
                    let outStanding = watchSession.outstandingUserInfoTransfers
                    
                    var i = 0
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd H:mm:ss.SSSS"
                         
                    for  item in outStanding{
                        i += 1
                        //print("\(df.string(from:Date())) flutterToWatchTransferUserInfo delete \(i) outstanding \(String(describing: item.userInfo[method as! String]))")
                        let userInfo = item.userInfo
                        let values = userInfo[method as! String]
                        if (values != nil){
                            item.cancel()
                        }
                    }
                    
                    //if (hasData!=nil){
                    //   outStanding.removeAll(where: <#T##(WCSessionUserInfoTransfer) throws -> Bool#>)
                    //}
                    // Pass the receiving message to Apple Watch
                    if (watchSession.isReachable){
                        
                        // Pass the receiving message to Apple Watch
                        watchSession.sendMessage(watchData, replyHandler: {
                            (replyMessage) in
                            print("Got a reply from the phone: \(replyMessage)")
                            
                            // handle reply message here
                            
                        }, errorHandler: { (error) in
                            print("Got an error sending to the phone: \(error)")
                            watchSession.transferCurrentComplicationUserInfo(watchData)
                        })
                        
                    }
                    else {
                        watchSession.transferCurrentComplicationUserInfo(watchData)
                    }
                    //debugPrint("flutterToWatchTransferUserInfo channel finished \(watchData)")
                    result(true)
                    break
                    
                case "flutterToWatchTransferApplicationContext":
                    //debugPrint("flutterToWatchTransferApplicationContext channel called")
                    guard let watchSession = self?.session, watchSession.isPaired, let methodData = call.arguments as? [String: Any], let method = methodData["method"], let data = methodData["data"] else {
                        result(false)
                        //print("flutterToWatchTransferApplicationContext failed.")
                        return
                    }
                    
                    let watchData: [String: Any] = ["method": method, "data": data]
                    // Pass the receiving message to Apple Watch
                    do{
                        try watchSession.updateApplicationContext(watchData)
                    }
                    catch {
                        print("flutterToWatchTransferApplicationContext channel failed \(error.localizedDescription)")
                    }
                    //debugPrint("flutterToWatchTransferApplicationContext channel finished \(watchData)")
                    result(true)
                    
                case "flutterToWatch":
                    guard let watchSession = self?.session, watchSession.isPaired,watchSession.isWatchAppInstalled, let methodData = call.arguments as? [String: Any], let method = methodData["method"], let data = methodData["data"] else {
                        result(false)
                        return
                    }
                    
                    let watchData: [String: Any] = ["method": method, "data": data]
                    //print("flutterToWatch reachable: \(watchSession.isReachable) \(data)")
                    if (watchSession.isReachable){
                        
                        // Pass the receiving message to Apple Watch
                        watchSession.sendMessage(watchData, replyHandler: {
                            (replyMessage) in
                            print("Got a reply from the phone: \(replyMessage)")
                            
                            // handle reply message here
                            
                        }, errorHandler: { (error) in
                            print("Got an error sending to the phone: \(error)")
                            //watchSession.transferCurrentComplicationUserInfo(watchData)
                        })
                        
                    }
                    else {
                        return; //not interesting // watchSession.transferUserInfo(watchData)
                    }
                    result(true)
                default:
                    result(FlutterMethodNotImplemented)
                }
            })
            
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    
    override func application(
         _ application: UIApplication,
         didReceiveRemoteNotification userInfo: [AnyHashable : Any],
         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
     ){
         print("diRcvRemoteNote")
         let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

                let notificationChannel = FlutterMethodChannel(name: "bladenightbgnotificationchannel",
                                                         binaryMessenger: controller.binaryMessenger)
         
         //print(userInfo)
         var notificationData:NSMutableDictionary
         if let custom = userInfo["custom"] as? NSDictionary {
              if let data = custom["a"] as? NSDictionary {
                  notificationData = data.mutableCopy() as! NSMutableDictionary

                  if(data["category"] as? String == "MESSAGESTATUS"){
                      notificationChannel.invokeMethod("getSilentLastSeenMessage", arguments: notificationData)
                  }

          }}
     }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        //print("Watch reachability: \(session.isReachable)")
        if (session.isReachable) {
            //invoke sendWakeupToFlutter via MethodChannel when reachability is true
            DispatchQueue.main.async {
                if let controller = self.window?.rootViewController as? FlutterViewController {
                    let channel = FlutterMethodChannel(
                        name: self.methodChannelName,
                        binaryMessenger: controller.binaryMessenger)
                    channel.invokeMethod("sendWakeupToFlutter", arguments: [])
                }
            }
        }
    }
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession sessionDidBecomeInactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession sessionDidDeactivate")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let method = message["method"] as? String, let controller = self.window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(
                    name: "bladenightchannel",
                    binaryMessenger: controller.binaryMessenger)
                channel.invokeMethod(method, arguments: message)
                
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            //print("Data applicationContext Received \(applicationContext)")
            //self.initFlutterChannel()
            if let method = applicationContext.keys.first, let controller = self.window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(
                    name: "bladenightchannel",
                    binaryMessenger: controller.binaryMessenger)
                channel.invokeMethod("sendWakeupToFlutter", arguments: [])
                channel.invokeMethod(method, arguments: applicationContext[method])
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            //print("Data didReceiveUserInfo Received \(userInfo)")
            //self.initFlutterChannel()
            if let method = userInfo.keys.first, let controller = self.window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(
                    name: "bladenightchannel",
                    binaryMessenger: controller.binaryMessenger)
                channel.invokeMethod("sendWakeupToFlutter", arguments:  [String : Any]() )
                channel.invokeMethod(method, arguments: userInfo[method])
            }
        }
    }
    
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        DispatchQueue.main.async {
            //print("Data didReceiveMessageData \(messageData)")
        }
    }
    
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        //inform sender about successfull tansfer
    }
}

