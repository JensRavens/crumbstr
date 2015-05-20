//
//  CrumbCell.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import UIKit

public final class CrumbCell: UITableViewCell {
    @IBOutlet var avatarView: UIImageView?
    @IBOutlet var userLabel: UILabel?
    @IBOutlet var crumbLabel: UILabel?
    @IBOutlet var crumbImage: UIImageView?
    
    public func displayCrumb(crumb: Crumb) {
        userLabel?.text = crumb.author?.name
        crumbLabel?.text = crumb.text
        if let url = crumb.author?.avatarUrl, data = NSData(contentsOfFile: url.path!) {
            avatarView?.image = UIImage(data: data)
        } else {
            avatarView?.image = nil
        }
        
        if let url = crumb.imageUrl, data = NSData(contentsOfFile: url.path!) {
            crumbImage?.image = UIImage(data: data)
        } else {
            crumbImage?.image = nil
        }
        
        if let image = crumb.imageUrl {
            crumbImage?.hidden = false
        } else {
            crumbImage?.hidden = true
        }
    }
}
