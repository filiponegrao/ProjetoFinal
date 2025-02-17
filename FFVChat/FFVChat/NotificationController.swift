//
//  NotificationController.swift
//  FFVChat
//
//  Created by Filipo Negrao on 31/10/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import UIKit
import Foundation

private let data : NotificationController = NotificationController()

class NotificationController: NSObject
{
    var friendRequest : NSNotification!
    
    var requestAccepted : NSNotification!
    
    var messageReceived : NSNotification!
    
    var messageSent : NSNotification!
    
    var messageNotSent : NSNotification!
    
    var friendAdded : NSNotification!
    
    var friendRequested : NSNotification!
    
    var messageEvaporated : NSNotification!
    
    var trustLevelRefresehd : NSNotification!
    
    var contactsRefresheded : NSNotification!
    
    var printScreenReceived : NSNotification!
    
    var gifDownloaded : NSNotification!
        
    override init()
    {
        self.friendRequest = NSNotification(name: "friendRequest", object: NSMutableDictionary())
        self.requestAccepted = NSNotification(name: "requestAccepted", object: nil)
        self.messageReceived = NSNotification(name: "messageReceived", object: nil)
        self.messageSent = NSNotification(name: "messageSent", object: nil)
        self.messageNotSent = NSNotification(name: "messageNotSent", object: nil)
        self.friendAdded = NSNotification(name: "friendAdded", object: nil)
        self.friendRequested = NSNotification(name: "friendRequested", object: nil)
        self.messageEvaporated = NSNotification(name: "messageEvaporated", object: nil, userInfo: nil)
        self.trustLevelRefresehd = NSNotification(name: "trustLevelRefresehd", object: nil)
        self.contactsRefresheded = NSNotification(name: "contactsRefresheded", object: nil)
        self.printScreenReceived = NSNotification(name: "printScreenReceived", object: nil)
        self.gifDownloaded = NSNotification(name: "gifDownloaded", object: nil)
    }
    
    class var center : NotificationController
    {
        return data
    }
    

}

/* This information is used between notifications from
 * diferent phones
 */
public enum appNotification : String
{
    case friendRequest
    
    case requestAccepted
    
    case messageReceived
    
    case printscreen
}


