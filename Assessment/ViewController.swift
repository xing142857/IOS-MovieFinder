//
//  ViewController.swift
//  Assessment
//
//  Created by Jinyao Wang on 1/5/2022.
//

import UIKit

class ViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        guard let username = userNameTextField.text, let password = passwordTextField.text else {
            return
        }
        if username.isEmpty || password.isEmpty {
            var errorMsg = "Please ensure all fields are filled:\n"
            if username.isEmpty {
                errorMsg += "- Must provide a username\n"
            }
            if password.isEmpty {
                errorMsg += "- Must provide password"
            }
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        let message = databaseController?.loginUser(username: username, password: password)
        if message != "" {
            displayMessage(title: "Input incorrect", message: message!)
            return
        }
        let nextViewController =
        self.storyboard?.instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    func displayMessage(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
