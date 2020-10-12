//
//  GoogleData.swift
//  PekoNearbyRestaurants
//
//  Created by Macbook on 08/10/2020.
//

import Foundation
import UIKit
import CoreLocation

typealias PlacesCompletion = ([GooglePlace]) -> Void

class GoogleData {
  private var placesTask: URLSessionDataTask?
  private var session: URLSession?
  
  func fetchPlaces(lat: Double, lon: Double, radius: Double, types:[String], completion: @escaping PlacesCompletion) -> Void {
    let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=\(radius)&rankby=prominence&sensor=true&key=\("AIzaSyAEy5bcG6_tofsH8FZoXZ8fJtp2QMfkt-o")"
    
    print("\(urlString)")
    
    guard let url = URL(string: urlString) else {
      completion([])
      return
    }
    
    if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
      task.cancel()
    }
    
    placesTask = URLSession.shared.dataTask(with: url) { (data, response, err) in
      
      if let err = err {
        print("Error in URLSession is: \(err)")
      }
            
      guard let data = data else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      
      guard let placesResponse = try? decoder.decode(GooglePlace.Response.self, from: data) else {
        DispatchQueue.main.async {
          completion([])
        }
        return
      }
      DispatchQueue.main.async {
        completion(placesResponse.results)
      }
    }
    placesTask?.resume()
  }
}

