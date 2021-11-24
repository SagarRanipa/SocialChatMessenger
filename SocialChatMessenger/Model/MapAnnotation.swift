//
//  MapAnnotation.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-09-07.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
    
}
