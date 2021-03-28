//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation
import Combine

class MovieListViewModel: ViewModel {
    
    private var vc: View
    private var api: Client
    private var localDb: Database
    private var cancellables = Set<AnyCancellable>()
    private var userDefaults: UserDefaults
    
    private var listOfMainMovie = [MainMovies]()
    
    init(vc: View, userDefaults: UserDefaults, api: Client, localDb: Database) {
        self.vc = vc
        self.api = api
        self.localDb = localDb
        self.userDefaults = userDefaults
    }
    
    func change(state: AppState, movieId: Int?) {
        if (movieId != nil) {
            userDefaults.setValue(movieId, forKey: "movie_id")
        }
        userDefaults.setValue(state.rawValue, forKey: "app_state")
    }
    
    /// This function handles the getting of persisted data from the core data
    /// and check the state of the app then update the viewcontroller (list or details)
    func setupPersistedData() {
        let searchQuery = self.userDefaults.string(forKey: "search_query") ?? ""
        if (searchQuery.isEmpty) { return }
        
        vc.setSearch(query: searchQuery)
        
        localDb.getAllMovies()
            .sink { [weak self] (completion) in
                switch completion {
                case .finished:
                    self?.vc.set(state: .loading(false))
                    break
                    
                case .failure(let error):
                    self?.vc.set(state: .loading(false))
                    self?.vc.set(state: .error(error.localizedDescription))
                    break
                }
            } receiveValue: { [weak self]  (movies) in
                let convertedMovies = movies.map { $0.convertToMainMovies() }
                self?.listOfMainMovie = convertedMovies
                self?.vc.set(state: .displayList(convertedMovies))
                self?.setCurrentAppState()
            }.store(in: &cancellables)

    }
    
    func search(query: String) {
        vc.set(state: .displayList([]))
        vc.set(state: .loading(true))
        
        //  Save the value of query
        userDefaults.setValue(query, forKey: "search_query")
        
        //  Return Empty List
        if (query.isEmpty) {
            vc.set(state: .loading(false))
            return
        }
        
        api.requestSearchMovies(query: query, country: .AU)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.vc.set(state: .loading(false))
                    break
                case .failure(let error):
                    self?.vc.set(state: .loading(false))
                    self?.vc.set(state: .error(error.localizedDescription))
                    break
                }
            } receiveValue: { [weak self] (result) in
                //  Convert the MovieList.Result to MainMovie
                let mainMovieList = result.map {
                    $0.convertToMainMovies()
                }
                
                //  Update the view and display the list
                self?.vc.set(state: .displayList(mainMovieList))
                
                //  Delete all movies in the database
                self?.localDb.deleteAllMovies()
                
                //  Save a new list in database

                self?.localDb.saveAllMovies(list: result)
            }.store(in: &cancellables)
    }
    
    ///  Get the AppState in UserDefaults then
    ///  Check if state is details, should show the movie details screen
    private func setCurrentAppState() {
        let savedStateValue = userDefaults.string(forKey: "app_state") ?? AppState.list.rawValue
        let state = AppState(rawValue: savedStateValue)!
        if (state == .details) {
            let movieId = userDefaults.integer(forKey: "movie_id")
            guard let movie = listOfMainMovie.filter({ $0.id == movieId }).first else {
                return
            }
            vc.showMovieDetails(movie: movie)
        }
    }
}
