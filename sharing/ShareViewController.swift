//
//  ShareViewController.swift
//  sharing
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import UIKit
import Social
import Interstellar
import MobileCoreServices

public class ShareViewController: SLComposeServiceViewController {

    let location = LocationService.sharedService.location.ensure(Thread.main)
    let user = UserService.sharedService.user
    var selectedImage: UIImage! = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.sharedService.startUpdates()
        location.subscribe { result in
            self.validateContent()
        }
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as String
        
        for attachment in content.attachments as! [NSItemProvider] {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                
                attachment.loadItemForTypeIdentifier(contentType, options: nil) { data, error in
                    if error == nil {
                        let url = data as! NSURL
                        if let imageData = NSData(contentsOfURL: url) {
                            self.selectedImage = UIImage(data: imageData)?.resize(500)
                        }
                    }
                }
            }
        }

    }
    
    public override func didSelectPost() {
        let url = CrumbService.tmpImage(self.selectedImage)
        let crumb = Crumb(location: location.peek()!, text: contentText, image: url, author: user.peek())
        CrumbService.sharedService.createCrumb(crumb) { result in }
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }
}
