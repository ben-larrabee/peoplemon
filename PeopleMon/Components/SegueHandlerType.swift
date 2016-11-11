//
//  SegueHandlerType.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/7/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit

// Step 12: create and extend protocol
protocol SegueHandlerType {
  associatedtype SegueIdentifier: RawRepresentable // This is just saying "take this thing that exists and let me refer to it by this name"
  
  // RawRepresentable: A type that can be converted to an associated "raw" type, then converted back to produce an instance equivalent to the original.
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
  func performSegueWithIdentifier(_ segueIdentifier: SegueIdentifier, sender: AnyObject?) {
    performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
  }
  
  func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
    guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
      fatalError("Invalid segue identifier \(segue.identifier).")
    }
    return segueIdentifier
  }
}

