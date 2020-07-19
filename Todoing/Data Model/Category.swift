//
//  Category.swift
//  Todoing
//
//  Created by Artixun on 7/19/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // let array = [Int]()  or let array : [Int] = []  or let array: Array<Int> = [1, 2, 3]
    // let array = Array<Int>() this is another way of declearing empty array
    let items = List<Item>()  //this is for forward relation with Item class one to many
}
