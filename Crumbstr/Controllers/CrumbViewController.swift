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

public final class CrumbViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource {
    var crumbs = Signal<[Crumb]>()
    
    @IBOutlet var tableView: UITableView?
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        LocationService.sharedService.startUpdates()
//    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crumbs.peek()?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let crumb = crumbs.peek()![indexPath.row]
        let identifier = crumb.imageUrl == nil ? "cell" : "image"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! CrumbCell
        cell.displayCrumb(crumbs.peek()![indexPath.row])
        return cell
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
