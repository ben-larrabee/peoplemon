//
//  NetworkModel.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/7/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

protocol NetworkModel: JSONDecodable {
  init(json: JSON) throws
  init()
  
  func method() -> Alamofire.HTTPMethod
  func path() -> String
  func toDictionary() -> [String: AnyObject]?
}
