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
        record.setObject(tmpImage(crumb.author?.avatar), forKey: "author_avatar")
        record.setObject(tmpImage(crumb.image), forKey: "image")
        return record
    }
    
    private func tmpImage(image: UIImage?)->CKAsset? {
        if let image = image {
            let path = NSTemporaryDirectory().stringByAppendingPathComponent("\(NSDate.timeIntervalSinceReferenceDate()*1000.0).jpg")
            let url = NSURL(fileURLWithPath: path)!
            UIImageJPEGRepresentation(image, 1).writeToFile(url.path!, atomically: true)
            return CKAsset(fileURL: url)
        } else {
            return nil
        }
    }
    
    private func recordToCrumb(record: CKRecord)->Result<Crumb> {
        if let text = record.objectForKey("text") as? String?,
            location = record.objectForKey("location") as? CLLocation,
            authorName = record.objectForKey("author") as? String? {
                var author: User? = nil
                if let name = authorName {
                    if let url = record.objectForKey("author_avatar") as? CKAsset,
                        data = NSData(contentsOfURL: url.fileURL),
                        image = UIImage(data: data) {
                            author = User(name: name, avatar: image)
                    } else {
                        author = User(name: name, avatar: nil)
                    }
                }
                let crumb: Crumb
                if let url = record.objectForKey("image") as? CKAsset,
                    data = NSData(contentsOfURL: url.fileURL),
                    image = UIImage(data: data) {
                        crumb = Crumb(location: location, text: text, image: image, author: author)
                } else {
                    crumb = Crumb(location: location, text: text, author: author)
                }
                return .Success(Box(crumb))
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