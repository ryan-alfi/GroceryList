//
//  EditingViewController.swift
//  GroceryDemo
//
//  Created by iMac on 1/31/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {

    var tmpText : String?
    var tmpId: Int = 0
    
    @IBOutlet weak var txt_edit: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txt_edit.text = tmpText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let newText = txt_edit.text!
        
        guard newText.characters.count > 0 else{
            return
        }
        
        let data : [String:Any] =  [
            "itemId": tmpId,
            "item": newText
        ]
        
        _ = Grocery.groceryWithData(data, inManageObjectContext: managedContext)
        appDelegate.saveContext()
        
        navigationController?.popViewController(animated: true)
    }
}
