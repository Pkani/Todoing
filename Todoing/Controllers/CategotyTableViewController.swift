//
//  CategotyTableViewController.swift
//  Todoing
//
//  Created by Artixun on 7/17/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import UIKit
import CoreData

class CategotyTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadCategory()

    }
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let newCell = UITableViewCell(style: .default, reuseIdentifier: "CategoryCell")
        let newCell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let categories = categoryArray[indexPath.row]
        newCell.textLabel?.text = categories.name
        
        return newCell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadCategory(_ request: NSFetchRequest<Category> = Category.fetchRequest()) {
        //let request:NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            try categoryArray = context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
    }
    
    func saveCategory() {
        do {
            try context.save()
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
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
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
