//
//  MockDatabase.swift
//  MoviesTests
//
//  Created by Adrian Jun Seraspi on 3/28/21.
//

import Combine
@testable import Movies

class MockDatabase: Database {
    
    let publisherStub = PassthroughSubject<[Movie], Error>()
    
    var isGetAllMoviesCalled = false
    var isDeleteAllMoviesCalled = false
    var isSaveAllMoviesCalled = false
    
    func saveAllMovies(list: [MovieList.Result]) {
        isSaveAllMoviesCalled = true
    }
    
    func getAllMovies() -> AnyPublisher<[Movie], Error> {
        isGetAllMoviesCalled = true
        return publisherStub.eraseToAnyPublisher()
    }
    
    func deleteAllMovies() {
        isDeleteAllMoviesCalled = true
    }
    
}
