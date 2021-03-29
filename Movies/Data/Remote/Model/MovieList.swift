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
        
        var id: Int = 0
        var imageUrl: String = ""
        var previewUrl: String = ""
        var trackName: String = ""
        var trackPrice: Double = 0.0
        var currency: String = ""
        var genre: String = ""
        var longDescription: String = ""
        
        enum CodingKeys: String, CodingKey {
            case id = "trackId"
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

extension MovieList.Result {
    
    func convertToMainMovies(newId: Int) -> MainMovies {
        return MainMovies(id: newId,
                          imageUrl: self.imageUrl,
                          previewUrl: self.previewUrl,
                          trackName: self.trackName,
                          trackPrice: self.trackPrice,
                          currency: self.currency,
                          genre: self.genre,
                          longDescription: self.longDescription)
    }
    
}
