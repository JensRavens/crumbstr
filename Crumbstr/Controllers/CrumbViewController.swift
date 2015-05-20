//
//  CrumbViewController.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import Foundation
import Interstellar
import CoreLocation

public final class CrumbViewController: UIViewController, UIScrollViewDelegate {
    var crumb = Signal<Crumb>()
    
    @IBOutlet var avatarView: UIImageView?
    @IBOutlet var userLabel: UILabel?
    @IBOutlet var crumbLabel: UILabel?
    @IBOutlet var crumbImage: UIImageView?
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.sharedService.startUpdates()
        crumb.next(displayCrumb)
    }
    
    private func displayCrumb(crumb: Crumb) {
        userLabel?.text = crumb.author?.name
        crumbLabel?.text = crumb.text
        avatarView?.image = crumb.author?.avatar
        crumbImage?.image = crumb.image
        if let image = crumb.image {
            crumbImage?.hidden = false
        } else {
            crumbImage?.hidden = true
        }
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -80 {
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

func takeFirst<T>(crumbs: [T])->Result<T> {
    if let crumb = crumbs.first {
        return .Success(Box(crumb))
    } else {
        return .Error(NSError())
    }
}
