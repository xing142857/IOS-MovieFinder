//
//  SigninViewController.swift
//  Assessment
//
//  Created by Jinyao Wang on 12/5/2022.
//

import UIKit

class SigninViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signinButton(_ sender: Any) {
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
        let message = databaseController?.addUserNameAndPassword(username: username, password: password)
        if message != "" {
            displayMessage(title: "Input incorrect", message: message!)
            return
        }
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "PreferController") as! PreferController
        self.navigationController?.pushViewController(nextViewController, animated: true)
//        self.present(nextViewController, animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
