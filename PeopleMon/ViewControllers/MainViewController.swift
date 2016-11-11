//
//  MainViewController.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/7/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//


import UIKit
import MBProgressHUD
import CoreLocation
import MapKit

class MainViewController: UIViewController, SegueHandlerType, CLLocationManagerDelegate {
  
  enum SegueIdentifier: String {
    case LoginWithAnimation
    case LoginWithoutAnimation
  }

  @IBOutlet weak var mapView: MKMapView!

  let locationManager = CLLocationManager()
  var checkInTimer: Timer!
  var targetCollection: [Target] = []
  var annotations: [MapPin] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getLocation()
    //mapView.showsUserLocation = false
    mapView.isScrollEnabled = false
    mapView.isZoomEnabled = false
    mapView.isRotateEnabled = false
    checkInTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(MainViewController.checkIn), userInfo: nil, repeats: true)
    mapView.delegate = self
    definesPresentationContext = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !WebServices.shared.userAuthTokenExists() {//|| WebServices.shared.userAuthTokenExpired() {
      performSegueWithIdentifier(.LoginWithoutAnimation, sender: self)
    }
  }
  
  // Step 13: add viewWillDisappear and remove observer
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func getLocation() {
    let authStatus = CLLocationManager.authorizationStatus()
    
    if authStatus == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
      return
    }
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.startUpdatingLocation()
  }
  
  func showUser() {
    let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 600, 600)
    mapView.setRegion(mapView.regionThatFits(region), animated: true)
    checkNearby()
  }

  func checkNearby() {
    let targets = Target(toSee: 100)
    WebServices.shared.getObjects(targets) { (objects, error) -> Void in
      if let objects = objects {
        self.targetCollection = []
        self.annotations = []
        for target in objects {
          self.targetCollection.append(target)
          let annotation = MapPin(target: target)
          self.annotations.append(annotation)
          self.mapView.addAnnotation(annotation)
        }
        let user = User(toGetUser: WebServices.shared.getAuthToken())
        WebServices.shared.getObject(user) { (object, error) ->() in
          if let user = object {
            let annotation = MapPin(coordinate: self.mapView.userLocation.coordinate, title: "Your Location", subtitle: user.avatarBase64!)
            self.annotations.append(annotation)
          } else if let error = error {
            self.present(Utils.createAlert(message: error), animated: true, completion: nil)
          } else {
            self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
          }
        }
        

      }
    }
  }
  
  
  func checkIn(){
    let user = User(toCheckIn: WebServices.shared.getAuthToken())
    user.lastCheckInLongitude = Double(mapView.userLocation.coordinate.longitude)
      user.lastCheckInLatitude = Double(mapView.userLocation.coordinate.latitude)
    WebServices.shared.postObject(user) { (object, error) -> () in
      if let _ = object {
    /*  } else {
        self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
    */} else if let error = error {
        self.present(Utils.createAlert(message: error), animated: true, completion: nil)
      } else {
        self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
      }
    }
  }
  
  func catchPeopleMon() {
    print("attempting to catch")
    let nearestID = targetCollection[0].userID
    let target = Target(toCatchID: nearestID!)
    WebServices.shared.postObject(target) { (object, error) ->() in
      if let _ = object {
      } else if let error = error {
        self.present(Utils.createAlert(message: error), animated: true, completion: nil)
      } else {
        self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
      }
    }
  }
  
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is MapPin else {
      return nil
    }
    if let title = annotation.title {
      if title == "Your Location" {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UserPin")
        
        if annotationView == nil {

          let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserPin")
          pinView.isEnabled = true
          pinView.canShowCallout = true
          var imageView: UIImageView
          imageView = UIImageView (image: #imageLiteral(resourceName: "streetviewman"))
          if  let subtitle = annotation.subtitle {
            if subtitle != "" && subtitle != nil {
              if let imageData = NSData(base64Encoded: subtitle!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
                let image = UIImage(data: imageData as Data)
                UIGraphicsBeginImageContext(CGSize(width: 24, height: 30))
                image?.draw(in: CGRect(x: 0, y: 0, width: 24, height: 30))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                imageView = UIImageView(image: resizedImage)
              }
              pinView.addSubview(imageView)
            }
          }
          annotationView = pinView
        }
        if let annotationView = annotationView {
          annotationView.annotation = annotation
          let imageView = UIImageView(image: #imageLiteral(resourceName: "stickman"))
          annotationView.addSubview(imageView)
        }
        return annotationView
        
      } else {
        let identifier = "MapPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
          //let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
          let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
          pinView.isEnabled = true
          pinView.canShowCallout = true
          var imageView: UIImageView
          let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
          leftButton.setImage(#imageLiteral(resourceName: "stickman"), for: .normal)
          imageView = UIImageView (image: #imageLiteral(resourceName: "stickman"))
          if  let subtitle = annotation.subtitle {
            if subtitle != "" && subtitle != nil {
              if let imageData = NSData(base64Encoded: subtitle!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
                let image = UIImage(data: imageData as Data)
                leftButton.setImage(image, for: .normal)
                UIGraphicsBeginImageContext(CGSize(width: 24, height: 30))
                image?.draw(in: CGRect(x: 0, y: 0, width: 24, height: 30))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                imageView = UIImageView(image: resizedImage)
              }
              pinView.addSubview(imageView)
            }
          }
          pinView.leftCalloutAccessoryView = leftButton
          let rightButton = UIButton(type: .detailDisclosure)
          rightButton.setImage(#imageLiteral(resourceName: "pokeball"), for: .normal)
          rightButton.addTarget(self, action: #selector(catchPeopleMon), for: .touchUpInside)
          pinView.rightCalloutAccessoryView = rightButton
          let label = UILabel()
          label.text = annotation.title!
          pinView.detailCalloutAccessoryView = label
          annotationView = pinView
        }
        if let annotationView = annotationView {
          annotationView.annotation = annotation
          let imageView = UIImageView(image: #imageLiteral(resourceName: "stickman"))
          annotationView.addSubview(imageView)
        }
        return annotationView
      }
    }
    return nil
  }
  // MARK: - IBActions

  @IBAction func logoutTapped(_ sender: AnyObject) {
    UserStore.shared.logout {
      self.performSegueWithIdentifier(.LoginWithAnimation, sender: self)
    }
  }
  
  @IBAction func catchTapped(_ sender: UIButton) {
    //catchPeopleMon()
  }
  
  // MARK: - CLLocationManagerDelegate
  fileprivate func plotLocations() {
    mapView.removeAnnotations(annotations)
    annotations = []
    /*
    for place in searchResults {
      //      annotation.coordinate = place.placemark.coordinate
      //      annotation.title = place.name
      //      annotation.subtitle = addressString(place)
      
      let annotation = MapPin(coordinate: place.placemark.coordinate, title: place.name, address: addressString(place), phone: place.phoneNumber, url: place.url)
      
      annotations.append(annotation)
      mapView.addAnnotation(annotation)
    }
    if !searchResults.isEmpty {
      mapView.centerCoordinate = searchResults.first!.placemark.coordinate
    }
    */
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //let newLocation = locations.last!
    showUser()
  }
  
  // MARK: - Navigation
  // Step 16: shouldPerformSegueWithIdentifier prepareForSegue
  //override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
  //}
  
  //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //}

}

extension MainViewController: MKMapViewDelegate {
  
}

