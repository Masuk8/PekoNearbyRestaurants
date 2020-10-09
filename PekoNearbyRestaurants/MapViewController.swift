//
//  ViewController.swift
//  PekoNearbyRestaurants
//
//  Created by Macbook on 08/10/2020.
//
import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    

  let googleData = GoogleData()

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
  
  func showCurrentLocationOnMap() {
    let camera = GMSCameraPosition.camera(withLatitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.latitude)!, zoom: 140)
    
    let marker = GMSMarker()
    marker.position = camera.target
    marker.snippet = "Current location"
    marker.appearAnimation = GMSMarkerAnimation.pop
    marker.map = mapView
    mapView.layoutIfNeeded()
  }
  
  
  
  func reverseGeocode(coordinate: CLLocationCoordinate2D) {
    let geocoder = GMSGeocoder()
    
    geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
      /*self.addressLabel.unlock()
      
      guard
        let address = response?.firstResult(),
        let lines = address.lines
      else {
        return
      }
      
      self.addressLabel.text = lines.joined(separator: "\n")
      
      let labelHeight = self.addressLabel.intrinsicContentSize.height
      let topInset = self.view.safeAreaInsets.top
      self.mapView.padding = UIEdgeInsets(
        top: topInset,
        left: 0,
        bottom: labelHeight,
        right: 0)
      
      UIView.animate(withDuration: 0.25) {
        self.pinImageVerticalConstraint.constant = (labelHeight - topInset) * 0.5
        self.view.layoutIfNeeded()
      }*/
    }
  }
}

extension MapViewController {
  
  func fetchPlacesFromMapView(near: CLLocationCoordinate2D) {
    mapView.clear()
    
    guard let lat = locationManager.location?.coordinate.latitude else {return}
    guard let lon = locationManager.location?.coordinate.longitude else {return}
    
    googleData.fetchPlaces (lat: lat, lon: lon, radius: 5000, types: ["restaurant"]) { places in
      print(places.count)
      places.forEach { place in
        let marker = PlaceMarker(place: place, availableTypes: ["restaurant"])
        marker.map = self.mapView
      }
    }
  }
}

extension MapViewController: GMSMapViewDelegate {
  
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    reverseGeocode(coordinate: position.target)
  }
  
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    //addressLabel.lock()
    
    if gesture {
      //mapCenterPinImage.fadeIn(0.25)
      mapView.selectedMarker = nil
    }
  }
  
  func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
    guard let placeMarker = marker as? PlaceMarker else {
      return nil
    }
    guard let restView = UIView.viewFromNibName("RestaurantMarkerWindow") as? RestaurantMarkerWindow else {
      return nil
    }
    
    //restView.nameLabel.text = placeMarker.place.name
    //restView.addressLabel.text = placeMarker.place.address
    
    return restView
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    //mapCenterPinImage.fadeOut(0.25)
    return false
  }
  
  func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    //mapCenterPinImage.fadeIn(0.25)
    mapView.selectedMarker = nil
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
    
  }
  
}
