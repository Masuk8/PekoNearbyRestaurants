//
//  RestaurantMarker.swift
//  PekoNearbyRestaurants
//
//  Created by Macbook on 08/10/2020.
//

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
    
    icon = UIImage(named:"Icon-40")
  }
}

