//
//  CategoriesTableViewController.swift
//  Lists
//
//  Created by Austin B Blake on 11/6/18.
//  Copyright © 2018 Blake, Austin. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesTableViewController: UITableViewController {
    @IBOutlet var CategoriesTableView: UITableView!
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TABLEVIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
     
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet :)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        //that syntax is called the "Nil Coalescing Operator" (lecture 248)
    }
    
    func configureTableView() {
        CategoriesTableView.rowHeight = UITableView.automaticDimension
        CategoriesTableView.estimatedRowHeight = 120.0
    }
    
    //MARK: - TABLEVIEW DELEGATE METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TopViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    
    //MARK: - DATA MANIPULATION METHODS
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "Category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving to realm, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

}

