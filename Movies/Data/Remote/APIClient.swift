//
//  APIClient.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import Foundation
import Combine
import Alamofire

protocol Client {
    
    //  A request to search for a movie in iTunes
    func requestSearchMovies(query: String,
                             country: Country) -> AnyPublisher<[MovieList.Result], AFError>
    
}

class APIClient: Client {

    private let baseUrlString = "https://itunes.apple.com/"
    private var sessionManager: Session
    
    init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    func requestSearchMovies(query: String, country: Country) -> AnyPublisher<[MovieList.Result], AFError> {
        //  Create a parameters for api client
        var params = Parameters()
        params["term"] = query
        params["country"] = country.rawValue
        params["media"] = Media.movie.rawValue
        
        //  Create request from Session
        let request = sessionManager.request(createUrl(withPath: "search"),
                                             parameters: params)
        
        //  Receive the request on Main Thread
        return requestSearchMovieFromServer(query: query, country: country, request: request)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    ///  Using combine framework
    ///  Use future to produce a value for success or fail
    ///  Execute the request in background thread (global())
    private func requestSearchMovieFromServer(query: String,
                                              country: Country,
                                              request: DataRequest) -> Future<[MovieList.Result], AFError> {
        return Future { promise in
            request.responseDecodable(
                of: MovieList.self,
                queue: .global(),
                completionHandler: { (response: DataResponse<MovieList, AFError>) in
                    switch (response.result) {
                    case .success(let data):
                        promise(.success(data.result))
                        break
                    case .failure(let error):
                        promise(.failure(error))
                        break
                }
            })
        
        }
    }
    
}

extension APIClient {
    
    private func createUrl(withPath: String = "") -> URL {
        return URL(string: baseUrlString + withPath)!
    }
    
}
