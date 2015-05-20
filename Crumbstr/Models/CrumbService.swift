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

let CloudKitContainerIdentifier = "iCloud.berlin.swift.Crumbstr"

public class CrumbService {
    private let cloudDatabase = CKContainer(identifier: CloudKitContainerIdentifier).publicCloudDatabase
    
    public static let sharedService = CrumbService()
    
    public func search(location: Signal<CLLocation>)->Signal<[Crumb]> {
        return location.bind(requestCrumbs).ensure(Thread.main);
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
        record.setObject(crumb.author?.name, forKey: "author")
        return record
    }
    
    private func recordToCrumb(record: CKRecord)->Result<Crumb> {
        if let text = record.objectForKey("text") as? String?,
            location = record.objectForKey("location") as? CLLocation,
            authorName = record.objectForKey("author") as? String? {
                var author: User? = nil
                if let name = authorName {
                    author = User(name: name, avatar: nil)
                }
                return .Success(Box(Crumb(location: location, author: author, text: text)))
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