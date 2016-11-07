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

// Step 9: Create Model
class User: NetworkModel {
  var id: Int?
  var username: String?
  var email: String?
  var password: String?
  var token: String?
  var expirationDate: String?
  
  var requestType: RequestType = .login
  
  enum RequestType {
    case login
    case register
  }
  
  required init() {}
  
  required init(json: JSON) throws {
    token = try? json.getString(at: Constants.BudgetUser.token)
    expirationDate = try? json.getString(at: Constants.BudgetUser.expirationDate)
  }
  
  init(username: String, password: String) {
    self.username = username
    self.password = password
    requestType = .login
  }
  
  init(username: String, password: String, email: String) {
    self.username = username
    self.password = password
    self.email = email
    requestType = .register
  }
  
  init(id: Int) {
    self.id = id
  }
  
  func method() -> Alamofire.HTTPMethod {
    return .post
  }
  
  func path() -> String {
    switch requestType {
    case .login:
      return "/auth"
    case .register:
      return "/register"
    }
  }
  
  func toDictionary() -> [String: AnyObject]? {
    var params: [String: AnyObject] = [:]
    params[Constants.BudgetUser.username] = username as AnyObject?
    params[Constants.BudgetUser.password] = password as AnyObject?
    
    switch requestType {
    case .register:
      params[Constants.BudgetUser.email] = email as AnyObject?
    default:
      break
    }
    
    return params
  }
}

