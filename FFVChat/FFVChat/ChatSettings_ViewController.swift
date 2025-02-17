//
//  ChatSettings_ViewController.swift
//  FFVChat
//
//  Created by Fernanda Carvalho on 28/01/16.
//  Copyright © 2016 FilipoNegrao. All rights reserved.
//

import UIKit

class ChatSettings_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var navBar : UIView!
    
    var tittle : UILabel!
    
    var backButton : UIButton!
    
    var tableView : UITableView!
    
    let section = ["Lifespan for messages", "Background", "Clean all conversations", "Clean all galleries"]
    
    var pickerView : UIPickerView!
    
    var lifespanField : UITextField! //exibe lifespan pro usuário
    
    var lifespanValue : Int!  //valor salvo no bd em minutos
    
    var lifespanText : String!  //armazena valor do picker view enquanto está sendo alterado
    
    let hours = Array(0...24)
    
    let minutes = Array(0...59)
    
    var hou : Int!  //lifespan em horas
    
    var min : Int!  //lifespan em minutos
    
    var imagePickerSheet : ImagePickerSheetController!
    
    var imageArray : [UIImage]!
    
    var cancelButton : UIButton!
    
    var saveButton : UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.view.backgroundColor = oficialMediumGray
    
        
        //VIEW NAVBAR//
        self.navBar = UIView(frame: CGRectMake(0, 0, screenWidth, 70))
        self.navBar.backgroundColor = oficialDarkGray
        self.view.addSubview(self.navBar)
        
        //TITULO NAVBAR//
        self.tittle = UILabel(frame: CGRectMake(0, 25, screenWidth, 35))
        self.tittle.text = "Chat"
        self.tittle.font = UIFont(name: "SukhumvitSet-Medium", size: 22)
        self.tittle.textAlignment = .Center
        self.tittle.textColor = oficialGreen
        self.view.addSubview(self.tittle)
        
        
        //TABLEVIEW//
        self.tableView = UITableView(frame: CGRectMake(0, self.navBar.frame.size.height - 40, screenWidth, screenHeight - self.navBar.frame.size.height + 40), style: .Grouped)
        self.tableView.layer.zPosition = -5
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView)
        
        
        //BOTAO BACK NAVBAR//
        self.backButton = UIButton(frame: CGRectMake(0, 20, 45, 45))
        self.backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        self.backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.backButton)

        
        //PICKER VIEW//
        self.pickerView = UIPickerView(frame: CGRectMake(0,screenHeight - (screenHeight/2.5), screenWidth, screenHeight/3.5))
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.backgroundColor = oficialDarkGray
        
        //TOOLBAR E BOTOES PICKERVIEW//
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.BlackOpaque
//        toolBar.translucent = true
//        toolBar.backgroundColor = oficialSemiGray
//        toolBar.layer.borderColor = UIColor.clearColor().CGColor
//        toolBar.layer.borderWidth = 0
//        toolBar.clipsToBounds = true
//        toolBar.tintColor = oficialGreen
//        toolBar.sizeToFit()
        
//        let subView = toolBar.subviews.last
//        if((subView?.isKindOfClass(UIImageView)) != nil)
//        {
//            subView?.hidden = false
//            subView?.backgroundColor = oficialDarkGray
//        }
//        
//        let doneButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Bordered, target: self, action: "donePicker")
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelPicker")
//        
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.userInteractionEnabled = true
        
        
        let barView = UIView(frame: CGRectMake(0, 0, screenWidth, 40))
        barView.backgroundColor = oficialGreen
        
        self.cancelButton = UIButton(frame: CGRectMake(15, 0, screenWidth/2 - 10, 40))
        self.cancelButton.setTitle("Cancel", forState: .Normal)
        self.cancelButton.addTarget(self, action: "cancelPicker", forControlEvents: .TouchUpInside)
        self.cancelButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.cancelButton.titleLabel?.textAlignment = .Left
        self.cancelButton.titleLabel?.font = UIFont(name: "SukhumvitSet-Medium", size: 17)
        
        self.saveButton = UIButton(frame: CGRectMake(screenWidth/2, 0, screenWidth/2 - 15, 40))
        self.saveButton.setTitle("Save", forState: .Normal)
        self.saveButton.addTarget(self, action: "donePicker", forControlEvents: .TouchUpInside)
        self.saveButton.setTitleColor(oficialDarkGray, forState: .Normal)
        self.saveButton.contentHorizontalAlignment = .Right
        self.saveButton.titleLabel?.font = UIFont(name: "SukhumvitSet-Medium", size: 17)
        
        barView.addSubview(self.cancelButton)
        barView.addSubview(self.saveButton)
        
        //TEXT FIELD//
        self.lifespanField = UITextField(frame: CGRectMake(15, 25 + tittle.frame.size.height, screenWidth/3 * 1.7, 30))
        self.lifespanField.backgroundColor = oficialSemiGray
        self.lifespanField.tintColor = oficialLightGray
        self.lifespanField.textColor = oficialLightGray
        self.lifespanField.font = UIFont(name: "SukhumvitSet-Text", size: 18)
        self.lifespanField.borderStyle = .RoundedRect
        self.lifespanField.delegate = self
        self.lifespanField.inputView = self.pickerView
        self.lifespanField.inputAccessoryView = barView
        self.lifespanField.autocorrectionType = .No
        self.lifespanField.selected = false
        
        self.imageArray = [UIImage(named: "blueSky")!, UIImage(named: "darkSky")!, UIImage(named: "redSky")!, UIImage(named: "redSky2")!]
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //pegar info bd
        self.lifespanValue = UserLayoutSettings.sharedInstance.getCurrentMinutesTextLifespan()
        
        //pegando valor em minutos e salvando em horas e minutos
        let savedHour = self.lifespanValue / 60
        let savedMinutes = self.lifespanValue % 60
        
        //pro texto ficar correto plural / singular
        if(savedHour == 0)
        {
            self.lifespanText = "\(savedMinutes) min"
        }
        else if(savedHour == 1)
        {
            if(savedMinutes != 0)
            {
                self.lifespanText = "\(savedHour) hour" + " \(savedMinutes) min"
            }
            else
            {
                self.lifespanText = "\(savedHour) hour"
            }
        }
        else
        {
            if(savedMinutes != 0)
            {
                self.lifespanText = "\(savedHour) hours" + " \(savedMinutes) min"
            }
            else
            {
                self.lifespanText = "\(savedHour) hours"
            }
        }
        
        //atualiza text field
        self.lifespanField.text = self.lifespanText
        
        self.pickerView.selectRow(savedHour, inComponent: 0, animated: true)
        self.pickerView.selectRow(savedMinutes, inComponent: 1, animated: true)
        
        //valores picker view//
        self.hou = savedHour
        self.min = savedMinutes

    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()
    {
        self.tittle.setSizeFont(22)
    }
    
    //TEXT FIELD
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
        self.lifespanField.resignFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool
    {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        
    }
    
//    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool
//    {
//        //NAO ADIANTOU OU NAO ESTOU SABENDO USAR
//        if (action == "copy:" || action == "cut:" || action == "paste:" || action == "select:" || action == "selectAll:")
//        {
//            return false
//        }
//
//        
//        return super.canPerformAction(action, withSender:sender)
//    }
//    
//    override func targetForAction(action: Selector, withSender sender: AnyObject?) -> AnyObject?
//    {
//        //NAO ADIANTOU OU NAO ESTOU SABENDO USAR
//        if (action == "copy:" || action == "cut:" || action == "paste:" || action == "select:" || action == "selectAll:")
//        {
//            return nil
//        }
//        
//        return super.targetForAction(action, withSender: sender)
//    }
    
    //FIM TEXT FIELD
    
    //TABLEVIEW PROPERTIES//
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            return screenWidth/2 - 20
        }
        else if(indexPath.section == 0 && indexPath.row == 1)
        {
            return 50
        }
        else if(indexPath.section == 0 && indexPath.row == 2)
        {
            return screenWidth/4 + 50
        }
        else if(indexPath.section == 0 && indexPath.row == 3)
        {
            return screenWidth/4 + 50
        }
        
        return 50
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.backgroundColor = oficialSemiGray
        cell.textLabel?.textColor = oficialLightGray
        
        let separatorLineView = UIView(frame: CGRectMake(0, 0, screenWidth, 4))
        separatorLineView.backgroundColor = oficialMediumGray
        cell.addSubview(separatorLineView)
        cell.selectionStyle = .None
        
        
        if(indexPath.row == 0)
        {
            let tittle = UILabel(frame: CGRectMake(15, 25, screenWidth, 30))
            tittle.text = self.section[indexPath.row]
            tittle.textColor = oficialLightGray
            tittle.font = UIFont(name: "SukhumvitSet-Light", size: 18)
            cell.addSubview(tittle)
            cell.backgroundColor = UIColor.clearColor()
            separatorLineView.backgroundColor = UIColor.clearColor()
            
            let description = UITextView(frame: CGRectMake(10, cell.frame.size.height - screenWidth/6, screenWidth - 20, screenWidth/6))
            description.text = "Time from which messages will disappear after they have been read (including audios and gifs)."
            description.textColor = oficialLightGray
            description.textAlignment = .Left
            description.font = UIFont(name: "Helvetica-Light", size: 13)
            description.alpha = 0.8
            description.backgroundColor = UIColor.clearColor()
            description.userInteractionEnabled = false
            cell.addSubview(description)
            
            cell.addSubview(self.lifespanField)
        }
        else if(indexPath.row == 1)
        {
            let viewCell = UIView(frame: CGRectMake(0, 0, screenWidth, 50))
            viewCell.backgroundColor = oficialSemiGray
            cell.addSubview(viewCell)
            
            let backgroundButton = MKButton(frame: CGRectMake(0, 0, screenWidth, 50))
            backgroundButton.setTitleColor(oficialLightGray, forState: .Normal)
            backgroundButton.addTarget(self, action: "changeBackground", forControlEvents: .TouchUpInside)
            backgroundButton.rippleLocation = .Center
            backgroundButton.rippleLayerColor = oficialDarkGray
            backgroundButton.ripplePercent = 200
            viewCell.addSubview(backgroundButton)
            
            
            let backgroundLabel = UILabel(frame: CGRectMake(15,10, screenWidth - 15, 30))
            backgroundLabel.textColor = oficialLightGray
            backgroundLabel.text = self.section[indexPath.row]
            backgroundLabel.font = UIFont(name: "SukhumvitSet-Light", size: 18)
            backgroundButton.addSubview(backgroundLabel)
            
            cell.backgroundColor = UIColor.clearColor()
        }
        else if(indexPath.row == 2)
        {
            let viewCell = UIView(frame: CGRectMake(0, 10, screenWidth, 50))
            viewCell.backgroundColor = oficialSemiGray
            cell.addSubview(viewCell)
            
            let tittleButton = MKButton(frame: CGRectMake(0, 0, screenWidth, 50))
//            tittleButton.setTitleColor(oficialLightGray, forState: .Normal)
            tittleButton.addTarget(self, action: "cleanConversations", forControlEvents: .TouchUpInside)
            tittleButton.contentHorizontalAlignment = .Left
            tittleButton.rippleLocation = .Center
            tittleButton.rippleLayerColor = oficialDarkGray
            tittleButton.ripplePercent = 200
            viewCell.addSubview(tittleButton)
            
            let tittleLabel = UILabel(frame: CGRectMake(15,10, screenWidth - 15, 30))
            tittleLabel.text = self.section[indexPath.row]
            tittleLabel.textColor = oficialLightGray
            tittleLabel.font = UIFont(name: "SukhumvitSet-Light", size: 18)
            tittleButton.addSubview(tittleLabel)
            
            let description = UITextView(frame: CGRectMake(10, 60, screenWidth - 20, screenWidth/5))
            description.text = "It clears immediately all current conversations (even if the messages' lifespan has not finished yet)."
            description.textColor = oficialLightGray
            description.textAlignment = .Left
            description.font = UIFont(name: "Helvetica-Light", size: 13)
            description.alpha = 0.8
            description.backgroundColor = UIColor.clearColor()
            description.userInteractionEnabled = false
            cell.addSubview(description)
            
            cell.backgroundColor = UIColor.clearColor()
        }
        else if(indexPath.row == 3)
        {
            
            let viewCell = UIView(frame: CGRectMake(0, 10, screenWidth, 50))
            viewCell.backgroundColor = oficialSemiGray
            cell.addSubview(viewCell)
            
            let tittleButton = MKButton(frame: CGRectMake(0, 0, screenWidth, 50))
//            tittleButton.setTitleColor(oficialLightGray, forState: .Normal)
            tittleButton.addTarget(self, action: "cleanGalleries", forControlEvents: .TouchUpInside)
            tittleButton.contentHorizontalAlignment = .Left
            tittleButton.rippleLocation = .Center
            tittleButton.rippleLayerColor = oficialDarkGray
            tittleButton.ripplePercent = 200
            viewCell.addSubview(tittleButton)
            
            let tittleLabel = UILabel(frame: CGRectMake(15,10, screenWidth, 30))
            tittleLabel.text = self.section[indexPath.row]
            tittleLabel.font = UIFont(name: "SukhumvitSet-Light", size: 18)
            tittleLabel.textColor = oficialLightGray
            tittleButton.addSubview(tittleLabel)
            
            let description = UITextView(frame: CGRectMake(10, 60, screenWidth - 20, screenWidth/5))
            description.text = "it clears all chat galleries by removing all medias you’ve sent for any contact."
            description.textColor = oficialLightGray
            description.textAlignment = .Left
            description.font = UIFont(name: "Helvetica-Light", size: 13)
            description.alpha = 0.8
            description.backgroundColor = UIColor.clearColor()
            description.userInteractionEnabled = false
            cell.addSubview(description)
            
            cell.backgroundColor = UIColor.clearColor()

        }
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        textFieldDidEndEditing(self.lifespanField)
        self.lifespanField.resignFirstResponder()
    }
    
    //FIM TABLEVIEW PROPERTIES//
    
    //PICKER VIEW PROPERTIES//
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if(component == 0)
        {
            return hours.count
        }
        else
        {
            return minutes.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if(component == 0)
        {
            return String(hours[row])
        }
        else
        {
            return String(minutes[row])
        }
    }
    
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let view = UIView(frame: CGRectMake(0,0,pickerView.frame.size.height, 20))
        view.backgroundColor = UIColor.clearColor()
        
        if component == 0
        {
            let number = UILabel(frame: view.frame)
            
            if(self.hours[row] == 0)
            {
                number.text = "0"
            }
            else if(self.hours[row] == 1)
            {
                number.text = "\(self.hours[row]) hour"
            }
            else
            {
                number.text = "\(self.hours[row]) hours"
            }
            
            number.textAlignment = .Center
            number.textColor = UIColor.whiteColor()
            view.addSubview(number)
        }
        else
        {
            let number = UILabel(frame: view.frame)

            if(self.minutes[row] == 0)
            {
                number.text = "0"
            }
            else if(self.minutes[row] == 1)
            {
                number.text = "\(self.minutes[row]) minute"
            }
            else
            {
                number.text = "\(self.minutes[row]) minutes"
            }
            
            number.textColor = UIColor.whiteColor()
            number.textAlignment = .Center
            view.addSubview(number)
        }
        
        return view
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        if(component == 0)
        {
            //pegando valor selecionado no picker view
            self.hou = self.hours[row]

            //organizando texto que vai pro text field
            if(self.hours[row] == 0)
            {
                if(self.min == 0)
                {
                    self.lifespanText = "0"
                }
                else
                {
                    self.lifespanText = "\(self.min) min"
                }
            }
            else if(self.hours[row] == 1)
            {
                if(self.min == 0)
                {
                    self.lifespanText = "\(self.hou) hour"
                }
                else
                {
                    self.lifespanText = "\(self.hou) hour" + " \(self.min) min"
                }
            }
            else
            {
                if(self.min == 0)
                {
                    self.lifespanText = "\(self.hou) hours"
                }
                else
                {
                    self.lifespanText = "\(self.hou) hours" + " \(self.min) min"
                }
            }
            
        }
        else
        {
            if(self.minutes[row] == 0)
            {
                //pegando valor selecionado no picker view
                self.min = self.minutes[row]
                
                //organizando texto que vai pro text field
                if(self.hou == 0)
                {
                    self.lifespanText = "0"
                }
                else if(self.hou == 1)
                {
                    self.lifespanText = "\(self.hou) hour"
                }
                else
                {
                    self.lifespanText = "\(self.hou) hours"
                }
            }
            else
            {
                //pegando valor selecionado no picker view
                self.min = self.minutes[row]

                //organizando texto que vai pro text field
                if(self.hou == 0)
                {
                    self.lifespanText = "\(self.min) min"
                }
                else if(self.hou == 1)
                {
                    self.lifespanText = "\(self.hou) hour" + " \(self.min) min"
                }
                else
                {
                    self.lifespanText = "\(self.hou) hours" + " \(self.min) min"
                }
            }
        }
        
    }
    
    //FIM PICKER VIEW//
    
    func back()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func donePicker()
    {
        if(self.lifespanText != "0")
        {
            self.lifespanValue = (self.hou * 60) + self.min
            //        print(self.lifespanValue)
            
            //atualiza text field com novo valor configurado
            self.lifespanField.text = self.lifespanText
            self.lifespanField.resignFirstResponder()
            
            //passando info bd
            UserLayoutSettings.sharedInstance.setCurrentSecondsTextLifespan(self.lifespanValue * 60)
            
        }
        else
        {
            let alert = UIAlertController(title: "Oops", message: "You must choose, at least, 1 minute!", preferredStyle: UIAlertControllerStyle.Alert)
            
            let acceptAction = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) -> Void in
                //limpar todas as conversas//
            }
            
            alert.addAction(acceptAction)
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func cancelPicker()
    {
        self.lifespanField.resignFirstResponder()
        
        //retoma picker view com valores originais (últimos salvos)
        self.pickerView.selectRow(self.lifespanValue / 60, inComponent: 0, animated: true)
        self.pickerView.selectRow(self.lifespanValue % 60, inComponent: 1, animated: true)
        
        //retoma valores originais
        self.hou = self.lifespanValue / 60
        self.min = self.lifespanValue % 60
        
    }
    
    func changeBackground()
    {
        self.lifespanField.resignFirstResponder()

        let bg = Backgrounds_ViewController()
        
        self.navigationController?.pushViewController(bg, animated: true)
    }
    
    func cleanConversations()
    {
        self.lifespanField.resignFirstResponder()

        let alert = UIAlertController(title: "Clean all conversations", message: "Are you sure? You cannot undo this action. It clears immediately all current conversations (even if the messages' lifespan has not finished yet).", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in
        }
        
        let acceptAction = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) -> Void in
//            DAOMessages.sharedInstance.clearConversation(username: String)
//            DAOSentMidia.sharedInstance.deleteAllSentMidiaFrom(<#T##contact: String##String#>)
            //Funcoes pra limpar todas as conversas e todas as galerias
        }
        
        alert.addAction(cancelAction)
        alert.addAction(acceptAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func cleanGalleries()
    {
        self.lifespanField.resignFirstResponder()

        let alert = UIAlertController(title: "Clean all galleries", message: "Are you sure? You cannot undo this action. It clears all chat galleries by removing all medias you’ve sent for any contact.", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (UIAlertAction) -> Void in
        }
        
        let acceptAction = UIAlertAction(title: "Ok", style: .Default) { (UIAlertAction) -> Void in
            //limpar todas as galerias//
        }
        
        alert.addAction(cancelAction)
        alert.addAction(acceptAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
