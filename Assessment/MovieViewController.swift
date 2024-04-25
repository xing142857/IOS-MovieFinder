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
    var movieDetail = MovieDetail()
    var movieID = ""
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        movieID = (databaseController?.returnCurrentMovie().imdbID)!
        movieTitleText.text = databaseController?.returnCurrentMovie().title
        guard let url = databaseController?.returnCurrentMovie().poster, let requestURL = URL(string: url) else { return }
        movieTitleImage.imageFrom(url: requestURL)
        
        Task {
            await requestMoviesRate()
            for rating in movieDetail.ratings {
                if rating.source == "Internet Movie Database" {
                    imdbRate.text = "IMDB Rate: " + rating.value
                } else if rating.source == "Rotten Tomatoes" {
                    rottenTomatoesRate.text = "Rotten Tomatoes: " + rating.value
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func likeButton(_ sender: Any) {
        displayMessage(title: "You liked this movie!", message: "This movie is added to your favorites")
    }
    
    func requestMoviesRate() async {
        let headers = [
          "content-type": "application/json",
          "authorization": "apikey 6EqsBfmY1KiWcFXzpzZNvS:2E5ubEEpx2B1CjHoNPfLyU"
        ]

        guard let url = URL(string: "https://api.collectapi.com/imdb/imdbSearchById?movieId=" + movieID) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let rateData = try decoder.decode(RateData.self, from: data)
                        await MainActor.run {
                            movieDetail = rateData.result
                        }
                    } catch {
                        print(error)
                    }
            }
        } catch {
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
