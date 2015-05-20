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
    var targetLocation: CLLocation = CLLocation()
    var displayLink: CADisplayLink!
    var displayLinkDuration: CFTimeInterval

    @IBOutlet weak var compassImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        displayLinkDuration = 0
        super.init(coder: aDecoder)
        startAnimation()
    }
    
    // MARK: - Private Methods
    
    func locationsDidChange(locations: (currentLocation: CLLocation, targetLocation: CLLocation)) {
        currentLocation = locations.currentLocation
        targetLocation = locations.targetLocation
        self.distanceLabel.text = "\(currentDistanceToTarget()) m"
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
        let angle: CGFloat = CGFloat(M_PI)
        compassImage.transform = CGAffineTransformMakeRotation(angle)
    }
}
