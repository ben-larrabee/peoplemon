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
  @IBOutlet weak var radarView: MKMapView!

  let locationManager = CLLocationManager()
  var checkInTimer: Timer!
  var targetCollection: [Target] = []
  var annotations: [MapPin] = []
  var radarAnnotations: [MapPin] = []
  var circle: MKCircle?
  var radarCircle: MKCircle?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getLocation()
    //mapView.showsUserLocation = false

    mapView.isScrollEnabled = false
    mapView.isZoomEnabled = false
    mapView.isRotateEnabled = false
    radarView.isScrollEnabled = false
    radarView.isZoomEnabled = false
    radarView.isRotateEnabled = false
    checkInTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(MainViewController.checkIn), userInfo: nil, repeats: true)
    mapView.delegate = self
    radarView.delegate = self
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
    if let circle = circle {
      mapView.remove(circle)
    }
    circle = MKCircle(center: mapView.userLocation.coordinate, radius: 100)
    mapView.add(circle!, level: .aboveLabels)
    radarCircle = MKCircle(center: radarView.userLocation.coordinate, radius: 500)
    radarView.add(radarCircle!, level: .aboveLabels)
    let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 600, 600)
    mapView.setRegion(mapView.regionThatFits(region), animated: true)
    let radarRegion = MKCoordinateRegionMakeWithDistance(radarView.userLocation.coordinate, 600, 600)
    radarView.setRegion(radarView.regionThatFits(radarRegion), animated: true)
  }

  func checkNearby(_ range: Int) {
    let targets = Target(toSee: range)
    WebServices.shared.getObjects(targets) { (objects, error) -> Void in
      if let objects = objects {
        self.plotLocations()
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
            self.mapView.addAnnotation(annotation)
          } else if let error = error {
            self.present(Utils.createAlert(message: error), animated: true, completion: nil)
          } else {
            self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  func radarUpdate(_ range: Int) {
    let targets = Target(toSee: range)
    WebServices.shared.getObjects(targets) { (objects, error) -> Void in
      if let objects = objects {
        for target in objects {
          let annotation = MapPin(target: target)
          self.radarAnnotations.append(annotation)
          self.radarView.addAnnotation(annotation)
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
  func marker(sender: MKAnnotation) {
    let markerCircle = MKCircle(center: sender.coordinate, radius: 5)
    mapView.add(markerCircle, level: .aboveLabels)
    let fadeTimer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(markerRemove), userInfo: nil, repeats: false)
  }
  
  func markerRemove() {

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
          //let imageView = UIImageView(image: #imageLiteral(resourceName: "stickman"))
          //annotationView.addSubview(imageView)
        }
        return annotationView
      } else {
        let identifier = "MapPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
          let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
          pinView.isEnabled = true
          pinView.canShowCallout = true
          
          if mapView == self.mapView {
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
            
          } else if mapView == self.radarView {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "pokeball"))
            pinView.addSubview(imageView)
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "pokeball"), for: .normal)
            //button.addTarget(self, action: #selector(marker(sender: pinView.annotation!)), for: .touchUpInside)
            pinView.detailCalloutAccessoryView = button
          }
        }
        if let annotationView = annotationView {
          annotationView.annotation = annotation
          //let imageView = UIImageView(image: #imageLiteral(resourceName: "stickman"))
          //annotationView.addSubview(imageView)
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
    checkNearby(100)
    radarUpdate(500)
    /*
    if let circle = circle {
      mapView.remove(circle)
    }
    circle = MKCircle(center: mapView.userLocation.coordinate, radius: 100)
    let circleView = MKCircleRenderer(circle: circle!)
    circleView.strokeColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    circleView.lineWidth = 2
    circleView.fillColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
    circleView.alpha = 0.4
    mapView.add(circle!, level: .aboveLabels)
    */
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    //circle = MKCircle(center: mapView.userLocation.coordinate, radius: 100)
    if mapView == mapView {
      let circleView = MKCircleRenderer(circle: circle!)
      circleView.strokeColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
      circleView.lineWidth = 2
      circleView.fillColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
      circleView.alpha = 0.3
      return circleView
    } else {
      let circleView = MKCircleRenderer(circle: radarCircle!)
      circleView.strokeColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
      circleView.lineWidth = 1
      return circleView
    }
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

