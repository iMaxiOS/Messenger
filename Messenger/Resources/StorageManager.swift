//
//  StorageManager.swift
//  Messenger
//
//  Created by Maxim Granchenko on 26.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import Foundation
import FirebaseStorage

final class StorageManager {

    typealias UploadPictureCompletion = ((Result<String, Error>) -> Void)
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    /// Upload picture to firebase storage and completion with url to download
    public func uploadProfilePicture(with data: Data, fileName: String, completed: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { [weak self] metadata, error in
            guard error == nil else {
                print("Failed to upload data to firebase for picture")
                completed(.failure(StorageError.failedToUpload))
                return
            }
            
            self?.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("Failed to get download to url")
                    completed(.failure(StorageError.failedToDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completed(.success(urlString))
            }
        }
    }
    
    public func downloadUrl(with path: String, complition: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                complition(.failure(StorageError.failedToDownloadUrl))
                return
            }
            
            complition(.success(url))
        }
    }
}
