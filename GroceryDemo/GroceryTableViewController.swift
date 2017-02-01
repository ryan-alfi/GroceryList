//
//  GroceryTableViewController.swift
//  GroceryDemo
//
//  Created by iMac on 1/30/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {

    var groceries: [Grocery] = []
    let kName = "item"
    
    var selectedIndex = 0
    
    var recentID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        tableView.reloadData()
    }
    
    func loadData() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //        let fetchRequest =
        //            NSFetchRequest<NSManagedObject>(entityName: "Grocery")
        //
        //        do {
        //            groceries = try managedContext.fetch(fetchRequest)
        //        } catch let error as NSError {
        //            print("Could not fetch. \(error), \(error.userInfo)")
        //        }
        
        groceries = Grocery.groceryInManagedObjectContext(managedContext)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Grocery List", message: "Add Item", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textfield: UITextField) in
            
        }
        
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            guard let textfield = alertController.textFields?.first, let itemToSave = textfield.text else {
                return
            }
            
            let tmpID = self.groceries.first!
            
            if  (tmpID.item?.characters.count)! > 0 {
                self.recentID = (tmpID.value(forKey: "itemId") as? Int)!
                self.recentID += 1
            }else{
                self.recentID = 1
            }

            
            self.save(name: itemToSave)
            
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
//        let entity =
//            NSEntityDescription.entity(forEntityName: "Grocery",
//                                       in: managedContext)!
//        
//        let item = NSManagedObject(entity: entity,
//                                     insertInto: managedContext)
//        
//        item.setValue(name, forKeyPath: kName)
//        
//        do {
//            try managedContext.save()
//            groceries.append(item)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
        
        guard name.characters.count > 0 else{
            return
        }
        
        let data : [String:Any] =  [
            "itemId": NSNumber(value: Int(self.recentID)),
            "item": name
        ]
        
        _ = Grocery.groceryWithData(data, inManageObjectContext: managedContext)
        appDelegate.saveContext()
        
        self.loadData()
        
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groceries.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = groceries[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = list.value(forKey: "item") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
//        if editingStyle == .insert {
//            
//        }
//        
//        if editingStyle == .delete {
//            guard let appDelegate =
//                UIApplication.shared.delegate as? AppDelegate else {
//                    return
//            }
//            
//            appDelegate.managedObjectContext.delete(groceries[indexPath.row])
//            
//            do{
//                try appDelegate.managedObjectContext.save()
//                groceries.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }catch {
//                let saveError = error as NSError
//                print(saveError)
//            }
//            
//        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete") { (action , indexPath ) -> Void in
            self.isEditing = false
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            appDelegate.managedObjectContext.delete(self.groceries[indexPath.row])
            
            do{
                try appDelegate.managedObjectContext.save()
                self.groceries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }catch {
                let saveError = error as NSError
                print(saveError)
            }
            
        }
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit") { (action , indexPath) -> Void in
            self.isEditing = false
            
            self.selectedIndex = indexPath.row
            
            self.performSegue(withIdentifier: "showEdit", sender: self)
            
        }
        
        editAction.backgroundColor = UIColor.blue
        return [deleteAction, editAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEdit" {
            let destination = segue.destination as! EditingViewController
            let list = groceries[selectedIndex]
            destination.tmpId = list.value(forKey: "itemId") as! Int
            destination.tmpText = list.value(forKey: kName) as? String
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
