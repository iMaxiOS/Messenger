//
//  StorageError.swift
//  Messenger
//
//  Created by Maxim Granchenko on 26.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case failedToUpload
    case failedToDownloadUrl
}
