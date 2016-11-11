//
//  ProfileViewController.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/9/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import Foundation
import Alamofire
import Freddy
import Valet
import AFDateHelper

class ProfileViewController: UIViewController {
  @IBOutlet weak var fullNameTextField: UITextField!
  @IBOutlet weak var IDNumberLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var lastCheckInLabel: UILabel!
  @IBOutlet weak var avatarBase64Label: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    getUserInfo()
        // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  func getUserInfo() {
    
    let user = User(toGetUser: WebServices.shared.getAuthToken())
    print("attempting to get User Info")
    WebServices.shared.getObject(user) { (object, error) ->() in
      if let user = object {
        print("got User Info")
        self.fullNameTextField.text = user.fullName
        self.IDNumberLabel.text = user.id
        self.emailLabel.text = user.email
        self.longitudeLabel.text = "\(user.lastCheckInLongitude!)"
        self.latitudeLabel.text = "\(user.lastCheckInLatitude!)"
        self.lastCheckInLabel.text = user.lastCheckInDateTime
        if user.avatarBase64 != "" && user.avatarBase64 != nil {
          print("app believes in avatarBase64")
          let imageData = NSData(base64Encoded: user.avatarBase64!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
          let image = UIImage(data: imageData as! Data)
          self.avatarBase64Label.image = image
        } else {
          print("app believes avatarBase64 didn't exist")
          self.avatarBase64Label.isHidden = true
        }
        
      } else if let error = error {
        self.present(Utils.createAlert(message: error), animated: true, completion: nil)
      } else {
        self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
      }
    }    
  }
  
  func updateAccount() {
    let user = User(toPostUser: WebServices.shared.getAuthToken())
    user.fullName = fullNameTextField.text
    if self.avatarBase64Label.isHidden {
      user.avatarBase64 = ""
    } else {
      if let avatarImage = self.avatarBase64Label.image {
        let pictureData = UIImagePNGRepresentation(avatarImage)
        let pictureToString64 = pictureData?.base64EncodedString()
        user.avatarBase64 = pictureToString64
      }
    }
    print("attempting to update User")
    WebServices.shared.postObject(user) { (object, error) ->() in
      if let _ = object {
        print("success updating User")
      } else if let error = error {
        self.present(Utils.createAlert(message: error), animated: true, completion: nil)
      } else {
        self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
      }
    }
  }
  
  fileprivate func showPicker(_ type: UIImagePickerControllerSourceType) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = type
    present(imagePicker, animated: true, completion: nil)
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  // MARK: - IBActions
  
  @IBAction func updatePlayerTapped(_ sender: UIButton) {
    updateAccount()
  }
  
  @IBAction func choosePhoto(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Picture", message: "Choose a Picture", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action) in
      self.showPicker(.camera)
    }))
    alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action) in
      self.showPicker(.photoLibrary)
    }))
    present(alert, animated: true, completion: nil)
  }
  
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    picker.dismiss(animated: true, completion: nil)
    
    if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      let maxSize: CGFloat = 256
      //      let scale = maxSize / image.size.width
      //      let newHeight = image.size.height * scale
      //      UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
      //      image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
      //      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      //      UIGraphicsEndImageContext()
      //      if image.size.width < image.size.height {
      let scale = maxSize / image.size.width
      let newHeight = image.size.height * scale
      UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
      image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
      let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
      //      UIGraphicsEndImageContext()
      //      } else {
      //        let scale = maxSize / image.size.height
      //        let newWidth = image.size.width * scale
      //        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: maxSize))
      //
      //      }
      
      
      avatarBase64Label.image = resizedImage
      
      avatarBase64Label.isHidden = false
    }
  }
}
