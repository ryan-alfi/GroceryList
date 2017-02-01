//
//  Grocery+CoreDataClass.swift
//  GroceryDemo
//
//  Created by iMac on 1/31/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import Foundation
import CoreData


public class Grocery: NSManagedObject {
    
    class func groceryWithData(_ data: [String: Any], inManageObjectContext moc: NSManagedObjectContext) -> Grocery? {
        
        var grocery: Grocery?
        
        let fetchRequest: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "itemId == %@", data["itemId"] as! NSNumber)
        
        do{
            let groceries = try moc.fetch(fetchRequest)
            
            if groceries.count > 0 {
                grocery = groceries[0]
            }else{
                grocery = NSEntityDescription.insertNewObject(forEntityName: "Grocery", into: moc) as? Grocery
                grocery?.itemId = data["itemId"] as? NSNumber
            }
            
            if let item = data["item"] as? String{
                grocery?.item = item
            }
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
        return grocery
    }
    
    class func groceryInManagedObjectContext(_ moc: NSManagedObjectContext) -> [Grocery] {
        let fetchRequest: NSFetchRequest<Grocery> = Grocery.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "itemId", ascending: false)]
        
        do{
            let groceries = try moc.fetch(fetchRequest)
            return groceries
        }catch let err as NSError {
            print(err.localizedDescription)
        }
        
        return []
    }
}
