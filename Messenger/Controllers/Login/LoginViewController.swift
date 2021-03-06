//
//  LoginViewController.swift
//  Messenger
//
//  Created by Maxim Granchenko on 19.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private var loginObserver: NSObjectProtocol?
    
    private let spinnerView = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.clipsToBounds = true
        return scroll
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.returnKeyType = .continue
        tf.keyboardType = .emailAddress
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 12
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.layer.borderWidth = 0.6
        tf.placeholder = "Enter Email Address..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.returnKeyType = .done
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 12
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.layer.borderWidth = 0.6
        tf.placeholder = "Enter Password..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
        tf.leftViewMode = .always
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let fbSignInButton: FBLoginButton = {
        let button = FBLoginButton(type: .system)
        button.permissions = ["email,public_profile"]
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    private let googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dismiss vc when sign in with google
        loginObserver = NotificationCenter.default.addObserver(forName: .didNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        //instance presenting
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        title = "Log In"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        fbSignInButton.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(logInButton)
        scrollView.addSubview(fbSignInButton)
        scrollView.addSubview(googleSignInButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        logoImageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        emailTextField.frame = CGRect(x: 30, y: logoImageView.bottom + 30, width: scrollView.width - 60, height: 50)
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10, width: scrollView.width - 60, height: 50)
        logInButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 30, width: scrollView.width - 60, height: 50)
        fbSignInButton.frame = CGRect(x: 30, y: logInButton.bottom + 30, width: scrollView.width - 60, height: 50)
        googleSignInButton.frame = CGRect(x: 30, y: fbSignInButton.bottom + 30, width: scrollView.width - 60, height: 50)
    }
    
    @objc private func loginButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        spinnerView.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.spinnerView.dismiss()
            }
            
            UserDefaults.standard.set(email, forKey: "email")
            
            guard authResult != nil, error == nil else {
                print("Error sign in user")
                return
            }
            
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister() {
        let registerVC = RegisterViewController()
        registerVC.title = "Create Account"
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    deinit {
        if let notification = loginObserver {
            NotificationCenter.default.removeObserver(notification)
        }
    }
}

//MARK: Text Field Delegete
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTapped()
        }
        return true
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"],
                                                         tokenString: token, version: nil, httpMethod: .get)
        facebookRequest.start { [weak self] _, result, error in
            guard let self = self else { return }
            guard let result = result as? [String: Any], error == nil else {
                print("Failed to make facebook graph requst")
                return
            }
            
            guard let firstName = result["first_name"] as? String,
                let lastName = result["last_name"] as? String,
                let email = result["email"] as? String,
                let picture = result["picture"] as? [String: Any],
                let data = picture["data"] as? [String: Any],
                let pictureUrl = data["url"] as? String else {
                    print("Failed to get email and name from fb result")
                    return
            }
            
            DatabaseManager.shared.emailExists(with: email) { exists in
                if !exists {
                    let userChat = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                    DatabaseManager.shared.insertUser(with: userChat, complition: { success in
                        if success {
                            guard let url = URL(string: pictureUrl) else { return }
                            
                            URLSession.shared.dataTask(with: url) { data, _, _ in
                                guard let data = data else {
                                    print("Failed to get data from Facebook")
                                    return
                                }
                                
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
                    })
                }
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { result, error in
                guard result != nil, error == nil else {
                    if let error = error {
                        print("Facebook credentinal logged failed", error)
                    }
                    return
                }
                
                print("Successfully Sign In")
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no provider
    }
}
