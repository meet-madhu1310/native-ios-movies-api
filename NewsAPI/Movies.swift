//
//  News.swift
//  NewsAPI
//
//  Created by Meet Madhu on 2019-11-23.
//  Copyright © 2019 Meet Madhu. All rights reserved.
//

import Foundation

public struct Results: Decodable {
    var results: [MovieDetails]
}

public struct MovieDetails: Decodable {
    var poster_path: String
    var title: String
    var overview: String
}
