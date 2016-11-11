//
//  Target.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/10/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit
import Alamofire
import Freddy
import CoreLocation

class Target: NetworkModel {
  
  var userName: String?
  var avatarBase64: String?
  var userID: String?
  var longitude: Double?
  var latitude: Double?
  var caughtUserID: String?
  var radiusInMeters: Int = 100
  var created: String?
  
  var requestType: RequestType = .nearby
  
  enum RequestType {
    case peopleCatch
    //    case postConversation
    case nearby
    case caught
    //    case getConversations
    //    case getConversation
  }
  
  required init() {}
  
  required init(json: JSON) throws {
    userName = try? json.getString(at: Constants.Target.UserName)
    avatarBase64 = try? json.getString(at: Constants.Target.AvatarBase64)
    userID = try? json.getString(at: Constants.Target.UserId)
    longitude = try? json.getDouble(at: Constants.Target.Longitude)
    latitude = try? json.getDouble(at: Constants.Target.Latitude)
    caughtUserID = try? json.getString(at: Constants.Target.caughtUserID)
    created = try? json.getString(at: Constants.Target.Created)
  }
  
  init(toSee radius: Int) {
    radiusInMeters = radius
    requestType = .nearby
  }
  
  init(toCatchID: String) {
    caughtUserID = toCatchID
    radiusInMeters = 100
    requestType = .peopleCatch
  }
  
  init(token: String) {
    requestType = .caught
  }
  
  
  func method() -> Alamofire.HTTPMethod {
    switch requestType {
    case .peopleCatch:
      return .post
    case .nearby:
      return .get
    case .caught:
      return .get
    default:
      return .post
    }
  }
  
  func path() -> String {
    switch requestType {
    case .peopleCatch:
      return "/v1/User/Catch"
      //case .postConversation:
    //return "/v1/User/Conversation"
    case .nearby:
      return "/v1/User/Nearby"
    case .caught:
      return "/v1/User/Caught"
      //case .getConversations:
      //return "/v1/User/Conversations"
      //case .getConversation:
      //return "/v1/User/Conversation"
    }
    
  }
  
  func toDictionary() -> [String: AnyObject]? {
    var params: [String: AnyObject] = [:]
    switch requestType {
    case .peopleCatch:
      //let catchUserID = "\"\(caughtUserID!)\""
      params[Constants.Target.caughtUserID] = caughtUserID as AnyObject?
      params[Constants.Target.RadiusInMeters] = radiusInMeters as AnyObject?
      print(params)
      break
    case .nearby:
      params[Constants.Target.RadiusInMeters] = radiusInMeters as AnyObject?
      break
    case .caught:
      break
    }
    return params
  }
  
  
}
