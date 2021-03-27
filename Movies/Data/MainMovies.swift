//
//  MainMovies.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation

struct MainMovies: Codable {
    
    var id: Int = -1
    var imageUrl: String = ""
    var previewUrl: String = ""
    var trackName: String = ""
    var trackPrice: Double = 0.0
    var currency: String = ""
    var genre: String = ""
    var longDescription: String = ""
    
}
