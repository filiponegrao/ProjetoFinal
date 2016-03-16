//
//  TutoFirst_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 07/03/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class TutoFirst_ViewController: UIViewController
{
    var index = 0
    
    var image : UIImageView!
    
    var frame : CGRect
    
    init(frame: CGRect)
    {
        self.frame = frame
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.frame = frame

    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.frame = frame
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.image = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        self.image.image = UIImage(named: "ImgTutorial00")
        self.image.contentMode = .ScaleAspectFit
        self.view.addSubview(self.image)
        
        //LOG VALORES LARGURA E ALTURA
        print("Classe: TutoFirst_ViewController (DidLoad)")
        print("Frame TutoFirst_ViewController: \(self.view.frame)")
        print("--------")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
