//
//  RecentChat.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-26.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentChat: Codable {
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    @ServerTimestamp var date = Date()
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
}
