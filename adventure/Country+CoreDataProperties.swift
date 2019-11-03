//
//  Country+CoreDataProperties.swift
//  adventure
//
//  Created by Mike Budei on 11/1/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//
//

import Foundation
import CoreData

extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var id: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var thumbnail: Data?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var posts: NSSet?

}

// MARK: Generated accessors for posts
extension Country {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Article)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Article)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
