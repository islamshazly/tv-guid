//
//  File.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/16/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import RxSwift
import RxDataSources

final class ChannelViewModel {
    
    // MARK: - Private properties
    private let channels: Variable<[Channel]> = Variable([Channel]())
    private let sectionChannels :Variable<[SectionOfMovie]> = Variable([SectionOfMovie]())
    
    // MARK: - Outputs
    public let observable: Observable<[Channel]>
    public let sectionsObservable: Observable<[SectionOfMovie]>
    
    // MARK: - init
    init() {
        // it should be observable and send new values
        // assign observables before fill data to show concept of observing
        self.observable = self.channels.asObservable()
        self.channels.value = Channel.channels()
        self.sectionsObservable = sectionChannels.asObservable()
        self.sectionChannels.value = initSectionOfMoview()
    }
    
    func initSectionOfMoview() ->  [SectionOfMovie] {
        var sections = [SectionOfMovie]()
        _ = self.observable.bind { (channels) in
            channels.forEach { channel in
                let section = SectionOfMovie(header: channel.name!, items: channel.movies!)
                sections.append(section)
            }
        }
        
        return sections
    }
}

// MARK: - RxDataSource
struct SectionOfMovie {
    var header: String
    var items: [Item]
}

extension SectionOfMovie: SectionModelType {
    
    typealias Item = Movie
    init(original: SectionOfMovie, items: [Movie]) {
        self = original
        self.items = items
    }
}
