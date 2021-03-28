//
//  MockValues.swift
//  MoviesTests
//
//  Created by Adrian Jun Seraspi on 3/28/21.
//

import Foundation
@testable import Movies

class MockValues {
    
    static let movieResultList = [
        MovieList.Result(id: 0,
                         imageUrl: "https://google.com",
                         previewUrl: "https://youtube.com",
                         trackName: "Justice League",
                         trackPrice: 15.99,
                         currency: "AUD",
                         genre: "Action",
                         longDescription: "This is justice league"),
    
    ]
}
