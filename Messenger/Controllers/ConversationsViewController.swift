//
//  ConversationsViewController.swift
//  Messenger
//
//  Created by Maxim Granchenko on 19.06.2020.
//  Copyright © 2020 Maxim Granchenko. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {
    
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
//        return tableView
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validationUser()
    }
    
    private func validationUser() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let loginVC = LoginViewController()
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: false)
        } else {
            print("Ok user signIn in application")
        }
    }
}

//extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
//        return cell
//    }
//}
