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
import CloudKit

let CloudKitContainerIdentifier = "iCloud.berlin.swift.Crumbster"

public class CrumbService {
    let cloudDatabase = CKContainer(identifier: CloudKitContainerIdentifier).publicCloudDatabase
    
    public func search(location: Signal<CLLocation>)->Signal<[Crumb]> {
        let signal = Signal<[Crumb]>()
        
        return signal;
    }
    
    public func createCrumb(crumb: Crumb, completion: (Result<Crumb> -> Void)) {
        cloudDatabase.saveRecord(crumbToRecord(crumb)){ record, error in
            if let error = error {
                completion(.Error(error))
            } else {
                completion(.Success(Box(crumb)))
            }
            return
        }
    }
    
    private func requestCrumbs(location: CLLocation, completion: (Result<[Crumb]>->Void)) {
        let query = CKQuery(recordType: "Crumb", predicate: NSPredicate(value: true))
        cloudDatabase.performQuery(query, inZoneWithID: nil){ crumbRecords, error in
            if let error = error {
                completion(.Error(error))
            } else {
                let crumbs = self.compact((crumbRecords as! [CKRecord]).map(self.recordToCrumb))
                completion(.Success(Box(crumbs)))
            }
        }
    }
    
    private func crumbToRecord(crumb: Crumb)->CKRecord {
        let record = CKRecord(recordType: "Crumb")
        record.setObject(crumb.text, forKey: "text")
        record.setObject(crumb.location, forKey: "location")
        return record
    }
    
    private func recordToCrumb(record: CKRecord)->Result<Crumb> {
        if let text = record.objectForKey("text") as? String,
            location = record.objectForKey("location") as? CLLocation {
                return .Success(Box(Crumb(location: location, text: text)))
        } else {
            return .Error(NSError(domain: "Parsing", code: 421, userInfo: nil))
        }
    }
    
    private func compact<T>(array: [Result<T>]) -> [T] {
        return compact(array.map({$0.value}))
    }
    
    private func compact<T>(array: [T?]) -> [T] {
        var items: [T] = []
        for i in array {
            if let i = i {
                items.append(i)
            }
        }
        return items
    }
    
}