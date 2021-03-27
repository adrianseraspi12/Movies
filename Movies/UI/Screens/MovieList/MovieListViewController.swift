//
//  ViewController.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var movieListTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var data = [MainMovies]()
    var viewmodel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func reload(data: [MainMovies]) {
        self.data = data
        movieListTableView.reloadData()
    }
}

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        viewmodel?.search(query: searchBar.text ?? "")
    }
    
}

extension MovieListViewController: View {
    
    func set(state: ScreenState) {
        switch state {
        case .loading(let isLoading):
            loadingIndicator.isHidden = !isLoading
            break
            
        case .displayList(let movies):
            reload(data: movies)
            break
            
        case .error(let error):
            showAlert(title: "Error", message: error, action: "OK")
            break
        }
    }
    
}

extension MovieListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        cell.bind(movie: data[indexPath.row])
        return cell
    }
    
}

