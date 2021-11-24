//
//  FCollectionReference.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum FCollectionReference: String {
    case User
    case Recent
    case Messages
    case Typing
    case Channel
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
