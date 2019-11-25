//
//  SingleMovieViewController.swift
//  NewsAPI
//
//  Created by Meet Madhu on 2019-11-24.
//  Copyright © 2019 Meet Madhu. All rights reserved.
//

import UIKit

class SingleMovieViewController: UIViewController {
    
    var movieTitle: String!
    var movieImageString: String!
    var movieOverview: String!

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = movieTitle
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        self.movieView.layer.cornerRadius = 8
        self.movieView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.movieOverviewLabel.text = movieOverview
        
        self.movieImageView.layer.cornerRadius = 8
        self.movieImageView.clipsToBounds = true
        getImage()
    }
    
    func getImage() {
        let imgUrl = "https://image.tmdb.org/t/p/original\(movieImageString!)"
        let url = URL(string: imgUrl)!
        URLSession.shared.dataTask(with: url, completionHandler: {(data, _, error) in
            if error != nil {
                print("Image error: ", error!)
                return
            }
            DispatchQueue.main.async {
                self.movieImageView.image = UIImage(data: data!)
            }
        }).resume()
    }
}
