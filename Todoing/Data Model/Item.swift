//
//  model.swift
//  Todoing
//
//  Created by Artixun on 7/15/20.
//  Copyright © 2020 Pk. All rights reserved.
//

import Foundation

// encodable only work for standard data type and encodable means item type now encode it self into json or a plist
// as we encode our items same way it needs to decode to loads up in array and a common word for that is Codable
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
