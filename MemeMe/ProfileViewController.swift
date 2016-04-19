//
//  ProfileViewController.swift
//  MemeMe
//
//  Created by Mitch Murphy on 4/19/16.
//  Copyright © 2016 Mitch Murphy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        //
        //profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        //profileImage.layer.borderColor = UIColor.blackColor().CGColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
}
