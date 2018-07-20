//
//  Photo+CoreDataProperties.swift
//  NewsAPITest
//
//  Created by Martin Grincevschi on 19.07.2018.
//  Copyright © 2018 Martin Grincevschi. All rights reserved.
//


import Foundation
import CoreData


extension Article {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "urlToImage");
    }
    
    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var mediaURL: String?
    
}
