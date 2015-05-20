//
//  CompassViewController.swift
//  Crumbstr
//
//  Created by Tom König on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import UIKit
import CoreLocation
import Interstellar

class CompassViewController: UIViewController {
    var currentLocation: Signal<CLLocation> = Signal(CLLocation(latitude: 52.50261, longitude: 13.41222))
    var targetLocation: Signal<CLLocation> = Signal(CLLocation(latitude: 52.52192, longitude: 13.41321))

    @IBOutlet var compassView: CompassView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocation.merge(targetLocation).next(compassView.locationsDidChange)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            self.targetLocation.update(.Success(Box(CLLocation(latitude: 52.52202, longitude: 13.41381))))
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
