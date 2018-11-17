//
//  Category.swift
//  Lists
//
//  Created by Austin B Blake on 11/9/18.
//  Copyright © 2018 Blake, Austin. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
