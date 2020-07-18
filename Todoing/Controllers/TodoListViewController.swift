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
    
    var selectedCategory : Category? { // this execute when a category selected
        didSet{
            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // here UIApplication.shared is use to create object from AppDelegate class method

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
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
            newItem.parentCategory = self.selectedCategory
            
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
    
    // here with is external paramerer and request is internal parameter
    // here we assign default value of with: parameter as item.fetchRequest() to load whole data in to viewcontroller
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // to read data from Item entity
        //let request:NSFetchRequest<Item> = Item.fetchRequest()
        
        // to fetch data for selected category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate ,predicate])
//
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fatching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    

}

//MARK:- search bar
// this extension use when too much delegate are added with same class this is extension of above class
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // [cd] c is for CASE sensitive and d is for diacritic sensitive
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)  // %@ use for any argument pass in
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)  // here with is external parameter for loadItem
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // dispatchQueue is prioritize process so it manage thread for app works
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()  // this is to stop cursor and lower key board
            }
            
            
        }
    }
    
}
