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
    
    var searchQuery: String = ""
    
    init(vc: View, userDefaults: UserDefaults, api: Client, localDb: Database) {
        self.vc = vc
        self.api = api
        self.localDb = localDb
    }
    
    func setup() {
        
    }
    
    func search(query: String) {
        searchQuery = query
        vc.set(state: .loading(true))
        
        //  Return Empty List
        if (query.isEmpty) {
            vc.set(state: .loading(false))
            vc.set(state: .displayList([]))
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
                    self?.convertToMainMovie(model: $0) ?? MainMovies()
                }
                
                //  Update the view and display the list
                self?.vc.set(state: .displayList(mainMovieList))
                
                //  Delete all movies in the database
                self?.localDb.deleteAllMovies()
                
                //  Save a new data
                self?.localDb.saveAllMovies(list: result)
            }.store(in: &cancellables)

    }
    
    private func convertToMainMovie(model: MovieList.Result) -> MainMovies {
        return MainMovies(id: model.id,
                          imageUrl: model.imageUrl,
                          previewUrl: model.previewUrl,
                          trackName: model.trackName,
                          trackPrice: model.trackPrice,
                          currency: model.currency,
                          genre: model.genre,
                          longDescription: model.longDescription)
    }
}
