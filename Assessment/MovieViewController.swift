//
//  MovieViewController.swift
//  Assessment
//
//  Created by Jinyao Wang on 16/5/2022.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import WebKit

class MovieViewController: UIViewController {

    @IBOutlet weak var movieTitleImage: UIImageView!
    @IBOutlet weak var movieTitleText: UILabel!
    @IBOutlet weak var imdbRate: UILabel!
    @IBOutlet weak var rottenTomatoesRate: UILabel!
    @IBOutlet weak var webview: WKWebView!
    
    weak var databaseController: DatabaseProtocol?
    var rateData = RateData()
    var trailerData = TrailerData()
    var movieID = ""
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        movieID = (databaseController?.returnCurrentMovie().id)!
        movieTitleText.text = databaseController?.returnCurrentMovie().title
        guard let url = databaseController?.returnCurrentMovie().image, let requestURL = URL(string: url) else { return }
        
        Task {
            await requestMoviesTrailer()
            guard let u = trailerData.linkEmbed, let requestURL = URL(string: u) else { return }
            webview.load(URLRequest(url: requestURL))
        }
        
        Task {
            await requestMoviesRate()
            movieTitleImage.imageFrom(url: requestURL)
            imdbRate.text = "IMDB Rate: " + rateData.imDb! + "/10"
            rottenTomatoesRate.text = "Rotten Tomatoes: " + rateData.rottenTomatoes! + "/100"
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func likeButton(_ sender: Any) {
        displayMessage(title: "You liked this movie!", message: "This movie is added to your favorites")
    }
    
    func requestMoviesRate() async {
        let u = "https://imdb-api.com/API/Ratings/k_21epknx4/" + movieID
        guard let requestURL = URL(string: u) else {
            print("Invalid URL.")
            return
        }
        let urlRequest = URLRequest(url: requestURL)
        do {
            let (data, _) =
            try await URLSession.shared.data(for: urlRequest)

            let decoder = JSONDecoder()
            self.rateData = try decoder.decode(RateData.self, from: data)
        }
        catch let error {
            print(error)
        }
    }
    
    func requestMoviesTrailer() async {
        let u = "https://imdb-api.com/API/Trailer/k_21epknx4/" + movieID
        guard let requestURL = URL(string: u) else {
            print("Invalid URL.")
            return
        }
        let urlRequest = URLRequest(url: requestURL)
        do {
            let (data, _) =
            try await URLSession.shared.data(for: urlRequest)

            let decoder = JSONDecoder()
            self.trailerData = try decoder.decode(TrailerData.self, from: data)
        }
        catch let error {
            print(error)
        }
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

extension UIImageView {
    func imageFrom(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
