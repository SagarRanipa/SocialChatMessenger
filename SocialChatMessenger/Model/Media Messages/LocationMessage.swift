//
//  LocationMessage.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-09-07.
//

import Foundation
import CoreLocation
import MessageKit

class LocationMessage: NSObject, LocationItem  {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}
