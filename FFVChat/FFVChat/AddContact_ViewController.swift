//
//  AddContact_ViewController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 07/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit

class AddContact_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate
{
    var results : [metaContact] = [metaContact]()
    
    var backButton : UIButton!
    
    var tableView : UITableView!
    
    var searchBar : UISearchBar!
    
    var navBar : NavigationAddContact_View!
    
    var delay : NSTimer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = oficialMediumGray
        self.navigationController?.navigationBar.hidden = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "doneSearch"))
        
        self.navBar = NavigationAddContact_View(requester: self)
        self.navBar.tittle.font = UIFont(name: "SukhumvitSet-Medium", size: 22)
        self.view.addSubview(self.navBar)
        
//        self.backButton = UIButton(frame: CGRectMake(0, 20, 50, 50))
//        self.backButton.setImage(UIImage(named: "quitButton"), forState: .Normal)
//        self.backButton.addTarget(self, action: "quitSearch", forControlEvents: .TouchUpInside)
//        self.view.addSubview(self.backButton)
        
        self.searchBar = UISearchBar(frame: CGRectMake(10, 80, screenWidth - 20, 30))
        self.searchBar.delegate = self
        self.searchBar.autocapitalizationType = .None
        self.searchBar.autocorrectionType = .No
        self.searchBar.searchBarStyle = .Minimal
//        self.searchBar.barTintColor = oficialSemiGray
        self.searchBar.tintColor = oficialGreen
//        self.searchBar.barStyle = .Default
        self.searchBar.becomeFirstResponder()
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.Dark
        self.searchBar.placeholder = "Search for a username"
        self.view.addSubview(self.searchBar)
        
        let textFieldInsideSearchBar = self.searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = oficialLightGray
        textFieldInsideSearchBar?.font = UIFont(name: "SukhumvitSet-Light", size: 14)
        

//        searchSubviewsForTextFieldIn(self.searchBar)
        
        self.tableView = UITableView(frame: CGRectMake(0, 115, screenWidth, screenHeight))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.tableView.registerClass(CellAdd_TableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell2")
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.tableView)
    
    }

    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBar.hidden = true
//        let bar : UINavigationBar! =  self.navigationController?.navigationBar
//        
//        bar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        bar.shadowImage = UIImage()
//        bar.barTintColor = oficialDarkGray
//        bar.tintColor = oficialGreen
//        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        bar.titleTextAttributes = titleDict as? [String : AnyObject]
//        self.title = "Search"
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButton"), style: UIBarButtonItemStyle.Done, target: self, action: "back")
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : oficialGreen]
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    override func viewDidLayoutSubviews()
    {
        self.navBar.tittle.font = self.navBar.tittle.font.fontWithSize(22)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    //** SEARCH BAR FUNCTONS ***//
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.delay?.invalidate()
        self.delay = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: "reloadResults", userInfo: nil, repeats: false)
    }
    
    //TENTATIVA DE MUDAR COR DE FUNDO
//    func searchSubviewsForTextFieldIn(view: UIView)
//    {
//        for view in searchBar.subviews
//        {
//            for subview in view.subviews
//            {
//                if subview .isKindOfClass(UITextField)
//                {
//                    let textField: UITextField = subview as! UITextField
//                    textField.backgroundColor = UIColor.lightGrayColor()
//                }
//            }
//        }
//    }
    
    func reloadResults()
    {
        if(self.searchBar.text?.characters.count > 1)
        {
            DAOParse.getUsersWithString(self.searchBar.text!) { (contacts) -> Void in
                
                self.results = contacts
                self.tableView.reloadData()
            }
        }
        else if(self.searchBar.text?.characters.count == 0)
        {
            self.results = [metaContact]()
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        if(self.searchBar.text?.characters.count > 1)
        {
            DAOParse.getUsersWithString(self.searchBar.text!) { (contacts) -> Void in
                
                self.results = contacts
                self.tableView.reloadData()
            }
        }
    }
    
    func doneSearch()
    {
        self.searchBar.endEditing(true)
    }
    
    //** END SEARCH BAR FUNCTIONS **//
    
    
    //** TABLE VIEW PROPERTIES *********//
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(results.count == 0)
        {
            return 1
        }
        else
        {
            return results.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
    
        if(self.results.count == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell2", forIndexPath: indexPath)
            cell.textLabel?.text = "No results."
            cell.textLabel?.textAlignment = .Center
            cell.textLabel?.textColor = oficialLightGray
            cell.textLabel?.font = UIFont(name: "SukhumvitSet-Text", size: 17)
            cell.backgroundColor = UIColor.clearColor()
            
            let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 4))
            separatorLineView.backgroundColor = oficialMediumGray
            cell.contentView.addSubview(separatorLineView)

            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CellAdd_TableViewCell
            
            let username = self.results[indexPath.row].username
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.photo.frame = CGRectMake(10, 10, cell.frame.size.height - 20, cell.frame.size.height - 20)
            cell.photo.layer.cornerRadius = cell.photo.frame.size.height/2
            cell.username.text = username
            cell.username.frame = CGRectMake(20 + cell.photo.frame.size.width, 15, screenWidth/3 * 2, 20)
            cell.invitedLabel.frame = CGRectMake(cell.username.frame.origin.x, cell.username.frame.origin.y + cell.username.frame.size.height, screenWidth/3 * 2, 20)
            
            cell.addButton.frame = CGRectMake(screenWidth - screenWidth/8 - 10, 15, screenWidth/8, screenWidth/8)
            cell.invited.frame = CGRectMake(screenWidth - screenWidth/8 - 10, 15, screenWidth/8, screenWidth/8)
                 
            let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 3))
            separatorLineView.backgroundColor = oficialMediumGray
            
            DAOFriendRequests.sharedInstance.wasAlreadyRequested(username, callback: { (was) -> Void in
                if(was)
                {
                    cell.addButton.hidden = false
                    cell.invited.hidden = true
                    cell.invitedLabel.hidden = true
                }
                else
                {
                    cell.addButton.hidden = true
                    cell.invited.hidden = false
                    cell.invitedLabel.hidden = false
                }
            })
            
            cell.photo.image = self.results[indexPath.row].photo
            
            cell.backgroundColor = oficialSemiGray
            cell.contentView.addSubview(separatorLineView)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.searchBar.endEditing(true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 70
    }
        
    //** TABLE VIEW PROPRIETS END ******//
    
    
    //** CONTROLLER MANAGEMENT FUNCTIONS ****//
    func quitSearch()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    


}


