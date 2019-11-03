//
//  Article+CoreDataProperties.swift
//  adventure
//
//  Created by Mike Budei on 11/1/19.
//  Copyright © 2019 Mike Budei. All rights reserved.
//
//

import Foundation
import CoreData

extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var id: String?
    @NSManaged public var post: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var country: Country?

}
