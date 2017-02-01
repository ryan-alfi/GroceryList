//
//  Grocery+CoreDataProperties.swift
//  GroceryDemo
//
//  Created by iMac on 1/31/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import Foundation
import CoreData


extension Grocery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery");
    }

    @NSManaged public var item: String?
    @NSManaged public var itemId: NSNumber?

}
