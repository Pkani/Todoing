//
//  Item.swift
//  Todoing
//
//  Created by Artixun on 7/19/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var isImportant: Bool = false
    @objc dynamic var isFinished: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")  // this is for invert relation with Category class and items many to one
}
