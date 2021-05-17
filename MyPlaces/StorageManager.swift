//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Gladkov Maxim on 15.05.2021.
//

import RealmSwift

let realm = try! Realm()

class storageManager {
    
    static func saveObject(_ place: Place) {
         
        try! realm.write{
            realm.add(place)
        }
    }
    
    static func deleteObject(_ place: Place){
        try! realm.write {
            realm.delete(place)
        }
    }
}

