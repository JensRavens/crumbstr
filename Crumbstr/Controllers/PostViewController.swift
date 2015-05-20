//
//  PostViewController.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import Foundation

import Foundation
import Interstellar
import CoreLocation
import Social

public class PostViewController: SLComposeServiceViewController {
    let location = LocationService.sharedService.location.ensure(Thread.main)
    let user = UserService.sharedService.user
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        location.subscribe { result in
            self.validateContent()
        }
    }
    
    public override func didSelectPost() {
        let crumb = Crumb(location: location.peek()!, text: contentText, author: user.peek()!)
        CrumbService.sharedService.createCrumb(crumb) { result in }
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    public override func didSelectCancel() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public override func isContentValid() -> Bool {
        return count(contentText)>3 && location.peek() != nil && user.peek() != nil
    }
}