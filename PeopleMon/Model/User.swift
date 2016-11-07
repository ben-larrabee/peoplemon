//
//  User.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/7/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//



import UIKit
import Alamofire
import Freddy
import CoreLocation

// Step 9: Create Model
class User: NetworkModel {
  /*

   "OldPassword": "string",
   "NewPassword": "string",
   "ConfirmPassword": "string"
   }
   {
   "ApiKey": "string",
   "Password": "string"
   }
   */
  var fullName: String?
  var password: String?
  var oldPassword: String?
  var newPassword: String?
  var confirmPassword: String?
  var avatarBase64: String?
  var id: String?
  var email: String?
  var hasRegistered: Bool?
  var loginProvider: String?
  var lastCheckInLatitude: Double?
  var lastCheckInLongitude: Double?
  var lastCheckInDateTime: String?
  var caughtUserID: String?
  var radiusInMeters: Int?
  var token: String?
  var expirationDate: String?
  
  var requestType: RequestType = .token
  
  enum RequestType {
    case postUserInfo
    case logout
    case changePassword
    case setPassword
    case accountRegister
    case checkIn
    case peopleCatch
    //    case postConversation
    case token
    case getUserInfo
    case nearby
    case caught
    //    case getConversations
    //    case getConversation
  }
  
  required init() {}
  
  required init(json: JSON) throws {
    token = try? json.getString(at: Constants.PeopleMonUser.token)
    expirationDate = try? json.getString(at: Constants.PeopleMonUser.expirationDate)
  }
  
  init(email: String, password: String) { // login init
    self.email = email
    self.password = password
    requestType = .token
  }
  
  init(fullName: String, password: String, avatarBase64: String, email: String) { // register init
    self.fullName = fullName
    self.password = password
    self.avatarBase64 = avatarBase64
    self.email = email
    requestType = .accountRegister
  }
  
  func method() -> Alamofire.HTTPMethod {
    return .post
  }
  
  func path() -> String {
    switch requestType {
    case .postUserInfo:
      return "/api/Account/UserInfo"
    case .logout:
      return "/api/Account/Logout"
    case .changePassword:
      return "/api/Account/ChangePassword"
    case .setPassword:
      return "/api/Account/SetPassword"
    case .accountRegister:
      return "/api/Account/Register"
    case .checkIn:
      return "/v1/User/CheckIn"
    case .peopleCatch:
      return "/v1/User/Catch"
      //case .postConversation:
      //return "/v1/User/Conversation"
    case .token:
      return "/token"
    case .getUserInfo:
      return "/api/Account/UserInfo"
    case .nearby:
      return "/v1/User/Nearby?radiusInMeters=100"
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
    case .postUserInfo:
      params[Constants.PeopleMonUser.fullName] = fullName as AnyObject?
      params[Constants.PeopleMonUser.avatarBase64] = avatarBase64 as AnyObject?
      break
    case .logout:
      break
    case .changePassword:
      params[Constants.PeopleMonUser.oldPassword] = oldPassword as AnyObject?
      params[Constants.PeopleMonUser.newPassword] = newPassword as AnyObject?
      params[Constants.PeopleMonUser.confirmPassword] = confirmPassword as AnyObject?
      break
    case .setPassword:
      params[Constants.PeopleMonUser.newPassword] = newPassword as AnyObject?
      break
    case .accountRegister:
      params[Constants.PeopleMonUser.email] = email as AnyObject?
      params[Constants.PeopleMonUser.fullName] = fullName as AnyObject?
      params[Constants.PeopleMonUser.avatarBase64] = avatarBase64 as AnyObject?
      params[Constants.PeopleMonUser.password] = password as AnyObject?
      params[Constants.PeopleMonUser.ApiKey] = Constants.apiKey as AnyObject?
      break
    case .checkIn:
      params[Constants.PeopleMonUser.Longitude] = lastCheckInLongitude as AnyObject?
      params[Constants.PeopleMonUser.Latitude] = lastCheckInLatitude as AnyObject?
      break
    case .peopleCatch:
      params[Constants.PeopleMonUser.caughtUserID] = caughtUserID as AnyObject?
      params[Constants.PeopleMonUser.radiusInMeters] = radiusInMeters as AnyObject?
      break
        //case .postConversation:
    case .token:
      params["grant_type"] = "password" as AnyObject?
      params["username"] = email as AnyObject?
      params["password"] = password as AnyObject?
      break
    case .getUserInfo:
      break
    case .nearby:
      break
    case .caught:
      break
        //case .getConversations:
        //case .getConversation:
    }
    return params
  }

  
}

