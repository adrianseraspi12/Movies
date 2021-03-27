//
//  MovieList.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation

struct MovieList: Codable {
    
    var result: [Result]
    
    enum CodingKeys: String, CodingKey {
        case result = "results"
    }
    
    struct Result: Codable {
        
        var imageUrl: String
        var previewUrl: String
        var trackName: String
        var trackPrice: Double
        var currency: String
        var genre: String
        var longDescription: String
        
        enum CodingKeys: String, CodingKey {
            case imageUrl = "artworkUrl100"
            case previewUrl
            case trackName
            case trackPrice
            case currency
            case genre = "primaryGenreName"
            case longDescription
        }
        
    }
    
}
