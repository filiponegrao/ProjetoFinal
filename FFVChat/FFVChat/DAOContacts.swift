//
//  DAOContacts.swift
//  FFVChat
//
//  Created by Filipo Negrao on 24/09/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import UIKit
import CoreData

private let data : DAOContacts = DAOContacts()

class DAOContacts
{
    var lastContactAdded : Contact!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    init()
    {
        
    }
    
    class var sharedInstance : DAOContacts
    {
        return data
    }
    
    
    
    func getAllContacts() -> [Contact]
    {
        var contacts = [Contact]()
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        
        do { let result = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            
            if result.count > 0
            {
                contacts = result
                return contacts
            }
        }
        catch
        {
            return contacts
        }
        return contacts
    }
    
    
    func getFavorites() -> [Contact]
    {
        var contacts = [Contact]()
        
        let predicate = NSPredicate(format: "isFavorit == %@", true)
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "username", ascending: true)]
        
        do { let result = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            
            if result.count > 0
            {
                contacts = result
                return contacts
            }
        }
        catch
        {
            return contacts
        }
        return contacts
    }
    
    func getContact(username: String) -> Contact?
    {
        let predicate = NSPredicate(format: "username == %@", username)
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        fetchRequest.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            
            if(results.count == 1)
            {
                return results[0]
            }
                //Tratamento de inconsistencia de contatos
            else if results.count > 1
            {
                for(var i = 1; i < results.count; i++)
                {
                    self.managedObjectContext.deleteObject(results[i])
                }
                return results[0]
            }
                //Vazio
            else
            {
                return nil
            }
        }
        catch
        {
            return nil
        }
    }
    
    
    func deleteContact(username: String) -> Bool
    {
        let predicate = NSPredicate(format: "username == %@", username)
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        fetchRequest.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            
            for result in results
            {
                self.managedObjectContext.deleteObject(result)
            }
            BlackList.addOnBlackList(username)
            self.save()

            return true
        }
        catch
        {
            return false
        }
        
    }
    
    
    func addContact(username: String, facebookId: String?, createdAt: NSDate, trustLevel: Int, profileImage: NSData?)
    {
        if(!self.isContact(username))
        {
            let contact = Contact.createInManagedObjectContext(self.managedObjectContext, username: username, facebookId: facebookId, createdAt: createdAt, trustLevel: trustLevel, profileImage: profileImage)
            self.save()
            
            self.lastContactAdded = contact
            
            NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.friendAdded)
            
        }
    }
    
    
    
    
    
    class func searchUsersWithString(string: String, callback: (result: [metaContact]) -> Void) -> Void
    {
        DAOParse.getUsersWithString(string) { (contact) -> Void in
            
            callback(result: contact)
        }
    }
    
    
    func isContact(username: String) -> Bool
    {
        let predicate = NSPredicate(format: "username == %@", username)
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        fetchRequest.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            
            if(results.count > 0)
            {
                return true
            }
            else
            {
                return false
            }
            
        }
        catch
        {
            return false
        }
    }
    
    
    func refreshContacts()
    {
        let contacts = self.getAllContacts()
        let cont = contacts.count
        var i = 0
        
        for contact in contacts
        {
            DAOParse.refreshContact(contact.username, callback: { (trustLevel, image) -> Void in
                
                if(trustLevel != nil)
                {
                    contact.trustLevel = trustLevel
                }
                if(image != nil)
                {
                    contact.profileImage = image
                    contact.thumb = UIImage(data: image!)?.lowestQualityJPEGNSData
                    contact.lastUpdate = NSDate()
                }
                self.save()
                i++
                if((i+1) == cont)
                {
                    NSNotificationCenter.defaultCenter().postNotification(NotificationController.center.contactsRefresheded)
                }
            })
        }
    }
    
    
    func getContactByUsername(username: String) -> Contact?
    {
        let predicate = NSPredicate(format: "username == %@", username)
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        fetchRequest.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            
            if(results.count > 0)
            {
                return results.first
            }
        }
        catch
        {
            return nil
        }
        
        return nil
    }
    
    func getLastUpdateContact(username: String) -> NSDate?
    {
        let predicate = NSPredicate(format: "username == %@", username)
        
        let fetchRequest = NSFetchRequest(entityName: "Contact")
        fetchRequest.predicate = predicate
        
        do { let results = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [Contact]
            
            if(results.count > 0)
            {
                return results.first?.lastUpdate
            }
        }
        catch
        {
            return nil
        }
        
        return nil
    }
    
    func getContactsWithString(string: String) -> [Contact]
    {
        var result = [Contact]()
        
        let contacts = self.getAllContacts()
        for contact in contacts
        {
            if contact.username.lowercaseString.rangeOfString(string.lowercaseString) != nil {
                result.append(contact)
            }
        }
        
        return result
    }
    
    func getFavouritesWithString(string: String) -> [Contact]
    {
        var result = [Contact]()
        
        let contacts = self.getAllContacts()
        for contact in contacts
        {
            if ((contact.username.lowercaseString.rangeOfString(string.lowercaseString) != nil) && contact.isFavorit == true)
            {
                result.append(contact)
            }
        }
        
        return result
    }
    
    
    func setFavorite(contact: Contact)
    {
        contact.isFavorit = true
        self.save()
    }
    
    func setNonFavorite(contact: Contact)
    {
        contact.isFavorit = false
        self.save()
    }
    
    func save()
    {
        do { try self.managedObjectContext.save() }
        catch let error
        {
            print(error)
        }
    }
}





