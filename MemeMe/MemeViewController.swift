//
//  ViewController.swift
//  MemeMe
//
//  Created by Mitch Murphy on 4/2/16.
//  Copyright © 2016 Mitch Murphy. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: class variables
    
    let imagePicker = UIImagePickerController()
    
    // MARK: setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagePicker.delegate = self
        
        setupTextField(topTextField, defaultText: "TOP", tag: 1)
        setupTextField(bottomTextField, defaultText: "BOTTOM", tag: 2)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.shareButton.enabled = false
        
        setupCancelButton()
        
        
        resetMeme()
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        setupCancelButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupCancelButton() {
        self.navigationController?.navigationBarHidden = false
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.memes.count > 0 {
            cancelButton.enabled = true
            //self.navigationController?.navigationBarHidden = false
        } else {
            cancelButton.enabled = false
            //self.navigationController?.navigationBarHidden = true
        }
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
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y =  getKeyboardHeight(notification) * -1 + (self.navigationController?.toolbar.frame.height)!
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }


    // MARK: UIImagePickerDelegate methods
    
    @IBAction func pickImageButtonTapped(sender: AnyObject) {
        pickImage(.PhotoLibrary)
    }
    @IBAction func pickImageFromCameraButtonTapped(sender: AnyObject) {
        pickImage(.Camera)
    }
    
    func pickImage(source: UIImagePickerControllerSourceType) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = source
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            shareButton.enabled = true
            self.navigationController?.navigationBarHidden = false
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "BOTTOM" || textField.text == "TOP" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            if textField.tag == 1 {
                textField.text = "TOP"
            } else if textField.tag == 2 {
                textField.text = "BOTTOM"
            }
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
    
    func save() -> Meme {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: self.imageView.image, memeImage: generateMemedImage() )
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        return meme
    }
    
    @IBAction func share(sender: AnyObject) {
        let memedImage = generateMemedImage()       
        let AVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        AVC.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // keyboard notifications do not work after sharing so maybe resubscribe to them?
        subscribeToKeyboardNotifications()
        presentViewController(AVC, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        let memeTabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("SentMemesTabBarController") as! UITabBarController
        presentViewController(memeTabBarController, animated: true, completion: nil)
    }
    
    @IBAction func discard(sender: AnyObject) {
        resetMeme()
    }
    
    func resetMeme() {
        // reset everything and then hide the navbar
        self.imageView.image = nil
        self.shareButton.enabled = false
        self.navigationController?.navigationBarHidden = true
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        bottomTextField.resignFirstResponder()
        topTextField.resignFirstResponder()
    }
}

