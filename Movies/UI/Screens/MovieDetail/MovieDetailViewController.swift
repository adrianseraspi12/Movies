//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/28/21.
//

import UIKit
import AVKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet weak var previewContainerView: UIView!
    
    var movie: MainMovies?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupVideoPlayer()
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupTextDetails() {
        movieTitleLabel.text = movie?.trackName
        movieGenreLabel.text = movie?.genre
        longDescriptionLabel.text = movie?.longDescription
    }
    
    private func setupVideoPlayer() {
        guard let videoUrl = URL(string: movie?.previewUrl ?? "") else {
            // Show image instead
            let imageUrl = URL(string: movie?.imageUrl ?? "")
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: imageUrl)
            imageView.frame = previewContainerView.frame
            previewContainerView.addSubview(imageView)
            return
        }
        
        //  Create a video player
        let player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = previewContainerView.bounds
        previewContainerView.layer.addSublayer(playerLayer)
        player.play()
    }
    
}
