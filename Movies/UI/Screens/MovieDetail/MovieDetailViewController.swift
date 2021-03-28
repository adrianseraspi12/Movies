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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var movie: MainMovies?
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if player == nil {
            setupVideoPlayer()
        }
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onPlayerPressed(sender : UITapGestureRecognizer) {
        guard let player = player else { return }
        
        //  Check if player is playing
        if (player.rate != 0) && (player.error == nil) {
            player.pause()
        } else {
            player.play()
        }
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
        
        //  Add on tap gesture on player container view
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(onPlayerPressed(sender:)))
        previewContainerView.addGestureRecognizer(gesture)
        
        //  Create a video player
        player = AVPlayer(url: videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = previewContainerView.bounds
        previewContainerView.layer.addSublayer(playerLayer)
        player?.addObserver(self,
                            forKeyPath: "timeControlStatus",
                            options: [.old, .new],
                            context: nil)
        player?.play()
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        self?.loadingIndicator.isHidden = true
                    } else {
                        self?.loadingIndicator.isHidden = false
                    }
                }
            }
        }
    }
    
}
