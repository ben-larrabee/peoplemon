//
//  UserStore.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/7/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//


import Foundation

class UserStore {
  static let shared = UserStore()
  
  // Step 19: Add monthExpenses, currentMonth/Year

  func checkin(_ activeUser: User, completion:@escaping (_ success: Bool, _ error: String?) -> Void) {
    WebServices.shared.authUser(activeUser) { (user, error) in
      if user != nil {
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  func login(_ loginUser: User, completion:@escaping (_ success: Bool, _ error: String?) -> Void) {
    WebServices.shared.authUser(loginUser) { (user, error) -> () in
      if let user = user {
        WebServices.shared.setAuthToken(user.token, expiration: user.expirationDate)
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  func register(_ registerUser: User, completion:@escaping (_ success: Bool, _ error: String?) -> Void) {
    WebServices.shared.registerUser(registerUser) { (user, error) -> () in
      if let user = user {
        WebServices.shared.setAuthToken(user.token, expiration: user.expirationDate)
        completion(true, nil)
      } else {
        completion(false, error)
      }
    }
  }
  
  func logout(_ completion:() -> Void) {
    WebServices.shared.clearUserAuthToken()
    completion()
  }
}
