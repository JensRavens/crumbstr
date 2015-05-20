//
//  CrumbViewController.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import Foundation
import Interstellar

public final class CrumbViewController: UIViewController, UIScrollViewDelegate {
    var crumb: Crumb! = Crumb.example()
    
    @IBOutlet var avatarView: UIImageView?
    @IBOutlet var userLabel: UILabel?
    @IBOutlet var crumbLabel: UILabel?
    @IBOutlet var crumbImage: UIImageView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        userLabel?.text = crumb.author?.name
        crumbLabel?.text = crumb.text
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -80 {
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
