//
//  Constants.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/7/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//


import UIKit

struct Constants {
  static let monthDayYear = "MM/dd/yyyy"
  public static let apiKey = "iOS301november2016"
  
  public static let keychainIdentifier = "PeopleMonKeychain"
  public static let authTokenExpireDate = "authTokenExpireDate"
  public static let authToken = "authToken"

  struct Test {
    static let userId = "userId"
    static let id = "id"
    static let title = "title"
    static let body = "body"
  }
  
  struct JSON {
    static let unknownError = "An Unknown Error Has Occurred"
    static let processingError = "There was an error processing the response"
  }
  struct Target {
    static let UserId = "UserId"
    static let UserName = "UserName"
    static let AvatarBase64 = "AvatarBase64"
    static let Longitude = "Longitude"
    static let Latitude = "Latitude"
    static let caughtUserID = "CaughtUserId"
    static let Created = "Created"
    static let RadiusInMeters = "RadiusInMeters"
  }
  
  
  struct PeopleMonUser {
    static let fullName = "FullName"
    static let password = "Password"
    static let newPassword = "NewPassword"
    static let oldPassword = "OldPassowrd"
    static let confirmPassword = "ConfirmPassword"
    static let avatarBase64 = "AvatarBase64"
    static let id = "UserId"
    static let email = "Email"
    static let hasRegistered = "HasRegistered"
    static let loginProvider = "LoginProvider"
    static let Latitude = "Latitude"
    static let Longitude = "Longitude"
    static let lastCheckInLatitude = "LastCheckInLatitude"
    static let lastCheckInLongitude = "LastCheckInLongitude"
    static let lastCheckInDateTime = "LastCheckInDateTime"
    static let token = "access_token"
    static let expirationDate = ".expires"
    static let ApiKey = "ApiKey"
    static let caughtUserID = "CaughtUserId"
    static let radiusInMeters = "RadiusInMeters"

  }
  
/*  // Step 10: Category Constants
  struct Category {
    static let id = "id"
    static let name = "name"
    static let categoryInfo = "category_info"
    static let startDate = "start_date"
    static let endDate = "end_date"
    static let user = "user"
    static let amount = "amount"
    static let month = "month"
    static let day = "day"
    static let year = "year"
  }
*/
}
/*
// MARK: - Colors
// Step 14: UIColor extension and
extension UIColor {
  public class func rgba(red: NSInteger, green: NSInteger, blue: NSInteger, alpha: Float = 1.0) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
  }
}

struct ColorPalette {
  static let PositiveColor = UIColor.rgba(red: 15, green: 181, blue: 46)
  static let NegativeColor = UIColor.rgba(red: 219, green: 31, blue: 31)
  static let BlueColor = UIColor.rgba(red: 12, green: 35, blue: 64)
  static let GoldColor = UIColor.rgba(red: 201, green: 151, blue: 0)
  static let calendarCellColor = UIColor.rgba(red: 0, green: 0, blue: 0, alpha: 0.1)
  static let calendarTodayColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.3)
  static let calendarBorderColor = UIColor.rgba(red: 12, green: 35, blue: 64, alpha: 0.8)
}
*/
