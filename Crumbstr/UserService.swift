//
//  UserService.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import Foundation
import Interstellar
import CloudKit

public class UserService {
    public static let sharedService = UserService()
    
    public let user = Signal<User>()
    
    private let defaults = NSUserDefaults(suiteName: "group.crumbstr")!
    
    init() {
        loadUser()
    }
    
    public func login(user: User){
        self.user.update(.Success(Box(user)))
        if let url = user.avatarUrl {
            defaults.setObject(NSData(contentsOfURL: url), forKey: "user_image")
        } else {
            defaults.removeObjectForKey("user_image")
        }
        defaults.setObject(user.name, forKey: "user_name")
        defaults.synchronize()
    }
    
    private func loadUser() {
        if let name = defaults.objectForKey("user_name") as? String {
            if let data = defaults.objectForKey("user_image") as? NSData,
                image = UIImage(data: data){
                let url = CrumbService.tmpImage(image)
                user.update(.Success(Box(User(name: name, avatarUrl: url))))
            } else {
                user.update(.Success(Box(User(name: name, avatarUrl: nil))))
            }
        }
    }
}