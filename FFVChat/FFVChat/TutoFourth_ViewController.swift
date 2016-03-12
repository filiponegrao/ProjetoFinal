//
//  TutoFourth_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 07/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoFourth_ViewController: UIViewController
{
    var index = 3

    var image : UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialDarkGreen

        self.image = UIImageView(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
        self.image.image = UIImage(named: "ImgTutorial30")
        self.image.center = self.view.center
        self.image.backgroundColor = oficialGreen
        self.image.contentMode = .ScaleAspectFit
        self.view.addSubview(self.image)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
