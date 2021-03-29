//
//  Contract.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation

enum ScreenState: Equatable {
    case loading(Bool)
    case displayList([MainMovies])
    case error(String)
}

protocol ViewModel {
    
    //  Setting up the view state. Check persist data
    func setupPersistedData()
    
    //  Handles the search operation
    func search(query: String)
    
    //  Handles changing the app state and save it to UserDefaults
    //  When state is details, movieId should be saved
    func change(state: AppState, movieId: Int?)
}

protocol View {
    
    //  Change the view state
    func set(state: ScreenState)
    
    //  Set the searchBar text
    func setSearch(query: String)
    
    //  Open Movie Details Screen
    func showMovieDetails(movie: MainMovies, animated: Bool)
    
}
