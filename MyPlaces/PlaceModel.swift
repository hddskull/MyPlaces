//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Gladkov Maxim on 13.04.2021.
//

import UIKit

struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var restaurantImage: String?
    
    
    static let restaurantNames = [ "Балкан Гриль", "Бочка", "Вкусные истории",
                            "Дастархан", "Индокитай", "Классик",
                            "Шок", "Bonsai", "Burger Heroes", "Kitchen",
                            "Love&Life", "Morris Pub", "Sherlock Holmes",
                            "Speak Easy", "X.O"]
    
    static func getPlaces() -> [Place]{
        var places = [Place]()
        
        for place in restaurantNames {
            places.append(Place(name: place, location: "Уфа", type: "Ресторан", image: nil, restaurantImage: place))
        }
        return places
    }
}
