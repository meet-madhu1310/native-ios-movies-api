//
//  NewsRequest.swift
//  NewsAPI
//
//  Created by Meet Madhu on 2019-11-23.
//  Copyright © 2019 Meet Madhu. All rights reserved.
//

import Foundation

enum MoviesErrpr: Error {
    case noDataAvailable
    case canNotProcessData
}

struct MoviesRequest {
    
    let apiURL: URL
    let API_KEY = "8367b1854dccedcfc9001204de735470"
    
    init() {
        let apiString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(API_KEY)&language=en-US&page=1"
        guard let apiURL = URL(string: apiString) else { fatalError() }
        self.apiURL = apiURL
    }
    
    //MARK: GET JSON DATA FROM API
    func getMovies(completion: @escaping(Result<[MovieDetails], MoviesErrpr>) -> Void) {
        URLSession.shared.dataTask(with: apiURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let moviesResponse = try decoder.decode(Results.self, from: jsonData)
                let movieDetails = moviesResponse.results
                
                completion(.success(movieDetails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }.resume()
    }
    
}
