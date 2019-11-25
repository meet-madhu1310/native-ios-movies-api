//
//  ViewController.swift
//  NewsAPI
//
//  Created by Meet Madhu on 2019-11-16.
//  Copyright © 2019 Meet Madhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    
    var listOfMovies = [MovieDetails]() {
        didSet {
            DispatchQueue.main.async {
                self.newsTableView.reloadData()
            }
        }
    }
    
    //FOR SINGLE MOVIE CONTROLLER
    var selectedTitle: String = ""
    var selectedImageString: String = ""
    var selectedOverview: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FILL ENTIRE
        if #available(iOS 13.0, *) {
            let navBarAppreance = UINavigationBarAppearance()
            navBarAppreance.configureWithOpaqueBackground()
            navBarAppreance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppreance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppreance.backgroundColor = UIColor.systemOrange
            self.navigationController?.navigationBar.standardAppearance = navBarAppreance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppreance
        }
        
        //GET NEWS DATA
        let movieRequest = MoviesRequest()
        movieRequest.getMovies() { [weak self] result in
            switch result {
                case .success(let news):
                    self?.listOfMovies = news
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //LARGE TITLE DISPLAY
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    //MARK: NAVIGATION TO SINGLE MOVIE CONTROLLER
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SingleMovieSegue" {
            let dvc = segue.destination as! SingleMovieViewController
            dvc.movieTitle = selectedTitle
            dvc.movieImageString = selectedImageString
            dvc.movieOverview = selectedOverview
        }
    }
    
}

//MARK: TABLE VIEW
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movie = listOfMovies[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsTableViewCell {
            cell.newsTitleLabel.text = movie.title
            
            //UI CONTENT
            cell.contentView.layer.cornerRadius = 20
            cell.contentView.layer.masksToBounds = true
            cell.contentView.layer.borderWidth = 5
            cell.contentView.layer.borderColor = CGColor(srgbRed: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.contentView.layoutMargins.bottom = 10
            
            let imageUrl = "https://image.tmdb.org/t/p/original/\(movie.poster_path)"
            let url = URL(string: imageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler:{ (data, _, error) in
                if error != nil {
                    print("Image error: ", error!)
                }
                DispatchQueue.main.async {
                    cell.newsImageView.image = UIImage(data: data!)
                }
            }).resume()
                
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = listOfMovies[indexPath.row].title
        selectedImageString = listOfMovies[indexPath.row].poster_path
        selectedOverview = listOfMovies[indexPath.row].overview
        
        performSegue(withIdentifier: "SingleMovieSegue", sender: self)
    }
}

