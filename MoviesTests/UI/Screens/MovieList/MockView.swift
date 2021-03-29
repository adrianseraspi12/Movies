//
//  MockView.swift
//  MoviesTests
//
//  Created by Adrian Jun Seraspi on 3/28/21.
//

import Foundation
@testable import Movies

class MockView: View {
    
    var currentState: ScreenState? = nil
    var data = [MainMovies]()
    var currentQuery = ""
    
    func set(state: ScreenState) {
        currentState = state
        switch state {
        case .displayList(let data):
            self.data = data
            break
        case .loading(_): break
        case .error(_): break
        }
    }
    
    func setSearch(query: String) {
        currentQuery = query
    }
    
    func showMovieDetails(movie: MainMovies) {
        
    }
    
}
