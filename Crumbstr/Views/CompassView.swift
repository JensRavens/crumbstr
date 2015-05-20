//
//  CompassView.swift
//  Crumbstr
//
//  Created by Tom König on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import Interstellar

class CompassView: UIView {
    var currentLocation: CLLocation = CLLocation()
    var currentAngle: Double = 0
    var angleBetweenNorthAndTarget: Double = 0
    var targetLocation: CLLocation = CLLocation()
    var displayLink: CADisplayLink!
    var displayLinkDuration: CFTimeInterval

    @IBOutlet weak var compassImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        displayLinkDuration = 0
        super.init(coder: aDecoder)
        startAnimation()
        bindCompass()
    }
    
    // MARK: - Private Methods
    
    func bindCompass() {
        LocationService.sharedService.heading.next { heading in
            self.currentAngle = self.degreesToRadians(self.normalizeHeading(heading.magneticHeading)) +
                                self.angleBetweenNorthAndTarget
        }
    }
    
    func normalizeHeading(source: Double) -> Double {
        var target = 0.0
        
        if (source >= 360) {
            return normalizeHeading(source - 360.0)
        }
        
        if (target > 180) {
            target = 360.0 - source
        } else {
            target = 0.0 - source
        }
        
        return target
    }
    
    func angleBetweenNorthAndTarget(target: CLLocation) -> Double {
        let currentLatitude = degreesToRadians(currentLocation.coordinate.latitude)
        let currentLongitude = degreesToRadians(currentLocation.coordinate.longitude)
        
        let targetLatitude = degreesToRadians(targetLocation.coordinate.latitude)
        let targetLongitude = degreesToRadians(targetLocation.coordinate.longitude)
        
        let longitudeDifference = targetLongitude - currentLongitude
        
        let y = sin(longitudeDifference) * cos(targetLatitude)
        let x = cos(currentLatitude) * sin(targetLatitude) -
                sin(currentLatitude) * cos(targetLatitude) * cos(longitudeDifference);
        var radiansValue = atan2(y, x);
        
        return radiansValue;
    }
    
    func locationsDidChange(locations: (currentLocation: CLLocation, targetLocation: CLLocation)) {
        currentLocation = locations.currentLocation
        targetLocation = locations.targetLocation
        self.distanceLabel.text = "\(currentDistanceToTarget()) m"
        angleBetweenNorthAndTarget = angleBetweenNorthAndTarget(targetLocation)
    }
    
    // MARK: - Location services
    
    func radiansToDegrees(radians: Double) -> Double {
        return radians * (180.0 / M_PI)
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * (M_PI / 180.0)
    }
    
    func currentDistanceToTarget() -> Int {
        return Int(targetLocation.distanceFromLocation(currentLocation))
    }
    
    // MARK: - Display Link
    
    func startAnimation() {
        displayLink = CADisplayLink(target: self, selector: Selector("initializeDisplayLink"))
        displayLink.frameInterval = 1
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }

    func initializeDisplayLink() {
        if (displayLinkDuration <= 0) {
            var duration = displayLink.duration
            displayLink.paused = true
            displayLink = CADisplayLink(target: self, selector: Selector("tick"))
            displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            displayLinkDuration = duration
        }
    }
    
    func tick() {
        compassImage.transform = CGAffineTransformMakeRotation(CGFloat(currentAngle))
    }
}
