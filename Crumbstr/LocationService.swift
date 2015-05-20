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
    public static let sharedService = LocationService()
    
    public let location = Signal<CLLocation>()
    public let heading = Signal<CLHeading>()
    
    private let locationManager = CLLocationManager()
    
    public func startUpdates() {
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = 60
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingHeading()
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let locations = locations as! [CLLocation]
        if let location = locations.first {
            println(location)
            self.location.update(.Success(Box(location)))
        }
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        heading.update(.Success(Box(newHeading)))
    }
    
    public func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        location.update(.Error(error))
        heading.update(.Error(error))
    }
    
    public func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch(status){
        case .AuthorizedAlways: manager.startUpdatingLocation()
        case .AuthorizedWhenInUse: manager.startUpdatingLocation()
        default:()
        }
    }
}
