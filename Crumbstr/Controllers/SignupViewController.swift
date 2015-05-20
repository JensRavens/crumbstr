//
//  SignupViewController.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import UIKit

public final class SignupViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let userService = UserService.sharedService
    @IBOutlet var nameField: UITextField?
    @IBOutlet var avatarField: UIImageView?
    
    @IBAction public func selectAvatar(){
        let vc = UIImagePickerController()
        vc.delegate = self
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction public func signup() {
        let image = CrumbService.tmpImage(avatarField?.image)
        let user = User(name: (nameField?.text)!, avatarUrl: image)
        userService.login(user)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public override func viewDidLoad() {
        navigationItem.rightBarButtonItem?.enabled = false
        nameField?.typingSignal.next { name in
            if count(name) > 3 {
                self.navigationItem.rightBarButtonItem?.enabled = true
            } else {
                self.navigationItem.rightBarButtonItem?.enabled = false
            }
        }
    }
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        avatarField?.image = image.resize(160)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}