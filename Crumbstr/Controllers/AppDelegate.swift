//
//  AppDelegate.swift
//  Crumbstr
//
//  Created by Jens Ravens on 5/20/15
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        LocationService.sharedService.startUpdates()
        
        return true
    }
}
