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
    
    var buttonView : UIImageView!
    
    var picker : UIImagePickerController? = UIImagePickerController()
    
    var popover : UIPopoverController? = nil
    
    @IBOutlet weak var buttonphoto: UIButton!

    @IBOutlet var labelEmail: UITextField!
    
    @IBOutlet var labelUsername: UITextField!
    
    @IBOutlet var labelSenha: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "next", name: UserCondition.userLogged.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userAlreadyRegistered", name: UserCondition.userAlreadyExist.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "emailInUse", name: UserCondition.emailInUse.rawValue, object: nil)
        
        self.picker!.delegate = self

        self.buttonphoto.clipsToBounds = true
        
        self.buttonView = UIImageView()
        self.buttonView.frame = CGRectMake(0, 0, self.buttonphoto.frame.width, self.buttonphoto.frame.height)
        self.buttonphoto.addSubview(buttonView)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func photoButtonClicked(sender: AnyObject)
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
            popover = UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(buttonphoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    
    func openGallery()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover = UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(buttonphoto.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.image = image
        self.buttonView.image = image
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("picker cancel")
    }
    
    
    @IBAction func register(sender: UIButton)
    {
//        DAOUser.registerUser(labelUsername.text!, email: labelEmail.text!, password: labelSenha.text!, photo: self.image!)
    }

    func next()
    {
        let chat = Chat_ViewController(nibName: "Chat_ViewController", bundle: nil)
        self.presentViewController(chat, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }

    func userAlreadyRegistered()
    {
        let alert = UIAlertView(title: "Ops!", message: "Ja existe um usuario com o nome de usuario desejado", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
    
    
    func emailInUse()
    {
        let alert = UIAlertView(title: "Ops!", message: "Ja existe um usuario com o email utilizado", delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }
}
