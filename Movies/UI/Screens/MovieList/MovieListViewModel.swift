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
    
    init(vc: View, userDefaults: UserDefaults, api: Client, localDb: Database) {
        self.vc = vc
        self.api = api
        self.localDb = localDb
        self.userDefaults = userDefaults
    }
    
    /// Get the persisted data from core data if available
    func setup() {
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
                let listOfMainMovie = movies.map { $0.convertToMainMovies() }
                self?.vc.set(state: .displayList(listOfMainMovie))
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
                
                //  Save app state
                self?.userDefaults.setValue(AppState.list.rawValue, forKey: "app_state")
                
                //  Save a new list in database
                self?.localDb.saveAllMovies(list: result)
            }.store(in: &cancellables)

    }
}
