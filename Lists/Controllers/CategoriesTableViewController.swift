//
//  CategoriesTableViewController.swift
//  Lists
//
//  Created by Austin B Blake on 11/6/18.
//  Copyright © 2018 Blake, Austin. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {
    @IBOutlet var CategoriesTableView: UITableView!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Categoryy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TABLEVIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let newItem = categoryArray[indexPath.row]
       
        cell.textLabel?.text = newItem.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func configureTableView() {
        CategoriesTableView.rowHeight = UITableView.automaticDimension
        CategoriesTableView.estimatedRowHeight = 120.0
    }
    
    //MARK: - TABLEVIEW DELEGATE METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TopViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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
            let newCategory = Categoryy(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Categoryy> = Categoryy.fetchRequest()) {
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("error fetching! \(error)")
        }
        tableView.reloadData()
    }
    
}

