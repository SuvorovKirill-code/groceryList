//
//  ItemModel.swift
//  GroceryList
//
//  Created by Кирилл Суворов on 08.07.2024.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0.0
    
}
