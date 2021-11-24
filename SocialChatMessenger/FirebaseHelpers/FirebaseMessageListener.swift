//
//  FirebaseMessageListener.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-27.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseMessageListener {
    
    static let shared = FirebaseMessageListener()
    var newChatListener: ListenerRegistration!
    var updatedChatListener: ListenerRegistration!
    
    private init() { }
    
    func listenForNewChats(_ documentId: String, collectionId: String, lastMessageDate: Date) {
        newChatListener = FirebaseReference(.Messages).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener({ (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else { return }
            
            for change in snapshot.documentChanges {
                
                if change.type == .added {
                    
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        
                        if let message = messageObject {
                            
                            if message.senderId != User.currentId {
                                RealmManager.shared.saveToRealm(message)
                            }
                        } else {
                            print("Document doesnt exist")
                        }
                        
                    case .failure(let error):
                        print("Error decoding local message: \(error.localizedDescription)")
                    }
                }
            }
        })

    }
    
    func listenForReadStatusChange(_ documentId: String, collectionID: String, completion: @escaping (_ updatedLocalMessage: LocalMessage) -> Void) {
        
        updatedChatListener = FirebaseReference(.Messages).document(documentId).collection(collectionID).addSnapshotListener({ (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else { return }
            
            for change in snapshot.documentChanges {
                
                if change.type == .modified {
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    case .success(let localMessageObject):
                        
                        if let message = localMessageObject {
                            completion(message)
                        } else {
                            print("Document doesn't exists in chat")
                        }
                        
                    case .failure(let error):
                        print("error decoding local Message" , error.localizedDescription)
                    }
                }
            }
        })
    }

    
    func checkForOldChats (_ documentId: String, collectionId: String){
        
        FirebaseReference(.Messages).document(documentId).collection(collectionId).getDocuments { (querySnapShot, error) in
            
            guard let documents = querySnapShot?.documents else {
                print("no documents for old chats")
                return
            }
            
            var oldMessages = documents.compactMap { (queryDocumentSnapshot) -> LocalMessage? in
                return try? queryDocumentSnapshot.data(as: LocalMessage.self)
            }
            
            oldMessages.sort(by: { $0.date < $1.date })
            
            for message in oldMessages {
                RealmManager.shared.saveToRealm(message)
            }
        }
    }
    
    
    
    //MARK: - add ,update , delete
    
    func addMessage(_ message: LocalMessage, memberId: String) {
        
        do {
            let _ = try FirebaseReference(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch {
            print("Error saving message" , error.localizedDescription)
        }
    }
    
    func addChannelMessage(_ message: LocalMessage, channel: Channel) {
        
        do {
            let _ = try FirebaseReference(.Messages).document(channel.id).collection(channel.id).document(message.id).setData(from: message)
        } catch {
            print("Error saving message" , error.localizedDescription)
        }
    }
    
    //MARK: - updateMessageStatus
    
    func updateMessageInFirebase(_ message: LocalMessage, memberIds: [String]) {
        let values = [kSTATUS: kREAD, kREADDATE: Date()] as [String : Any]
        
        for userId in memberIds {
            FirebaseReference(.Messages).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
        }
    }
    
    func removeListener() {
        self.newChatListener.remove()
        if self.updatedChatListener != nil {
            self.updatedChatListener.remove()
        }
    }
}
