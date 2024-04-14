//
//  PreferController.swift
//  Assessment
//
//  Created by Jinyao Wang on 3/5/2022.
//

import UIKit

class PreferController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    var preferList = [Int]()
    
    @IBAction func favoriteMovieButton(_ sender: UIButton) {
        guard let button = sender as? UIButton else {return}
        if sender.backgroundColor == UIColor.blue {
            sender.backgroundColor = UIColor.white
            for i in (0...preferList.count-1) {
                if preferList[i] == button.tag {
                    preferList.remove(at: i)
                    return
                }
            }
        } else if (preferList.count < 3){
            sender.backgroundColor = UIColor.blue
            preferList.append(button.tag)
        }
        return
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let _ = databaseController?.signinUser(prefer: preferList)
    }
    
    enum Genre: Int {
        case action = 1
        case comedy = 2
        case fantasy = 3
        case history = 4
        case horror = 5
        case mystery = 6
        case romance = 7
        case sci_fi = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Do any additional setup after loading the view.
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
