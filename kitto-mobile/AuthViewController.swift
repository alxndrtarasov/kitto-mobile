//
//  AuthViewController.swift
//  kitto-mobile
//
//  Created by Alexander Tarasov on 25/06/2019.
//  Copyright © 2019 Alexander Tarasov. All rights reserved.
//

import UIKit
import Alamofire
class AuthViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "5.png")!)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UITabBarController {
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
            let parameters: Parameters = [
                "username": usernameTextField.text!,
                "password": passwordTextField.text!
            ]
            
            print(parameters)
            
            
            AF.request("http://35.226.26.159:8080/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseJSON {response in
                    let headers = response.response?.allHeaderFields as! [String: String]
                    UserDefaults.standard.set(headers["Authorization"]!, forKey: "token")
                    UserDefaults.standard.set(self.usernameTextField.text!, forKey: "email")
            }
        }
    }
    
    
}



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
