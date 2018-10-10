//
//  GuideCollectionViewCell.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/10/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifer: String = "MovieCollectionViewCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // MARK: - Helping Mehtods
    func fillMoviewDate(_ movie: Movie) {
        nameLabel.text = movie.name
        timeLabel.text = movie.timeString
    }
    
}
