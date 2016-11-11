//
//  Cell.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/10/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

class Cell {
  var userName: String?
  var userID: String?
  var created: String?
  var avatarBase64: UIImage?
  
  init(target: Target) {
    userName = target.userName
    userID = target.userID
    created = target.created
    if let encodedPic = target.avatarBase64 {
      if let imageData = NSData(base64Encoded: encodedPic, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
        avatarBase64 = UIImage(data: imageData as Data)
      }
    }
  }
  
}
