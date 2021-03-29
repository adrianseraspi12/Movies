//
//  MockClient.swift
//  MoviesTests
//
//  Created by Adrian Jun Seraspi on 3/28/21.
//

import Foundation
import Combine
import Alamofire
@testable import Movies

class MockClient: Client {

    //  Create a mock publisher result
    let publisherStub = AnyPublisher<[MovieList.Result], AFError>.init(
        Result<[MovieList.Result], AFError>.Publisher(MockValues.movieResultList)
    )
    
    func requestSearchMovies(query: String, country: Country) -> AnyPublisher<[MovieList.Result], AFError> {
        return publisherStub.eraseToAnyPublisher()
    }
    
}
