//
//  Movie.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/10/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import Foundation

final class Movie: NSObject {
    
    // MARK: - Properties
    
    var name: String?
    var startTime: Date?
    var endTime: Date?
    
    //MARK: - Computed Properties

    var timeString: String {
        guard let startTime = startTime,
            let endTime = endTime else {
                return "No info available"
                
        }
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "h:mma"
        
        return "\(dateFormater.string(from: startTime)) - \(dateFormater.string(from: endTime))"
    }
    var duration: TimeInterval {
        guard let startTime = startTime,
            let endTime = endTime else {
                return 0
        }
        return endTime.timeIntervalSince(startTime)
    }
}

