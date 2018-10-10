//
//  ViewController.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/10/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import UIKit

final class TVGuideViewController: UIViewController {
    
    // MARK: - Properties
    
    var channels: [Channel]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.channels = Channel.channels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 1
    }

}

// MARK: - TableView

extension TVGuideViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let channels = channels else { return 0 }
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        let channel = channels[indexPath.row]
        cell?.textLabel?.text = channel.name
        cell?.detailTextLabel?.text = channel.number
        cell?.backgroundColor = .darkGray
        cell?.textLabel?.textColor = .white
        cell?.detailTextLabel?.textColor = .white
        
        return cell!
    }
}

// MARK: - CollectionView

extension TVGuideViewController: UICollectionViewDataSource {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let channels = channels else { return 0 }
        return channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let channel = channels?[section], let movies = channel.movies else { return 0 }
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        guard let channel = channels?[indexPath.section], let movies = channel.movies else { return cell }
        
        let movie = movies[indexPath.row]
        cell.name.text = "\(channel.name!) \(movie.name!)"
        cell.time.text = movie.timeString
        
        return cell
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
