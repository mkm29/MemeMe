//
//  EditMemeViewController.swift
//  MemeMe
//
//  Created by Mitchell Murphy on 4/28/16.
//  Copyright © 2016 Mitch Murphy. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UITextFieldDelegate {
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if let meme = meme {
            imageView.image = meme.originalImage
            
            setupTextField(topText, defaultText: meme.topText, tag: 0)
            setupTextField(bottomText, defaultText: meme.bottomText, tag: 1)
            //topText.text = meme.topText
            //bottomText.text = meme.bottomText
            
            let saveButton = UIBarButtonItem()
            saveButton.title = "Save"
            self.navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    func setupTextField(textField: UITextField, defaultText: String, tag: Int) {
        textField.delegate = self
        textField.text = defaultText
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            //NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSFontAttributeName: UIFont(name: "Futura-Medium", size: 30)!,
            NSStrokeWidthAttributeName : -2
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.tag = tag
    }
}
