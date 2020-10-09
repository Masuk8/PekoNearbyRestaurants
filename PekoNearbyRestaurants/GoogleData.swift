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
typealias PhotoCompletion = (UIImage?) -> Void

class GoogleData {
  private var placesTask: URLSessionDataTask?
  private var session: URLSession {
    return URLSession.shared
  }
  
  func fetchPlaces(
    lat: Double,
    lon: Double,
    radius: Double,
    types:[String],
    completion: @escaping PlacesCompletion
  ) -> Void {
    var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=\(radius)&rankby=prominence&sensor=true&key=\("AIzaSyAEy5bcG6_tofsH8FZoXZ8fJtp2QMfkt-o")"
    let typesString = types.count > 0 ? types.joined(separator: "|") : "food"
    urlString += "&types=\(typesString)"
    urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlString
    
    guard let url = URL(string: urlString) else {
      completion([])
      return
    }
    
    if let task = placesTask, task.taskIdentifier > 0 && task.state == .running {
      task.cancel()
    }
        
    placesTask = session.dataTask(with: url) { data, response, _ in
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
      
      if let errorMessage = placesResponse.errorMessage {
        print(errorMessage)
      }
      
      DispatchQueue.main.async {
        completion(placesResponse.results)
      }
    }
    placesTask?.resume()
  }
}
