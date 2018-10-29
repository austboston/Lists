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
    
    let itemArray = ["Catch the Joker", "Schedule lunch with Robin", "Cancel with Catwoman for Friday"]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopViewItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    func configureTableView() {
        topTableView.rowHeight = UITableView.automaticDimension
        topTableView.estimatedRowHeight = 120.0
    }
    
    //fire this whenever we click on any cell in the table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}

