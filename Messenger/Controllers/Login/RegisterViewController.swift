//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Maxim Granchenko on 19.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isUserInteractionEnabled = true
        return scroll
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person")
        iv.isUserInteractionEnabled = true
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.returnKeyType = .continue
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 12
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.layer.borderWidth = 0.6
        tf.placeholder = "Enter First Name..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.returnKeyType = .continue
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 12
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.layer.borderWidth = 0.6
        tf.placeholder = "Enter Last Name..."
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 0))
        tf.leftViewMode = .always
        return tf
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
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangePic))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        logoImageView.addGestureRecognizer(gesture)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(logoImageView)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(registerButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        logoImageView.frame = CGRect(x: (scrollView.width - size) / 2, y: 20, width: size, height: size)
        firstNameTextField.frame = CGRect(x: 30, y: logoImageView.bottom + 30, width: scrollView.width - 60, height: 50)
        lastNameTextField.frame = CGRect(x: 30, y: firstNameTextField.bottom + 10, width: scrollView.width - 60, height: 50)
        emailTextField.frame = CGRect(x: 30, y: lastNameTextField.bottom + 10, width: scrollView.width - 60, height: 50)
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10, width: scrollView.width - 60, height: 50)
        registerButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 30, width: scrollView.width - 60, height: 50)
    }
    
    @objc private func didTapChangePic() {
        print("tap")
    }
    
    @objc private func registerButtonTapped() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()

        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
    }
    
    private func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops", message: "Please enter all information to create a new account.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister() {
        let registerVC = RegisterViewController()
        registerVC.title = "Create Account"
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

//MARK: Text Field Delegete
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            registerButtonTapped()
        }
        return true
    }
}
