//
//  TVGuideViewController.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/10/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class TVGuideViewController: UIViewController {
    
    // MARK: - Properties
    var channels: [Channel] = Channel.channels()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var channelsViewModels: ChannelViewModel!
    private let disposeBag = DisposeBag()

    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        setupCollectionViewLayout()
        setupTableViewUI()
        setUpViewModel()
    }
    
    func setUpViewModel() {
        channelsViewModels = ChannelViewModel()
        tableView.dataSource = nil
        channelsViewModels.observable
            .bind(to: tableView.rx.items(cellIdentifier: ChannelTableViewCell.identifier,
                                         cellType: ChannelTableViewCell.self)) {
                                            row, channel, cell in
                                            cell.fillChannelData(channel)
                                            
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helping Methods
    func setupTableViewUI() {
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 1
        tableView.rowHeight = 70
    }
    
    func setupCollectionViewLayout() {
        let gridLayout = GridCollectionViewLayout(channels)
        collectionView.collectionViewLayout = gridLayout
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
        if scrollView == tableView {
            collectionView.contentOffset = CGPoint(x: collectionView.contentOffset.x, y: tableView.contentOffset.y)
        }
        else {
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: collectionView.contentOffset.y)
        }
    }
}
