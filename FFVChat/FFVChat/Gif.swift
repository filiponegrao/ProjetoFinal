//
//  Gif.swift
//  FFVChat
//
//  Created by Filipo Negrao on 18/12/15.
//  Copyright © 2015 FilipoNegrao. All rights reserved.
//

import Foundation
import CoreData

extension Gif {
    
    @NSManaged var url: String!
    @NSManaged var hashtags: NSData!
    @NSManaged var launchedDate: NSDate!
    @NSManaged var name: String!
    
}

class Gif: NSManagedObject
{
    class func createInManagedObjectContext(moc: NSManagedObjectContext, url: String, hashtags: NSData, name: String, launchedDate: NSDate) -> Gif
    {
        let gif = NSEntityDescription.insertNewObjectForEntityForName("Gif", inManagedObjectContext: moc) as! Gif
        
        gif.name = name
        gif.url = url
        gif.hashtags = hashtags
        gif.launchedDate = launchedDate
        
        return gif
    }
    
}
