//
//  MainPageController.swift
//  Assessment
//
//  Created by Jinyao Wang on 8/5/2022.
//

import UIKit

class MainPageController: UITableViewController, UISearchBarDelegate {
    
    weak var databaseController: DatabaseProtocol?
    let REQUEST_STRING = "https://imdb-api.com/API/SearchMovie/k_21epknx4/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        // Do any additional setup after loading the view.

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        
        // Ensure the search bar is always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
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
