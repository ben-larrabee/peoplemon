//
//  LoginViewController.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/7/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//


import UIKit
// Step 9: Import MBProgressHUD
import MBProgressHUD

// Step 8: Create VC with IBOutlets and IBActions
class LoginViewController: UIViewController {
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func loginTapped(_ sender: AnyObject) {
    // Step 9: implement validation and send endpoint
    guard let email = usernameTextField.text , email != "" else {
      present(Utils.createAlert("Login Error", message: "Please provide a username"), animated: true, completion: nil)
      return
    }
    guard let password = passwordTextField.text , password != "" else {
      present(Utils.createAlert("Login Error", message: "Please provide a password"), animated: true, completion: nil)
      return
    }
    MBProgressHUD.showAdded(to: view, animated: true)
    let user = User(email: email, password: password)
    UserStore.shared.login(user) { (success, error) in
      MBProgressHUD.hide(for: self.view, animated: true)
      if success {
        print("successful login")
        self.dismiss(animated: true, completion: nil)
      } else if let error = error {
        self.present(Utils.createAlert(message: error), animated: true, completion: nil)
      } else {
        self.present(Utils.createAlert(message: Constants.JSON.unknownError), animated: true, completion: nil)
      }
    }
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
