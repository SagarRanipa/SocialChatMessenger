//
//  RealmManager.swift
//  SocialChatMessenger
//
//  Created by Sagar patel on 2021-08-27.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    let realm = try! Realm()
    
    private init() { }
    
    func saveToRealm<T: Object>(_ object: T) {
        
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print("Error saving realm Object ", error.localizedDescription)
        }
    }
    
}
