//
//  StorageManager.swift
//  GroceryList
//
//  Created by Kirill Suvorov on 28.07.2024.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ item: Item) {
        try! realm.write {
            realm.add(item)
        }
    }
    
    static func deleteObject(_ item: Item) {
        try! realm.write {
            realm.delete(item)
        }
    }
    
}
