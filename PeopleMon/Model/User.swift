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

class User: NetworkModel {

  var fullName: String?
  var password: String?
  var oldPassword: String?
  var newPassword: String?
  var confirmPassword: String?
  var avatarBase64: String?
  var apiKey: String?
  var id: String?
  var email: String?
  var hasRegistered: Bool?
  var loginProvider: String?
  var longitude: Double?
  var latitude: Double?
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
    fullName = try? json.getString(at: Constants.PeopleMonUser.fullName)
    password = try? json.getString(at: Constants.PeopleMonUser.password)
    oldPassword = try? json.getString(at: Constants.PeopleMonUser.oldPassword)
    newPassword = try? json.getString(at: Constants.PeopleMonUser.newPassword)
    confirmPassword = try? json.getString(at: Constants.PeopleMonUser.confirmPassword)
    avatarBase64 = try? json.getString(at: Constants.PeopleMonUser.avatarBase64)
    apiKey = try? json.getString(at: Constants.PeopleMonUser.ApiKey)
    id = try? json.getString(at: Constants.PeopleMonUser.id)
    email = try? json.getString(at: Constants.PeopleMonUser.email)
    hasRegistered = try? json.getBool(at: Constants.PeopleMonUser.hasRegistered)
    loginProvider = try? json.getString(at: Constants.PeopleMonUser.loginProvider)
    longitude = try? json.getDouble(at: Constants.PeopleMonUser.Longitude)
    latitude = try? json.getDouble(at: Constants.PeopleMonUser.Latitude)
    lastCheckInLatitude = try? json.getDouble(at: Constants.PeopleMonUser.lastCheckInLatitude)
    lastCheckInLongitude = try? json.getDouble(at: Constants.PeopleMonUser.lastCheckInLongitude)
    lastCheckInDateTime = try? json.getString(at: Constants.PeopleMonUser.lastCheckInDateTime)
    caughtUserID = try? json.getString(at: Constants.PeopleMonUser.caughtUserID)
    radiusInMeters = try? json.getInt(at: Constants.PeopleMonUser.radiusInMeters)
    token = try? json.getString(at: Constants.PeopleMonUser.token)
    expirationDate = try? json.getString(at: Constants.PeopleMonUser.expirationDate)
  }
  
  init(email: String, password: String) { // login init
    self.email = email
    self.password = password
    requestType = .token
  }
  
  init(email: String, password: String, fullName: String) { // register init
    self.email = email
    self.password = password
    self.fullName = fullName
    self.apiKey = "iOS301november2016"
    requestType = .accountRegister
  }
  
  init(toCheckIn token: String) {
    self.token = token
    requestType = .checkIn
  }
  
  init(toSeeNearby token: String) {
    self.token = token
    requestType = .nearby
  }
  
  init(toCatch token: String) {
    requestType = .peopleCatch
  }
  
  init(toGetUser token: String) {
    self.token = token
    requestType = .getUserInfo
  }
  init(toPostUser token: String) {
    self.token = token
    requestType = .postUserInfo
  }
  
  func method() -> Alamofire.HTTPMethod {
    switch requestType {
    case .postUserInfo:
      return .post
    case .logout:
      return .post
    case .changePassword:
      return .post
    case .setPassword:
      return .post
    case .accountRegister:
      return .post
    case .checkIn:
      return .post
    case .peopleCatch:
      return .post
      //    case postConversation
    case .token:
      return .post
    case .getUserInfo:
      return .get
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
      params[Constants.PeopleMonUser.avatarBase64] = "" as AnyObject?
      params[Constants.PeopleMonUser.ApiKey] = Constants.apiKey as AnyObject?
      params[Constants.PeopleMonUser.password] = password as AnyObject?
      print(params)
      break
    case .checkIn:
      params[Constants.PeopleMonUser.Longitude] = lastCheckInLongitude as AnyObject?
      params[Constants.PeopleMonUser.Latitude] = lastCheckInLatitude as AnyObject?
      break
    case .peopleCatch:
      params[Constants.PeopleMonUser.caughtUserID] = caughtUserID as AnyObject?
      params[Constants.PeopleMonUser.radiusInMeters] = radiusInMeters as AnyObject?
      print(params)
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

