//
//  ViewController.swift
//  Lists
//
//  Created by Blake, Austin on 10/29/18.
//  Copyright © 2018 Blake, Austin. All rights reserved.
//

import UIKit

class TopViewController: UITableViewController {
    
    @IBOutlet var topTableView: UITableView!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        self.loadItems()
        
        
//                if let items = defaults.array(forKey: "TopViewArray") as? [Item] {
//                    itemArray = items
//                }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopViewItemCell", for: indexPath)
        
        let itemA = itemArray[indexPath.row]
        
        cell.textLabel?.text = itemA.title
        
        //TERNARY OPERATOR IS ==> value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = itemA.done ? .checkmark : .none
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func configureTableView() {
        topTableView.rowHeight = UITableView.automaticDimension
        topTableView.estimatedRowHeight = 120.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            alert.addAction(action)
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new item"
                textField = alertTextField
            }
        }
        present(alert, animated: true, completion: nil)
//        self.saveItems()
        }
    
        func saveItems() {
            let encoder = PropertyListEncoder()
            do {
                let data = try encoder.encode(itemArray)
                try data.write(to: dataFilePath!)
            } catch {
                print("error encoding item array, \(error)")
            }
            self.tableView.reloadData()
            
        }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
               itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding item array, \(error)")
            }
            
        }
        self.tableView.reloadData()
    }
        
    
}

