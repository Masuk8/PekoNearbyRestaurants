//
//  RestaurantMarker.swift
//  PekoNearbyRestaurants
//
//  Created by Macbook on 08/10/2020.
//

import Foundation
import UIKit
import GoogleMaps

class UserMarker: GMSMarker {
  //let place: GooglePlace
  
  init(place: GooglePlace) {
    //self.place = place
    super.init()
    
    position = place.coordinate
    groundAnchor = CGPoint(x: 0.5, y: 1)
    appearAnimation = .pop
    
    icon = UIImage(named: "Icon-50")
  }
}
