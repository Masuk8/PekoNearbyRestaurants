//
//  RestaurantMarker.swift
//  PekoNearbyRestaurants
//
//  Created by Macbook on 08/10/2020.
//

import Foundation
import UIKit
import GoogleMaps

class RestaurantMarker: GMSMarker {
  let place: GooglePlace
  
  init(place: GooglePlace, availableTypes: [String]) {
    self.place = place
    super.init()
    
    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
    
    var foundType = "restaurant"
    let possibleTypes = availableTypes.count > 0 ? availableTypes : ["restaurant"]
    for type in place.types {
      if possibleTypes.contains(type) {
        foundType = type
        break
      }
    }
    icon = UIImage(named: foundType + "Icon-40")
  }
  
}
