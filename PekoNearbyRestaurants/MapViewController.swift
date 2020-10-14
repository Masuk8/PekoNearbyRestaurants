//
//  ViewController.swift
//  PekoNearbyRestaurants
//
//  Created by Macbook on 08/10/2020.
//
import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
  @IBOutlet weak var zoomOutButton: UIButton!
  @IBOutlet weak var zoomInButton: UIButton!

  let googleData = GoogleData()
  var zoom: Float = 15

  @IBOutlet weak var mapView: GMSMapView!
  
  var locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager.delegate = self
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.requestLocation()
      
    } else {
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    }
    
    mapView.delegate = self

    guard let lat = locationManager.location?.coordinate.latitude else {return}
    guard let lon = locationManager.location?.coordinate.longitude else {return}
    let camera  = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 15)
    mapView.camera = camera
  }
  
  @IBAction func zoomInActionButton(_ sender: Any) {
    zoom = zoom + 1
    self.mapView.animate(toZoom: zoom)
  }
  @IBAction func zoomOutActionButton(_ sender: Any) {
    zoom = zoom - 1
    self.mapView.animate(toZoom: zoom)
  }
  
  func addUserMarker() {
    
    guard let lat = locationManager.location?.coordinate.latitude else {return}
    guard let lon = locationManager.location?.coordinate.longitude else {return}
    
    let userMarker = GMSMarker()
    userMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    userMarker.icon = UIImage(named: "Icon-50")
    userMarker.userData = "user"
    userMarker.map = self.mapView
    
  }
  
  func fetchPlacesFromMapView(near: CLLocationCoordinate2D) {
    mapView.clear()
    
    guard let lat = locationManager.location?.coordinate.latitude else {return}
    guard let lon = locationManager.location?.coordinate.longitude else {return}
      
    googleData.fetchPlaces(lat: lat, lon: lon, radius: 5000, types: ["restaurant"]) {  place in
      
      print(place.count)
      place.forEach { place in
        let marker = RestaurantMarker(place: place, availableTypes: ["restaurant"])
        marker.userData = "restaurant"
        self.addUserMarker()
        marker.map = self.mapView
      }
    }
  }
}


extension MapViewController: GMSMapViewDelegate {
    
  func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
    
    var finalView = UIView()
    
    if marker.userData as? String == "user" {
      
      guard let userView = UIView.viewFromNibName("UserMarkerWindow") as? UserMarkerWindow else {return nil}
      
      finalView = userView
    }
    
    if marker.userData as? String == "restaurant" {
      
      guard let restaurantView = UIView.viewFromNibName("RestaurantMarkerWindow") as? RestaurantMarkerWindow else {return nil}
      
      guard let restaurantMarker = marker as? RestaurantMarker else { return nil }
      restaurantView.restaurantName?.text = restaurantMarker.place.name
      
      finalView = restaurantView
    }
    return finalView
  }
    

  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    return false
  }
}

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    guard let location = locations.last else {return}
    fetchPlacesFromMapView(near: location.coordinate)
    self.locationManager.stopUpdatingLocation()

  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location Manager failed with error: \(error)")
  }
  
}
