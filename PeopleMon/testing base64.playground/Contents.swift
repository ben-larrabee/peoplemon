//: Playground - noun: a place where people can play

import UIKit



var avatarA: UIImage
avatarA = #imageLiteral(resourceName: "settings@2x.png")


//let avatarString: String!
//avatarString =
  
let pictureData = UIImagePNGRepresentation(#imageLiteral(resourceName: "settings@2x.png"))
let pictureToString64 = pictureData?.base64EncodedString()

let encodedPic = pictureToString64
let imageData = NSData(base64Encoded: encodedPic!, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
let image = UIImage(data: imageData as! Data)


// }
/*      user.avatarBase64 = pictureToString64
    } else {
      user.avatarBase64 = ""
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
 */
