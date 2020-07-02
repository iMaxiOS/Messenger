//
//  Sender.swift
//  Messenger
//
//  Created by Maxim Granchenko on 02.07.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}
