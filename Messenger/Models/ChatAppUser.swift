//
//  ChatAppUser.swift
//  Messenger
//
//  Created by Maxim Granchenko on 26.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import Foundation

struct ChatAppUser {
    var firstName: String
    var lastName: String
    var emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}
