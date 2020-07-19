//
//  Data.swift
//  Todoing
//
//  Created by Artixun on 7/19/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    // here dynamic is use for dynamically update data when running and @obj is use for objective-c
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
