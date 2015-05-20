//
//  LocationService.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import Foundation
import Interstellar
import CoreLocation

public class LocationService : NSObject, CLLocationManagerDelegate {
    public static var sharedService = LocationService()
    
    public let signal = Signal<CLLocation>()
    
    private let locationManager = CLLocationManager()
    
    public func startUpdates() {
        locationManager.requestAlwaysAuthorization()
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let locations = locations as! [CLLocation]
        if let location = locations.first {
            signal.update(.Success(Box(location)))
        }
    }
    
    public func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        signal.update(.Error(error))
    }
    
    public func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch(status){
        case .AuthorizedAlways: manager.startUpdatingLocation()
        case .AuthorizedWhenInUse: manager.startUpdatingLocation()
        default:()
        }
    }
}
