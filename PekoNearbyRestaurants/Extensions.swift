//
//  Extensions.swift
//  PekoNearbyRestaurants
//
//  Created by Macbook on 08/10/2020.
//
import UIKit
import Foundation

extension UIView {
  
  class func viewFromNibName(_ name: String) -> UIView? {
    let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
    return views?.first as? UIView
  }
}
