//
//  ViewController.swift
//  Lists
//
//  Created by Blake, Austin on 10/29/18.
//  Copyright © 2018 Blake, Austin. All rights reserved.
//

import UIKit
import RealmSwift

class TopViewController: UITableViewController {
    
    @IBOutlet var topTableView: UITableView!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: - TABLEVIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopViewItemCell", for: indexPath)
        if let newItem = todoItems?[indexPath.row] {
            cell.textLabel?.text = newItem.title
            //TERNARY OPERATOR IS ==> value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = newItem.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items in this list:)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    func configureTableView() {
        topTableView.rowHeight = UITableView.automaticDimension
        topTableView.estimatedRowHeight = 120.0
    }
    
    
    //MARK: - TABLEVIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
            }
            }catch{
                print("error saving done status, \(error)")
            }
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateAdded = Date()
                    currentCategory.items.append(newItem)
                }
            } catch {
                print("error saving item to Realm, \(error)")
            }
            self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new item"
                textField = alertTextField
            }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        }
    
    //MARK: - DATA MANIPULATION METHODS
    
    func loadItems() {

    todoItems = selectedCategory?.items.sorted(byKeyPath: "dateAdded", ascending: true)
    
    tableView.reloadData()
    }
    
    
}


// MARK: - SEARCH BAR METHODS


extension TopViewController: UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateAdded", ascending: true)
        self.tableView.reloadData()
        
        searchBar.resignFirstResponder()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                self.loadItems()
//                searchBar.resignFirstResponder()
            }
        }else {
            todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateAdded", ascending: true)
            self.tableView.reloadData()
        }
    }
}

