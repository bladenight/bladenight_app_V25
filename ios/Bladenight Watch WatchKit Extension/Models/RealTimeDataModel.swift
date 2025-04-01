//
//  RealTimeDataModel.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 21.08.22.
//

import Foundation
import MapKit

let  defaultLatitude :Double = 48.13250913196827;
let  defaultLongitude:Double = 11.543837661522703;
let  defaultLatLng:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: defaultLatitude, longitude: defaultLongitude);

struct RealtimeUpdate: Codable {
    var head: MovingPoint?
    var tail: MovingPoint?
    var user: MovingPoint?
    var runningLength: Double?
    var routeName:String
    var tracker:String?
    var usr:String?
    var eventStatus:String?
    
    enum CodingKeys: String, CodingKey {
        case head = "hea"
        case tail = "tai"
        case user = "up"
        case runningLength = "rle"
        case routeName = "rna"
        case tracker = "ust"
        case eventStatus = "sts"
    }
    
    func getLocations() -> [Location] {
        var headLatLng:CLLocationCoordinate2D
        var tailLatLng:CLLocationCoordinate2D
        
        if self.head?.lat == nil || self.head?.lat == 0.0 {
            headLatLng = CLLocationCoordinate2D(latitude: defaultLatitude,longitude:  defaultLongitude)
        }
        else {
            headLatLng = CLLocationCoordinate2D(latitude: self.head?.lat ?? defaultLatitude, longitude:  self.head?.lon ?? defaultLongitude)
        }
        
        if self.tail?.lat == nil || self.tail?.lat == 0.0 {
            tailLatLng = CLLocationCoordinate2D(latitude: defaultLatitude,longitude:  defaultLongitude)
        }
        else {
            tailLatLng = CLLocationCoordinate2D(latitude: self.tail?.lat ?? defaultLatitude, longitude:  self.tail?.lon ?? defaultLongitude)
        }
        
        
        
        return [
            Location(
                locName: "Zugkopf",
                locCoordinate: headLatLng,
                color: .green,
                speed: ""
            ),
            Location(
                locName: "Zugende",
                locCoordinate:tailLatLng,
                color: .orange,
                speed: ""
            ),
            
            
        ]
        
    }
}

extension RealtimeUpdate{
    func timeUserToTail() ->Int{
        if (user?.ior ?? false == false || head?.pos ?? 0 == tail?.pos ?? 0){return 0}
        let tailEta = tail?.eta ?? 0;
        let userEta = user?.eta ?? 0;
        if tailEta == 0 {return 0;}
        return -(userEta - tailEta); //show time as positive
    }
    
    func distanceOfUserToTail() ->Int{
        if (user?.ior ?? false == false || head?.pos ?? 0 == tail?.pos ?? 0){return 0}
        let tailPos = tail?.pos ?? 0;
        let userPos = user?.pos ?? 0;
        return userPos - tailPos; //show time as positive
    }
    
    func timeUserToHead() ->Int{
        if (user?.ior ?? false == false || head?.pos ?? 0 == tail?.pos ?? 0){return 0}
        let headEta = head?.eta ?? 0;
        let userEta = user?.eta ?? 0;
        if headEta == 0 {return 0;}
        return userEta - headEta; //show time as positive
    }
    
    func distanceOfUserToHead() ->Int{
        if (user?.ior ?? false == false || head?.pos ?? 0 == tail?.pos ?? 0){return 0}
        let headPos = head?.pos ?? 0;
        let userPos = user?.pos ?? 0;
        return headPos - userPos; //show time as positive
    }
    
    
    func distanceOfTrainComplete() ->Int{
        let tailPos = tail?.pos ?? 0;
        let headPos = head?.pos ?? 0;
        return headPos - tailPos;
    }
    
     func timeOfTrainComplete() ->Int{
         if (head?.pos == tail?.pos) {return 0;}
         let tailEta = tail?.eta ?? 0;
         let headEta = head?.eta ?? 0;
         if (tailEta == 0) {return 0;}
         return tailEta - headEta;
    }
    
    func userProgress() ->Double{
        let userpos = Double(user?.pos ?? 0)
        if (runningLength == nil || runningLength == 0) {return 0.00}
        return userpos/runningLength!;
    }
    
    func getRealUserSpeed() -> String{
        let userRsp = Double(user?.rsp ?? 0.0)
        return String(format: "%.1f km/h",userRsp)
    }
    
    func getTrackers() -> String{
        return tracker ?? "-";
    }
}

struct MovingPoint: Codable {
    let pos: Int?
    let spd: Int?
    let rsp: Double?
    let eta: Int?
    let ior: Bool?
    let iip: Bool?
    let lat: Double?
    let lon: Double?
    let acc: Double?
    
    
}

struct UserLocationPoint: Codable {
    let lat: Double
    let lon: Double
    let spd: String
   }



/*  @MappableField(key: 'fri')
 final FriendsMessage friends;
 */

