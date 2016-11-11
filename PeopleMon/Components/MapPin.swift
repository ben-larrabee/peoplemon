//
//  MapPin.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/10/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import MapKit

class MapPin: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?
  var avatar: UIImage?
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String?) {
    self.coordinate = coordinate
    self.title = title
    if let avatar = subtitle {
      self.subtitle = avatar
    } else {
      self.subtitle = ""
    }
  }
  
  init(target: Target) {
    self.coordinate = CLLocationCoordinate2D()
    self.coordinate.latitude = target.latitude!
    self.coordinate.longitude = target.longitude!
    self.title = target.userName
    self.subtitle = target.avatarBase64
    if let encodedPic = target.avatarBase64 {
      if let imageData = NSData(base64Encoded: encodedPic, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
        self.avatar = UIImage(data: imageData as Data)
      }
    }
  }
}
