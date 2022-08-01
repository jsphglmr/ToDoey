//
//  Category.swift
//  Todoey
//
//  Created by Joseph Gilmore on 5/31/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String = ""
    @Persisted var cellColor: String? = ""
    @Persisted var items = List<Item>()
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
