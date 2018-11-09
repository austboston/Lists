//
//  ViewController.swift
//  Lists
//
//  Created by Blake, Austin on 10/29/18.
//  Copyright © 2018 Blake, Austin. All rights reserved.
//

import UIKit
import CoreData

class TopViewController: UITableViewController {
    
    @IBOutlet var topTableView: UITableView!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : Categoryy? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
    }
    
    
    //MARK: - TABLEVIEW DATASOURCE METHODS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopViewItemCell", for: indexPath)
        let newItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = newItem.title
        //TERNARY OPERATOR IS ==> value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = newItem.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func configureTableView() {
        topTableView.rowHeight = UITableView.automaticDimension
        topTableView.estimatedRowHeight = 120.0
    }
    
    
    //MARK: - TABLEVIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        saveItems()
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new item"
                textField = alertTextField
            }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        }
    
    //MARK: - DATA MANIPULATION METHODS
    
    func saveItems() {
            
            do {
                try context.save()
            } catch {
                print("error saving context, \(error)")
            }
            self.tableView.reloadData()
            
        }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        request.predicate = predicate
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error fetching! \(error)")
    }
        tableView.reloadData()
    }
    
    
}


//MARK: - SEARCH BAR METHODS
extension TopViewController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ && parentCategory.name MATCHES %@", [searchBar.text!, selectedCategory!.name!])
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
        searchBar.resignFirstResponder()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                self.loadItems()
                searchBar.resignFirstResponder()
            }
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ && parentCategory.name MATCHES %@", [searchBar.text!, selectedCategory!.name!])
            
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request)

        }
    }
}
