//
//  CategotyTableViewController.swift
//  Todoing
//
//  Created by Artixun on 7/17/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategotyTableViewController: UITableViewController {
    
    let realm = try! Realm()  // here try! is for avoid error throw when realm initialize
    
    // result data type auto update so no need to append new category to it
    // ? is use that this optional unwrape and ! is force unwrape
    var categories: Results<Category>?   // results is data type associated with realm
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategory()

    }
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if categories is not nil it uses count and if nil it uses 1
        return categories?.count ?? 1  // Nil coalescing operator
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let newCell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        let newCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //  ?? Nil coalescing operator
        newCell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added." // this mean categories? optional is not nil we get the item indexPath.row but if it is nil (??) we use "No categories added."
        
        return newCell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
    
    // MARK: Swipe action
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if let category = self.categories?[indexPath.row] {  // here ? is use for optional as we defined above that categories is optional
                do {
                    try self.realm.write {
                        self.realm.delete(category)   // to delete items
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
    
    //MARK: - Data Manipulation Methods
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Add new categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "add more item into it", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            self.save(category: newCategory)
        }
        // this add text field in alert popup
        alert.addTextField { (field) in
            field.placeholder = "Create new Category"
            textField = field
        }
        // this add action in alert popup
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
