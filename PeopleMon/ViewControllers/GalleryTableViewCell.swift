//
//  GalleryTableViewCell.swift
//  PeopleMon
//
//  Created by Ben Larrabee on 11/10/16.
//  Copyright © 2016 Ben Larrabee. All rights reserved.
//

import UIKit
import Alamofire
import Freddy

class GalleryTableViewCell: UITableViewCell {

  @IBOutlet weak var GalleryImage: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userIDLabel: UILabel!
  @IBOutlet weak var createdLabel: UILabel!

  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  func setupCell(celldata: Cell){
    if let image = celldata.avatarBase64 {
      GalleryImage.image = image
    } else {
      GalleryImage.isHidden = true
    }
    userNameLabel.text = celldata.userName
    userIDLabel.text = celldata.userID
    createdLabel.text = celldata.created
  }
}
