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
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var memeIndex: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditMemeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        topText.hidden = true
        bottomText.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        if let meme = meme {
            imageView.image = meme.originalImage
            
            setupTextField(topText, defaultText: meme.topText, tag: 0)
            setupTextField(bottomText, defaultText: meme.bottomText, tag: 1)
            //topText.text = meme.topText
            //bottomText.text = meme.bottomText
            
            let mySelector: Selector = #selector(EditMemeViewController.save(_:))
            
            let rightNavigationBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: mySelector)
            navigationItem.rightBarButtonItem = rightNavigationBarItem
//            let saveButton = UIBarButtonItem()
//            saveButton.title = "Save"
            print("memeIndex: \(memeIndex)")
            //saveButton.addTarget(self, action: #selector(myClass.pressed(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    
    // MARK: keyboard methods
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y =  getKeyboardHeight(notification) * -1 + (self.navigationController?.toolbar.frame.height)!
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: UITextFieldDelegate methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setupTextField(textField: UITextField, defaultText: String, tag: Int) {
        textField.hidden = false
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
    
    // MARK: Meme-related methods
    
    func generateMemedImage() -> UIImage {
        
        self.navigationController?.toolbar.hidden = true
        self.navigationController?.navigationBarHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.toolbar.hidden = false
        self.navigationController?.navigationBarHidden = false
        return memedImage
    }
    
//    func save() -> Meme {
//        // need to create a new Meme obkject
//        let meme = Meme(topText: topText.text, bottomText: bottomText.text, originalImage: self.imageView.image, memeImage: generateMemedImage() )
//        
//        // Add it to the memes array in the Application Delegate
//        let object = UIApplication.sharedApplication().delegate
//        let appDelegate = object as! AppDelegate
//        
//        
//        appDelegate.memes[memeIndex] = meme
//        //appDelegate.memes.append(meme)
//        
//        return meme
//    }
    
    func test(sender: UIBarButtonItem) {
        print("test")
    }
    
    func save(sender: UIBarButtonItem) {
        print("save")
        let meme = Meme(topText: topText.text, bottomText: bottomText.text, originalImage: self.imageView.image, memeImage: generateMemedImage() )
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        
        appDelegate.memes[memeIndex] = meme
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
