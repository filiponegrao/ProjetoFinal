//
//  AppRegister_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 17/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit


class AppRegister_ViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate
{
    var image : UIImage!
    
    var picker : UIImagePickerController? = UIImagePickerController()
    
    var popover : UIPopoverController? = nil
    
    var loadingScreen: LoadScreen_View!
    
    var registerButton: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    
    var buttonphoto: UIButton!

    @IBOutlet var labelEmail: MKTextField!
    
    @IBOutlet var labelUsername: MKTextField!
    
    @IBOutlet var labelPassword: MKTextField!
    
    @IBOutlet weak var labelConfirmPassword: MKTextField!
    
    @IBOutlet var containerView: UIView!
    
    override func viewWillAppear(animated: Bool)
    {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "emailInUse", name: UserCondition.emailInUse.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAlreadyExist", name: UserCondition.userAlreadyExist.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userLogged", name: UserCondition.userLogged.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginCanceled", name: UserCondition.loginCanceled.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)

    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.picker!.delegate = self
        self.view.backgroundColor = oficialDarkGray
        
        self.buttonphoto = UIButton(frame: CGRectMake(0,0,screenWidth/2,screenWidth/2))
        self.buttonphoto.center = CGPointMake(screenWidth/2, 30 + (screenWidth/1.5)/2)
        self.buttonphoto.layer.cornerRadius = self.buttonphoto.frame.size.width/2
        self.buttonphoto.addTarget(self, action: "photoButtonClicked", forControlEvents: .TouchUpInside)
        self.buttonphoto.clipsToBounds = true
        self.buttonphoto.setImage(UIImage(named: "cameraButton"), forState: .Normal)
        self.buttonphoto.contentMode = .ScaleAspectFill
        self.view.addSubview(self.buttonphoto)
        
 
        self.labelEmail.delegate = self
        self.labelEmail.autocapitalizationType = .None
        self.labelEmail.autocorrectionType = .No
        self.labelEmail.textAlignment = .Center
        self.labelEmail.layer.borderColor = UIColor.clearColor().CGColor
        self.labelEmail.floatingPlaceholderEnabled = true
        self.labelEmail.placeholder = "email"
        self.labelEmail.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.labelEmail.rippleLayerColor = UIColor.clearColor()
        self.labelEmail.bottomBorderEnabled = true
        self.labelEmail.bottomBorderColor = oficialGreen
        self.labelEmail.tintColor = oficialGreen
        self.labelEmail.textColor = oficialLightGray
        self.labelEmail.keyboardType = UIKeyboardType.EmailAddress
//        self.labelEmail.keyboardAppearance = UIKeyboardAppearance.Dark
        
        self.labelUsername.delegate = self
        self.labelUsername.autocapitalizationType = .None
        self.labelUsername.autocorrectionType = .No
        self.labelUsername.textAlignment = .Center
        self.labelUsername.layer.borderColor = UIColor.clearColor().CGColor
        self.labelUsername.floatingPlaceholderEnabled = true
        self.labelUsername.placeholder = "username"
        self.labelUsername.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.labelUsername.rippleLayerColor = UIColor.clearColor()
        self.labelUsername.bottomBorderEnabled = true
        self.labelUsername.bottomBorderColor = oficialGreen
        self.labelUsername.tintColor = oficialGreen
        self.labelUsername.textColor = oficialLightGray
//        self.labelUsername.keyboardAppearance = UIKeyboardAppearance.Dark
        
        
        self.labelPassword.delegate = self
        self.labelPassword.autocapitalizationType = .None
        self.labelPassword.autocorrectionType = .No
        self.labelPassword.textAlignment = .Center
        self.labelPassword.layer.borderColor = UIColor.clearColor().CGColor
        self.labelPassword.floatingPlaceholderEnabled = true
        self.labelPassword.placeholder = "password"
        self.labelPassword.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.labelPassword.rippleLayerColor = UIColor.clearColor()
        self.labelPassword.tintColor = oficialGreen
        self.labelPassword.textColor = oficialLightGray
//        self.labelPassword.keyboardAppearance = UIKeyboardAppearance.Dark
        self.labelPassword.bottomBorderEnabled = true
        self.labelPassword.bottomBorderColor = oficialGreen
      
        
        self.labelConfirmPassword.delegate = self
        self.labelConfirmPassword.autocapitalizationType = .None
        self.labelConfirmPassword.autocorrectionType = .No
        self.labelConfirmPassword.textAlignment = .Center
        self.labelConfirmPassword.layer.borderColor = UIColor.clearColor().CGColor
        self.labelConfirmPassword.floatingPlaceholderEnabled = true
        self.labelConfirmPassword.placeholder = "confirm password"
        self.labelConfirmPassword.attributedPlaceholder = NSAttributedString(string: "confirm password", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
        self.labelConfirmPassword.rippleLayerColor = UIColor.clearColor()
        self.labelConfirmPassword.tintColor = oficialGreen
        self.labelConfirmPassword.textColor = oficialLightGray
        self.labelConfirmPassword.bottomBorderEnabled = true
        self.labelConfirmPassword.bottomBorderColor = oficialGreen
        
        self.registerButton = UIButton(frame: CGRectMake(0,0,screenWidth/2.5, screenWidth/10))
        self.registerButton.center = CGPointMake(screenWidth/2, screenHeight - screenWidth/8 - screenWidth/10 - 10)
        self.registerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.registerButton.backgroundColor = oficialDarkGreen
        self.registerButton.titleLabel?.font = UIFont(name: "SukhumvitSet-Medium", size: 16)
        self.registerButton.setTitle("Register", forState: .Normal)
        self.registerButton.titleLabel?.setSizeFont(15)
        self.registerButton.layer.cornerRadius = 7
        self.registerButton.clipsToBounds = true
        self.registerButton.addTarget(self, action: "register", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.registerButton)
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == self.labelPassword || textField == self.labelConfirmPassword)
        {
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            return newLength <= 6 // Bool
        }
        return true
    }
    
    
    
    //Sobe a view e desce a view
    func keyboardWillShow(notification: NSNotification)
    {
        if(self.view.frame.origin.y == 0)
        {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.frame.origin.y = 0
        }
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func photoButtonClicked()
    {
        let alert: UIAlertController = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: {
            
            UIAlertAction in
            self.openCamera()
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: {
            UIAlertAction in
            self.openGallery()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            
            UIAlertAction in
        })
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.popover = UIPopoverController(contentViewController: alert)
            self.popover!.presentPopoverFromRect(self.buttonphoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            self.picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.picker?.cameraDevice = .Front
            self.picker?.cameraCaptureMode = .Photo
            self.picker?.allowsEditing = true
            self.picker?.showsCameraControls = true
            self.presentViewController(self.picker!, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    
    
    func openGallery()
    {
        self.picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.picker?.allowsEditing = true
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(self.picker!, animated: true, completion: nil)
        }
        else
        {
            self.popover = UIPopoverController(contentViewController: self.picker!)
            self.popover!.presentPopoverFromRect(self.buttonphoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.image = image
        self.buttonphoto.setImage(image, forState: .Normal)
        self.buttonphoto.imageView?.clipsToBounds = true
        self.buttonphoto.clipsToBounds = true
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("picker cancel")
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    func register()
    {
        //todos os campos preenchidos
        if (self.labelEmail.text != "" && self.labelUsername.text != "" && self.labelPassword.text != "" && self.labelConfirmPassword.text != "")
        {
            //verifica se e-mail é válido
            if (!(DAOUser.sharedInstance.isValidEmail(self.labelEmail.text!)))
            {
                let alert = UIAlertView(title: "Oops!", message: "Please, enter a valid email", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
            //verifica se há espaço em branco no username
            else if (self.verifyWhiteSpace(self.labelUsername.text!))
            {
                let alert = UIAlertView(title: "Oops!", message: "A username can't have white spaces", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
            //verifica se há caracter especial no username
            else if (self.verifySpecialCharacter(self.labelUsername.text!))
            {
                let alert = UIAlertView(title: "Oops!", message: "A username can't have special characters", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
            //verifica se username contém menos de 4 caracteres
            else if (self.labelUsername.text?.characters.count < 4)
            {
                let alert = UIAlertView(title: "Oops!", message: "A username must have, at least, 4 characters", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
            //verifica se senha é válida
            else if ((self.verifyInvalidPassword(labelPassword.text!)) || (self.verifyInvalidPassword(labelConfirmPassword.text!)))
            {
                let alert = UIAlertView(title: "Oops!", message: "Your password must have, exactly, 6 numbers", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
            //verifica se campos de senha e confirmação de senha são iguais
            else if (self.labelPassword.text != self.labelConfirmPassword.text)
            {
                let alert = UIAlertView(title: "Oops!", message: "Passwords don't match!", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
            //verifica se tem foto
            else if(self.image == nil)
            {
                let alert = UIAlertView(title: "Oops!", message: "Please, take a photo", delegate: nil, cancelButtonTitle: "Ok")
                alert.show()
            }
            
            //está tudo ok com o preenchimento dos campos de registro
            else
            {
                self.view.endEditing(true)
                self.loadingScreen = LoadScreen_View()
                self.view.addSubview(loadingScreen)
                DAOUser.sharedInstance.registerUser(labelUsername.text!, email: labelEmail.text!, password: labelPassword.text!, photo: self.image!)
            }
            
        }
            
        //não preencheu todos os campos
        else
        {
            let alert = UIAlertView(title: "Oops!", message: "Please, fill in the fields correctly", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
        
        
    }

    func emailInUse()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Oops!", message: "This email is already used", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func userAlreadyExist()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Oops!", message: "This username already exists", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    func userLogged()
    {
        self.loadingScreen.removeFromSuperview()
        let privacy = Privacy_ViewController()
        self.presentViewController(privacy, animated: true, completion: nil)
    }

    func loginCanceled()
    {
        self.loadingScreen.removeFromSuperview()
        let alert = UIAlertView(title: "Login failed", message: "Please, try again", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func cancel(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true
            , completion: nil)
    }
    
    func verifySpecialCharacter(username: String) -> Bool
    {
        let characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789_.-")
        let searchTerm = username
        if ((searchTerm.rangeOfCharacterFromSet(characterSet.invertedSet)) != nil)
        {
            print("special characters found")
            return true
        }
        return false
    }
    
    func verifyWhiteSpace (username: String) -> Bool
    {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        
        let range = username.rangeOfCharacterFromSet(whitespace)
        
        // range will be nil if no whitespace is found
        if (range != nil) {
            print("whitespace found")
            return true
        }
        else
        {
            print("whitespace not found")
            return false
        }
    }
    
    func verifyInvalidPassword (password: String) -> Bool
    {
        let characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "0123456789")
        let searchTerm = password
        if ((searchTerm.rangeOfCharacterFromSet(characterSet.invertedSet)) != nil)
        {
            print("senha não contém só números")
            return true
        }
        else if (password.characters.count != 6)
        {
            print("senha deve conter 6 números")
            return true
        }
        return false
    }
    
    
}
