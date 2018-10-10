//
//  Channel.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/10/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import UIKit

final class Channel: NSObject {
    
    var number:String?
    var name:String?
    var programs:[Movie]?
}

extension Channel {
    
    class func channels()->[Channel] {
        var channels : [Channel] = []
        let cal = Calendar.current
        var date = Date()
        date = cal.startOfDay(for: date)
        
        guard let startDate = cal.date(byAdding: .day, value: -1, to: date) else { return [] }
        
        let endDate = startDate.addingTimeInterval(Time.weekTimeInterval)
        
        for i in 1...15 {
            let ch:Channel = Channel()
            ch.number = "\(i)"
            ch.name = "CH \(i)"
            ch.programs = []
            ch.programs = movies(from: date, to: endDate)
            channels.append(ch)
        }
        
        return channels
    }
    
    private class func movies(from startDate: Date, to endDate: Date) -> [Movie] {
        var movieStartTime = startDate
        var counter = 1
        var movies = [Movie]()
        while movieStartTime.compare(endDate) == .orderedAscending {
            let moview = Movie()
            moview.name = "Movie \(counter)"
            let random = Int(arc4random_uniform(4)+1)
            moview.startTime = movieStartTime
            let movieEndTime = movieStartTime.addingTimeInterval(Double(random) * Time.houreTimeInterval)
            moview.endTime = movieEndTime
            movieStartTime = movieEndTime
            movies.append(moview)
            counter += 1
        }
        return movies
    }
}

