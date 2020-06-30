//
//  AppDelegate.swift
//  Messenger
//
//  Created by Maxim Granchenko on 19.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool { ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FirebaseApp.configure()
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return GIDSignIn.sharedInstance()?.handle(url) ?? true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            if let error = error {
                print("Failed to sign in with Google, \(error)")
            }
            
            return
        }
        
        guard let user = user else { return }
        print("Did sign in with google \(user)")
        
        let email = user.profile.email ?? "default"
        let firstName = user.profile.givenName ?? "default"
        let lastName = user.profile.familyName ?? "dafault"
        
        UserDefaults.standard.set(email, forKey: "email")
        
        DatabaseManager.shared.emailExists(with: email) { exists in
            if !exists {
                let userChat = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: userChat, complition: { success in
                    if success {
                        if user.profile.hasImage {
                            guard let url = user.profile.imageURL(withDimension: 200) else {
                                return 
                            }
                            
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                guard let data = data else { return }
                                let fileName = userChat.profilePictureFileName
                                StorageManager.shared.uploadProfilePicture(with: data, fileName: fileName) { result in
                                    switch result {
                                    case .success(let downloadUrl):
                                        UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                        print(downloadUrl)
                                    case .failure(let error):
                                        print("Storege manager error", error)
                                    }
                                }
                            }.resume()
                        }
                    }
                })
            }
        }
        
        guard let authentication = user.authentication else {
            print("Missing auth object off of google user ")
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        FirebaseAuth.Auth.auth().signIn(with: credential) { result, error in
            guard result != nil, error == nil else {
                print("Failed to login with google credential")
                return
            }
            
            print("Successfully signed in with google ")
            NotificationCenter.default.post(name: .didNotification, object: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Google user was disconnected")
    }
}

