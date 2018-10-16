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
import RxDataSources

final class TVGuideViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ChannelViewModel!
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel = ChannelViewModel()
        setupTableViewUI()
        bindToTableView()
        bindToCollectionView()
        setupCollectionViewLayout()
    }
    
    func bindToTableView() {
        tableView.dataSource = nil
        viewModel.observable
            .bind(to: tableView.rx.items(cellIdentifier: ChannelTableViewCell.identifier,
                                         cellType: ChannelTableViewCell.self)) {
                                            row, channel, cell in
                                            cell.fillChannelData(channel)
                                            
            }
            .disposed(by: disposeBag)
    }
    
    func bindToCollectionView() {
        collectionView.dataSource = nil
        let rxdataSource = RxCollectionViewSectionedReloadDataSource<SectionOfMovie>(
            configureCell: { dataSource, collectionView, indexPath, movie in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifer, for: indexPath) as? MovieCollectionViewCell else {
                    
                    return UICollectionViewCell()
                }
                cell.fillMoviewDate(movie)
                return cell
        })
        viewModel.sectionsObservable
            .bind(to: collectionView.rx.items(dataSource: rxdataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helping Methods
    func setupTableViewUI() {
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 1
        tableView.rowHeight = 70
    }
    
    func setupCollectionViewLayout() {
        viewModel.observable
            .bind { [weak self] (channels) in
                let gridLayout = GridCollectionViewLayout(channels)
                self?.collectionView.collectionViewLayout = gridLayout
            }.disposed(by: disposeBag)
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
