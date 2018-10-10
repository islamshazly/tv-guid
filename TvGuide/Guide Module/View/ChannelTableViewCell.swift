//
//  ChannelTableViewCell.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/10/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import UIKit

final class ChannelTableViewCell: UITableViewCell {
 
    // MARK: - Properties

    static let identifier: String = "ChannelTableViewCell"
    
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .darkGray
        self.textLabel?.textColor = .white
        self.detailTextLabel?.textColor = .white
    }
    
    // MARK: - Helping Mehtods

    func fillChannelData(_ channel: Channel) {
        self.textLabel?.text = channel.name
        self.detailTextLabel?.text = channel.number
    }
}
