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
    public let image: UIImage?
    
    public init(location: CLLocation) {
        self.location = location
        self.text = nil
        self.image = nil
        self.author = nil
    }
    
    public init(location: CLLocation, text: String?, image:UIImage? = nil, author: User? = nil){
        self.location = location
        self.text = text
        self.author = author
        self.image = image
    }
    
    public static func example()->Crumb {
        let author = User(name: "Georg", avatar: nil)
        let location = CLLocation(latitude: 0, longitude: 0)
        return Crumb(location: location, text: "Here is our very first crumb!", image: UIImage(named: "UserPlaceholder"), author: author)
    }
}

public struct User {
    public let name: String
    public let avatar: UIImage?
}