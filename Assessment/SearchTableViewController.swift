//
//  SearchTableViewController.swift
//  Assessment
//
//  Created by Jinyao Wang on 16/5/2022.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    weak var databaseController: DatabaseProtocol?
//    let REQUEST_STRING = "https://imdb-api.com/API/SearchMovie/k_21epknx4/"
    var newMovies = [MovieData]()
    let CELL_MOVIE = "movieCell"
    var indicator = UIActivityIndicatorView()
    let MAX_ITEMS_PER_REQUEST = 40
    let MAX_REQUESTS = 10
    var currentRequestIndex: Int = 0
    
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
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func requestMoviesNamed(_ movieName: String) async {
        
        let movieName = movieName.replacingOccurrences(of: " ", with: "+")
        
        do {
            
            let headers = [
              "content-type": "application/json",
              "authorization": "apikey 6EqsBfmY1KiWcFXzpzZNvS:2E5ubEEpx2B1CjHoNPfLyU"
            ]

            let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/imdb/imdbSearchByName?query=\(movieName)")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if (error != nil) {
                    print(error!)
                } else {
                  if let httpResponse = response as? HTTPURLResponse {
                      if httpResponse.statusCode == 200 {
                          
                          if let data = data {
                              do {
                                  let decoder = JSONDecoder()
                                  let volumeData = try decoder.decode(VolumeData.self, from: data)
                                  print(11111111111111111)
                                  print(volumeData.result)
                                  print(11111111111111111)
//                                  if let movies = volumeData.result {
//                                      await MainActor.run {
//                                          newMovies.append(contentsOf: movies)
//                                          tableView.reloadData()
//                                      }
//                                      if movies.count == MAX_ITEMS_PER_REQUEST, currentRequestIndex + 1 < MAX_REQUESTS {
//
//                                          currentRequestIndex += 1
//                                          await requestMoviesNamed(movieName)
//                                      }
//                                  }
                              } catch {
                                  print(error)
                              }
                          }
                      }
                  }
              }
            }
            

            dataTask.resume()
            
//            let (data, _) =
//            try await URLSession.shared.data(for: urlRequest)
//            await MainActor.run {
//                indicator.stopAnimating()
//            }
//
//            let decoder = JSONDecoder()
//            let volumeData = try decoder.decode(VolumeData.self, from: data)
//            //let volumeData = try decoder.decode(VolumeData.self, from: dataTask)
//
//            if let movies = volumeData.movies {
//                await MainActor.run {
//                    newMovies.append(contentsOf: movies)
//                    tableView.reloadData()
//                }
//                if movies.count == MAX_ITEMS_PER_REQUEST, currentRequestIndex + 1 < MAX_REQUESTS {
//
//                    currentRequestIndex += 1
//                    await requestMoviesNamed(movieName)
//                }
//            }
            
        }
        catch let error {
            print(error)
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        URLSession.shared.invalidateAndCancel()
        currentRequestIndex = 0
        newMovies.removeAll()
        tableView.reloadData()
        guard let searchText = searchBar.text else {
            print("No text in search bar.")
            return
        }
        navigationItem.searchController?.dismiss(animated: true)
        indicator.startAnimating()
        Task {
            await requestMoviesNamed(searchText)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MOVIE, for: indexPath)

        // Configure the cell...
        let movie = newMovies[indexPath.row]
        
        cell.textLabel?.text = movie.title
        cell.detailTextLabel?.text = movie.year
        let requestURL = URL(string: movie.image!)
        cell.imageView?.imageFrom(url: requestURL!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = newMovies[indexPath.row]
        let _ = databaseController?.addMovieModel(movieData: movie)
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
