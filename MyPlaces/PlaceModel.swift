//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Gladkov Maxim on 13.04.2021.
//

import RealmSwift

class Place: Object{
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    
    let restaurantNames = [ "Балкан Гриль", "Бочка", "Вкусные истории",
                            "Дастархан", "Индокитай", "Классик",
                            "Шок", "Bonsai", "Burger Heroes", "Kitchen",
                            "Love&Life", "Morris Pub", "Sherlock Holmes",
                            "Speak Easy", "X.O"]
    
    func savePlaces() {
        
        for place in restaurantNames {
            let image = UIImage(named: place)

            guard let imageData = image?.pngData() else {
                return
            }
            
            let newPlace = Place()
            newPlace.name = place
            newPlace.location = "Mocsow"
            newPlace.type = "Restaurant"
            newPlace.imageData = imageData
            
            storageManager.saveObject(newPlace)
            
        }
    }
}
