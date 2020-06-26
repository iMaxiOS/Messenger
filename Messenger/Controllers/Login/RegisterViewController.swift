//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Maxim Granchenko on 19.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let spinnerView = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.clipsToBounds = true
        scroll.isUserInteractionEnabled = true
        return scroll
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle")
        iv.isUserInteractionEnabled = true
        iv.tintColor = .systemGray4
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.systemGray4.cgColor
        iv.layer.borderWidth = 3
        return iv
    }()
    
    private let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .none
        tf.returnKeyType = .continue
        tf.autocorrectionType = .no
        tf.layer.cornerRadius = 12
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.layer.borderWidth = 1
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
        tf.layer.borderWidth = 1
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
        tf.layer.borderWidth = 1
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
        tf.layer.borderWidth = 1
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
        logoImageView.layer.cornerRadius = logoImageView.width / 2
        firstNameTextField.frame = CGRect(x: 30, y: logoImageView.bottom + 30, width: scrollView.width - 60, height: 50)
        lastNameTextField.frame = CGRect(x: 30, y: firstNameTextField.bottom + 10, width: scrollView.width - 60, height: 50)
        emailTextField.frame = CGRect(x: 30, y: lastNameTextField.bottom + 10, width: scrollView.width - 60, height: 50)
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10, width: scrollView.width - 60, height: 50)
        registerButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 30, width: scrollView.width - 60, height: 50)
    }
    
    fileprivate func presentPhotoActionSheet() {
        let alert = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        alert.addAction(UIAlertAction(title: "Chose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func presentCamera() {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.delegate = self
        vc.sourceType = .camera
        present(vc, animated: true, completion: nil)
    }
    
    private func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.delegate = self
        vc.sourceType = .photoLibrary
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapChangePic() {
        presentPhotoActionSheet()
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
        
        self.spinnerView.show(in: view)
        
        DatabaseManager.shared.emailExists(with: email) { [weak self] exists in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.spinnerView.dismiss()
            }
            
            guard !exists else {
                self.alertUserLoginError(message: "Looks like a user account for that email address already exists.")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard result != nil , error == nil else {
                    print("Error creating user")
                    return
                }
                let userChat = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: userChat, complition: { success in
                    if success {
                        guard let image = self.logoImageView.image, let data = image.pngData() else { return }
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
                    }
                })
                
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
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

//MARK: Image Picker Delegete
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.logoImageView.image = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
