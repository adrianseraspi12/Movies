//
//  MovieCell.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    func bind(movie: MainMovies) {
        loadImage(urlString: movie.imageUrl)
        setPrice(currency: movie.currency, price: movie.trackPrice)
        movieNameLabel.text = movie.trackName
        genreLabel.text = movie.genre
    }
    
    private func setPrice(currency: String, price: Double) {
        let currencyWithPrice = "\(price) \(currency)"
        priceLabel.text = currencyWithPrice
    }
    
    private func loadImage(urlString: String) {
        let url = URL(string: urlString)
        movieImageView.kf.setImage(with: url,
                                   placeholder: UIImage(named: "placeholder"),
                                   options: [
                                    .cacheOriginalImage
                                   ])
    }
    
}
