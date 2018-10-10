//
//  TVGuideViewController.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/10/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import UIKit

final class TVGuideViewController: UIViewController {
    
    // MARK: - Properties
    var channels: [Channel] = Channel.channels()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableViewUI()
    }
    
    func setupTableViewUI() {
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 1
    }

}

// MARK: - TableView
extension TVGuideViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let channelCell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else {
            
            return UITableViewCell()
        }
        let channel = channels[indexPath.row]
        channelCell.fillChannelData(channel)
        
        return channelCell
    }
}

// MARK: - CollectionView
extension TVGuideViewController: UICollectionViewDataSource {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movies = channels[section].movies else { return 0 }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifer, for: indexPath) as? MovieCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        guard let movies = channels[indexPath.section].movies else {
            
            return movieCell
        }
        let movie = movies[indexPath.row]
        movieCell.fillMoviewDate(movie)
        
        return movieCell
    }
}

// MARK: - Scroll delegate
extension TVGuideViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView == tableView) {
            collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: tableView.contentOffset.y)
        }
        else {
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: collectionView.contentOffset.y)
        }
    }
}
