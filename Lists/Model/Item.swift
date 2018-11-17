//
//  Item.swift
//  Lists
//
//  Created by Austin B Blake on 11/9/18.
//  Copyright © 2018 Blake, Austin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateAdded: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
