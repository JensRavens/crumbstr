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
    
    public static func example()->Crumb {
        let author = User(name: "Georg", avatar: nil)
        let location = CLLocation(latitude: 0, longitude: 0)
        return Crumb(location: location, author: author, text: "Here is our very first crumb!")
    }
}

public struct User {
    public let name: String
    public let avatar: UIImage?
}