//
//  PhotoMessage.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-09-06.
//

import Foundation
import MessageKit

class PhotoMessage: NSObject, MediaItem {
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(path: String) {
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
    
    
}
