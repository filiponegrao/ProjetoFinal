//
//  Chat_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 13/09/15.
//  Copyright (c) 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class Chat_ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        print(DAOUser.getUserName())
        print(DAOUser.getEmail())
        print(DAOUser.getPassword())
        print(DAOUser.getTrustLevel())
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    @IBAction func logOut(sender: UIButton)
    {
        DAOUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
