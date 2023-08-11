//
//  handleReceivedConnectivityData.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 31.08.22.
//

import Foundation
import WatchConnectivity
import MapKit

extension CommunicationHandler{
    func handleIncomingMessages(message: [String : Any]){
        DispatchQueue.main.async {
            print("handleIncomingMessages: \(message)")
            guard let method = message["method"] as? String, let enumMethod = WatchReceiveMessageMethod(rawValue: method) else {
                return
            }
            let myFormat = Date.FormatStyle()
                .year()
                .day(.twoDigits)
                .month(.twoDigits)
                .hour()
                .minute()
                .second()
            switch enumMethod {
            case .setActiveEventDate:
                self.activeEventRouteDate = (message["data"] as? String) ?? "-"
                break
            case .setActiveEventStatusText:
                self.activeEventRouteStatusText = (message["data"] as? String) ?? "-"
                break
            case .setActiveEventName:
                self.activeEventRouteName = (message["data"] as? String) ?? "-"
                break
            case .setConfirmationStatus:
                let nr = message["data"] as? NSNumber ?? 0;
                if nr == 1 {
                    self.confirmationStatus = true;
                }
                else{
                    self.confirmationStatus = false;
                }
                break
            case .setIsLocationTracking:
                let nr = message["data"] as? NSNumber ?? 0;
                if nr == 1 {
                    self.isLocationTracking = true;
                }
                else{
                    self.isLocationTracking = false;
                }
                //self.message += "\(nr) " + " - " + "\(self.isLocationTracking) \(message)\n"
                break
            case .setElapsedDistanceLength:
                self.elapsedDistanceLength = (message["data"] as? String) ?? "-"
                break
            case .setRoutePoints:
                let jsonString = (message["data"] as? String);
                do{
                    NSLog ("setRoutePoints received \(String(describing: jsonString))")
                    let decoder=JSONDecoder();
                    if jsonString == nil {break;}
                    else{
                        let bytes: Data = jsonString?.data(using: .utf8, allowLossyConversion: false) ?? Data()
                        let  routePoints = try decoder.decode(RoutePoints.self, from: bytes)
                        NSLog("setRoutePoints from json \(routePoints)")
                    }
                }
                catch {
                    NSLog("fatalerror  setRoutePoints \(error)")
                    
                }
                break
            case .setRunningLength:
                self.runningLength = (message["data"] as? String) ?? "-"
                break
            case .setUserSpeed:
                self.userSpeed = (message["data"] as? String) ?? "- km/h"
                break
            case .updateEvent:
                do{
                    let jsonString = (message["data"] as? String);
                    let decoder=JSONDecoder();
                    if jsonString == nil {break;}
                    
                    else{
                        self.message += (jsonString ?? "--")
                        let bytes: Data = jsonString?.data(using: .utf8, allowLossyConversion: false) ?? Data()
                        let  data = try decoder.decode(WatchEvent.self, from: bytes)
                        self.activeEvent = data
                        self.updateEventDataLastUpdate = Date.now.formatted(myFormat)
                    }
                }
                catch {
                    NSLog("\(Date()) fatalerror updateFriends \(error)")
                    //self.message += error.localizedDescription
                }
                break
            case .updateUserLocationData:
                let jsonString = (message["data"] as? String);
                do{
                    debugPrint ("updateUserLocationData received \(String(describing: jsonString))")
                    let decoder=JSONDecoder();
                    if jsonString == nil {break;}
                    else{
                        let bytes: Data = jsonString?.data(using: .utf8, allowLossyConversion: false) ?? Data()
                        let  usrData = try decoder.decode(MovingPoint.self, from: bytes)
                        
                        let userlat: Double = Double(usrData.lat ?? defaultLatitude);
                        let userlon: Double = Double(usrData.lon ?? defaultLongitude);
                        
                        self.userlocation=Location(locName: "Ich", locCoordinate: CLLocationCoordinate2D(latitude: userlat, longitude: userlon),color: .yellow)
                        if self.locations.isEmpty{
                            self.locations.append(self.userlocation!)
                        }
                        else{
                            self.locations[0] = self.userlocation!
                        }
                        NSLog ("updateUserLocationData locations received \(self.locations)")
                        
                    }
                }
                catch {
                    NSLog("fatalerror  updateUserLocationData \(error)")
                  
                }
                break
            case .updateRealtimeData:
                let jsonString = (message["data"] as? String);
                do{
                    let decoder=JSONDecoder();
                    if jsonString == nil {break;}
                    else{
                        let bytes: Data = jsonString?.data(using: .utf8, allowLossyConversion: true) ?? Data()
                        let  rtData = try decoder.decode(RealtimeUpdate.self, from: bytes)
                        self.realTimeData = rtData
                        let userpos: Double = Double(rtData.user?.pos ?? 0);
                        if rtData.runningLength != nil && rtData.runningLength != 0{
                            self.progress = userpos / (rtData.runningLength ?? 0.01)
                        }
                        
                        if self.locations.count<3{
                            if self.locations.isEmpty{
                                self.locations.append(self.userlocation ?? Location(locName: "User", locCoordinate: CLLocationCoordinate2DMake(defaultLongitude, defaultLatitude),color: .yellow))
                                
                            }
                            self.locations.append(self.userlocation ?? Location(locName: "Head", locCoordinate: CLLocationCoordinate2DMake(defaultLongitude, defaultLatitude),color: .green))
                            self.locations.append(self.userlocation ?? Location(locName: "Tail", locCoordinate: CLLocationCoordinate2DMake(defaultLongitude, defaultLatitude),color: .orange))
                        }
                        let headAndTailLoc = self.realTimeData.getLocations();
                        self.locations[1] = headAndTailLoc[0];
                        self.locations[2] = headAndTailLoc[1];
                        
                        self.realTimeDataLastUpdate = Date.now.formatted(myFormat)
                    }
                    debugPrint("updateRealtimeData locations received \(self.locations)")
                    
                }
                catch {
                    NSLog("fatalerror updateRealtimeData \(error)")
                    self.message+="error rtup"+error.localizedDescription
                }
                break
            case .updateFriends:
                do{
                    
                    let jsonString = (message["data"] as? String);
                    //jsonString = "[{\"name\":\"Lars Note 10\",\"friendid\":36,\"color\":\"#d29046\",\"isActive\":true,\"requestId\":0,\"isOnline\":true,\"speed\":0,\"longitude\":11.5285279,\"latitude\":48.16475,\"relativeTime\":0,\"relativeDistance\":0,\"absolutePosition\":0,\"distanceToUser\":0,\"timeToUser\":0,\"timestamp\":1662228522255,\"hasServerEntry\":true}]"
                    let decoder=JSONDecoder();
                    if jsonString == nil {break;}
                    
                    else{
                        self.message += (jsonString ?? "--")
                        let bytes: Data = jsonString?.data(using: .utf8, allowLossyConversion: false) ?? Data()
                        let  data = try decoder.decode([Friend].self, from: bytes)
                        //self.message += "\nfriends decoded"
                        self.friends = data
                        
                    }
                    self.friendDataLastUpdate = Date.now.formatted(myFormat)
                }
                catch {
                    NSLog("\(Date()) fatalerror updateFriends \(error)")
                    //self.message += error.localizedDescription
                }
                break
            case .phoneAppWillTerminate:
                resetData()
                self.infoText = "App was terminated";
                break
            }
        }
        
        func resetData(){
            self.realTimeData = RealtimeUpdate( routeName: "")
            self.runningLength = "-"
            self.progress = 0.0
            self.friends = [Friend]()
            self.isLocationTracking = false
            self.isLocationTracking=false;
            self.locations=[Location]()
        }
    }
}
