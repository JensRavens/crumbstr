//
//  CrumbService.swift
//  Crumbstr
//
//  Created by Jens Ravens on 20/05/15.
//  Copyright (c) 2015 swift.berlin. All rights reserved.
//

import Foundation
import Interstellar
import CoreLocation


public class CrumbService {
    public func search(location: CLLocationCoordinate2D)->Signal<[Crumb]> {
        let signal = Signal<[Crumb]>()
        
        return signal;
    }
    
    
    //MARK: Private stuff
//    
//    private func requestCloutKit {
//        
//    }
//    
//    private func crumbToRecord(crumb: Crumb)->CKRecord {
//        
//    }
    
}