//
//  LoginViewController.swift
//  Messenger
//
//  Created by Maxim Granchenko on 19.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(logInButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        logoImageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        emailTextField.frame = CGRect(x: 30, y: logoImageView.bottom + 30, width: scrollView.width - 60, height: 50)
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10, width: scrollView.width - 60, height: 50)
        logInButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 30, width: scrollView.width - 60, height: 50)
    }
    
    @objc private func loginButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                print("Error sign in user")
                return
            }
            
            let user = result.user
            print("Logged in user, \(user)")
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
