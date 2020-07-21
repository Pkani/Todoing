//
//  ViewController.swift
//  Todoing
//
//  Created by Artixun on 7/13/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    
    var todoItems: Results<Item>?   // array of Item objects
    let realm = try! Realm()
    
    // selectedCategory executed from category view controller
    var selectedCategory : Category? { // this execute when a category selected
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    // MARK: Swipe Action and related UI
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let important = importantAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete, important])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completionAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [complete])
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        let item = self.todoItems?[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "important") { (action, view, completion) in
            if let item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        item.isImportant = !item.isImportant
                        
                    }
                }catch {
                    print("Error saving done status \(error)")
                }
            }
            completion(true)
        }
        action.image = UIImage(named: "Archive Icon")
        action.backgroundColor = (item!.isImportant) ? .purple : .gray
        return action
    }
    
    
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if let item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)   // to delete items
                    }
                }catch {
                    print("Error saving done status \(error)")
                }
            }
            completion(true)
        }
        action.image = UIImage(named: "Trash Icon")
        action.backgroundColor = .red
        return action
    }
    
    func completionAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, completion) in
//            let strike = self.todoItems?[indexPath.row].title
            
//            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: strike!)
//            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            self.todoItems?[indexPath.row].title = attributeString.attributedText
            if let item = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)   // to delete items
                    }
                }catch {
                    print("Error saving done status \(error)")
                }
            }
            completion(true)
        }
        action.image = UIImage(named: "Flag Icon")
        action.backgroundColor = .green
        return action
    }
 
    //MARK:- TableView Delegate method
    // following function is use for which row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    
                    //realm.delete(item)   // to delete items
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status \(error)")
            }

        }
        
        tableView.reloadData()
        //print(itemArray[indexPath.row])

//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done // work same as above if else code

//        context.delete(itemArray[indexPath.row])  // this delete data from source
//        itemArray.remove(at: indexPath.row)  // this load up the data source and remove item from item array
        
        //saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoing Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            // what will happen once user click on the Add Item button
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }

            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK:- Model Manupulation Methods
//    func saveItems(item: Item) {
//
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("Error saving context \(error)")
//        }
//
//        // to get new data into itemArray
//        tableView.reloadData()
//    }
    
    // here with is external paramerer and request is internal parameter
    // here we assign default value of with: parameter as item.fetchRequest() to load whole data in to viewcontroller
    func loadItems() { // to read data from Item entity

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    

}

//MARK:- search bar
// this extension use when too much delegate are added with same class this is extension of above class
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // [cd] c is for CASE sensitive and d is for diacritic sensitive
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // [cd] c is for CASE sensitive and d is for diacritic sensitive
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)  // %@ use for any argument pass in
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)  // here with is external parameter for loadItem
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

