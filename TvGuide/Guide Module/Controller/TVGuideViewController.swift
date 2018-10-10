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

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.channels = Channel.channels()
    }

}

// MARK: - TableView

extension TVGuideViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
