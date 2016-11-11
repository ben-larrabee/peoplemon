//
//  WebServices.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/7/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//



import Foundation
import Alamofire
import Freddy
import Valet

// Step 2: Create WebServices
class WebServices: NSObject {
  
  // Singleton
  static let shared = WebServices()
  
  // baseURL private and public vars
  fileprivate var _baseURL = ""
  var baseURL : String {
    get {
      return _baseURL
    }
    set {
      _baseURL = newValue
    }
  }
  
  // Step 2: create normal var for authToken (commented out in step 7)
  //    private var authToken: String?
  
  // Step 7: authToken computed var (comment out line above)
  fileprivate var authToken: String? {
    get {
      let myValet = VALValet(identifier: Constants.keychainIdentifier, accessibility: .whenUnlocked)
      
      if let authTokenString = myValet?.string(forKey: Constants.authToken) {
        return authTokenString
      } else {
        return nil
      }
    }
    set {
      let myValet = VALValet(identifier: Constants.keychainIdentifier, accessibility: .whenUnlocked)
      
      if let newValue = newValue {
        myValet?.setString(newValue, forKey: Constants.authToken)
      } else {
        myValet?.removeObject(forKey: Constants.authToken)
      }
    }
  }
  
  // Step 7: authTokenExpireDate
  fileprivate var authTokenExpireDate: String? {
    get {
      let myValet = VALValet(identifier: Constants.keychainIdentifier, accessibility: .whenUnlocked)
      
      if let authExpireDate = myValet?.string(forKey: Constants.authTokenExpireDate) {
        return authExpireDate
      } else {
        return nil
      }
    } set {
      let myValet = VALValet(identifier: Constants.keychainIdentifier, accessibility: .whenUnlocked)
      
      if let newValue = newValue {
        myValet?.setString(newValue, forKey: Constants.authTokenExpireDate)
      } else {
        myValet?.removeObject(forKey: Constants.authTokenExpireDate)
      }
    }
  }
  
  // Step 2: function to set authToken and expiration date
  func setAuthToken(_ token: String?, expiration: String?) {
    authToken = token
    authTokenExpireDate = expiration
  }
  
  func getAuthToken() -> String {
    if let authToken = authToken {
      return authToken
    }
    return ""
  }
  
  func userAuthTokenExists() -> Bool {
    if self.authToken != nil {
      print(self.authToken!)
      return true
    }
    else {
      print("didn't find authtoken")
      return false
    }
  }
  
  func userAuthTokenExpired() -> Bool {
    if self.authTokenExpireDate != nil {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
      
      let dateString = self.authTokenExpireDate!
      if let expireDate = dateFormatter.date(from: dateString) {
        let hourFromNow = Date().addingTimeInterval(3600)
        
        if expireDate.compare(hourFromNow) == ComparisonResult.orderedAscending {
          return true
        } else {
          return false
        }
      } else {
        return true
      }
    } else {
      return true
    }
  }
  
  // Step 7: function to clear the auth token
  func clearUserAuthToken() {
    if self.userAuthTokenExists() {
      self.authToken = nil
    }
  }
  
  // AuthRouter - all network calls go through this
  enum AuthRouter: URLRequestConvertible {
    static var baseURLString = WebServices.shared._baseURL
    static var OAuthToken: String?
    
    // Because AuthRouter is an enum, it needs to have a case to instantiate it
    case restRequest(NetworkModel)
    
    func asURLRequest() throws -> URLRequest {
      let URL = try AuthRouter.baseURLString.asURL()
      var urlRequest: URLRequest
      
      switch self {
      case .restRequest(let model):
        // Create the url request with the base url and add on the path component passed in via the NetworkModel
        urlRequest = URLRequest(url: URL.appendingPathComponent(model.path()))
        // Set the method to the method passed in via the NetworkModel
        urlRequest.httpMethod = model.method().rawValue
        //print(urlRequest)
        // Check for an auth token and if it exists, add it to the request
        if let token = WebServices.shared.authToken {
          //print("a token was presented")
          urlRequest.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
          //print(urlRequest.value(forHTTPHeaderField: "Authorization")!)
        }
        
        // Check for parameters and eithe radd them to the URL or the body depending on the Method
        if let params = model.toDictionary() {

          if model.method() == .get {
            return try! URLEncoding.default.encode(urlRequest, with: params)
          } else {
            return try! JSONEncoding.default.encode(urlRequest, with: params)
          }
        }
        return urlRequest
      }
    }
  }
}

