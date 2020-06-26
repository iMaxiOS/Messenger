//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Maxim Granchenko on 23.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

extension DatabaseManager {
    
    public func emailExists(with email: String, complited: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observe(.value) { snapshot in
            guard snapshot.value as? String != nil else {
                complited(false)
                return
            }
            
            complited(true)
        }
    }
    
    public func insertUser(with user: ChatAppUser, complition: @escaping ((Bool) -> Void)) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("failed to write to database")
                complition(false)
                return
            }
            complition(true)
        })
    }
}

