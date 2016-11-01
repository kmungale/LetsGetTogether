//
//  Event.swift
//  iOS-project-16
//
//  Created by macbook_user on 10/29/16.
//  Copyright © 2016 Kaustubh. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding {
    
    var eventName: String
    var eventDescription: String
    var dateAndTime: String
    var mapLocation: String
    var maxCount: Int
    
    init?(name: String, description: String, dateAndTime: String, mapLocation: String, maxCount: Int) {
        self.eventName = name
        self.eventDescription = description
        self.dateAndTime = dateAndTime
        self.mapLocation = mapLocation
        self.maxCount = maxCount
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(eventName, forKey: "eventName")
        aCoder.encode(eventDescription, forKey: "eventDescription")
        aCoder.encode(dateAndTime, forKey: "dateAndTime")
        aCoder.encode(mapLocation, forKey: "mapLocation")
        aCoder.encode(maxCount, forKey: "maxCount")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let eventName = aDecoder.decodeObject(forKey: "eventName") as! String
        let eventDescription = aDecoder.decodeObject(forKey: "eventDescription") as! String
        let dateAndTime = aDecoder.decodeObject(forKey: "dateAndTime") as! String
        let mapLocation = aDecoder.decodeObject(forKey: "mapLocation") as! String
        let maxCount = aDecoder.decodeInt32(forKey: "maxCount")
        self.init(name: eventName, description: eventDescription, dateAndTime: dateAndTime, mapLocation: mapLocation, maxCount: Int(maxCount))
    }
    
}
