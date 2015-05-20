//
//  Crumb.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public struct Crumb {
    public let location: CLLocation
    public let author: User?
    public let text: String?
    public let imageUrl: NSURL?
    
    public init(location: CLLocation) {
        self.location = location
        self.text = nil
        self.imageUrl = nil
        self.author = nil
    }
    
    public init(location: CLLocation, text: String?, image:NSURL? = nil, author: User? = nil){
        self.location = location
        self.text = text
        self.author = author
        self.imageUrl = image
    }
    
    public static func example()->Crumb {
        let author = User.example()
        let location = CLLocation(latitude: 0, longitude: 0)
        return Crumb(location: location, text: "Here is our very first crumb!", image: nil, author: author)
    }
}

public struct User {
    public let name: String
    public let avatarUrl: NSURL?
    
    public static func example()->User {
        return User(name: "Georg", avatarUrl: nil)
    }
}