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
    
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Catch the Joker"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Hire Mike 2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Hire Mike 3"
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Hire Mike 4"
        itemArray.append(newItem4)
        
        
        if let items = defaults.array(forKey: "TopViewArray") as? [Item] {
            itemArray = items
        }
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
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TopViewArray")
            self.tableView.reloadData()
        }
        
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
            
        present(alert, animated: true, completion: nil)
    }
}

