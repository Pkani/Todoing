//
//  ViewController.swift
//  Todoing
//
//  Created by Artixun on 7/13/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    var itemArray = [Item]()   // array of Item objects
    // let defaults = UserDefaults.standard // this is a singleton for user default setting
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // this use when we save data in plist file
    // here UIApplication.shared is a singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // here UIApplication.shared is use to create object from AppDelegate class method

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        let newItem = Item()  // new object is created with help of Item class in Data model folder
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggs"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)

        // here items that saved in user default file that loads up when app load
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell") //it forget cell checkmark
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK:- TableView Delegate method
    // following function is use for which row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        // following use to avoid checkmark for reusable cell
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else {
//            itemArray[indexPath.row].done = false
//        }
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // work same as above if else code

//        context.delete(itemArray[indexPath.row])  // this delete data from source
//        itemArray.remove(at: indexPath.row)  // this load up the data source and remove item from item array
        
        saveItems()
        
        
        // following is to use checkmark selected when click and deselected when click again
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoing Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            // what will happen once user click on the Add Item button
            
            

            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray") // add data in user default
            
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK:- Model Manupulation Methods
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // to get new data into itemArray
        tableView.reloadData()
    }
    
    func loadItems() { // to read data from Item entity
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fatching data from context \(error)")
        }
    }
    

}

//MARK:- search bar
// this extension use when too much delegate are added with same class this is extension of above class
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // [cd] c is for CASE sensitive and d is for diacritic sensitive
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)  // %@ use for any argument pass in
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //request.sortDescriptors = [sortDescriptor]
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fatching data from context \(error)")
        }
        tableView.reloadData()
    }
}
