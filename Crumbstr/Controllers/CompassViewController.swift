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
import Social

func location(crumb: Crumb) -> CLLocation {
    return crumb.location
}

class CompassViewController: UIViewController {
    let currentLocation = LocationService.sharedService.location
    var nearestCrumb: Signal<Crumb>!
    var nearbyCrumbs: Signal<[Crumb]>!
    var targetLocation: Signal<CLLocation>!

    @IBOutlet var compassView: CompassView!
    @IBOutlet var hideButtonConstraint: NSLayoutConstraint!
    
    @IBAction func postCrumb() {
        let vc = PostViewController()
        vc.modalPresentationStyle = .OverCurrentContext
        presentViewController(vc, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyCrumbs = CrumbService.sharedService.search(currentLocation)
        nearestCrumb = nearbyCrumbs.bind(takeFirst)
        targetLocation = nearestCrumb.map(location)
        
        currentLocation.merge(targetLocation).next(compassView.locationsDidChange)
        
        nearestCrumb.bind(isNearby).next { crumb in
            UIView.animateWithDuration(0.5){
                self.hideButtonConstraint.active = false
            }
        }
        
        nearestCrumb.bind(isNearby).error { error in
            UIView.animateWithDuration(0.5){
                self.hideButtonConstraint.active = true
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let user = UserService.sharedService.user.peek() {
            
        } else {
            performSegueWithIdentifier("signup", sender: self)
        }
    }
    
    func isNearby(crumb: Crumb) -> Result<Crumb> {
        if let location = currentLocation.peek() {
            if location.distanceFromLocation(crumb.location) < 40 {
                return .Success(Box(crumb))
            } else {
                return .Error(NSError())
            }
            
        } else {
            return .Error(NSError())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return nearestCrumb.peek() != nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dst = segue.destinationViewController as? CrumbViewController {
            dst.crumbs.update(Result.Success(Box(nearbyCrumbs.peek()!)))
        }
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
