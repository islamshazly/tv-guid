//
//  File.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/16/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import RxSwift
import RxCocoa

final class ChannelViewModel {
    
    // MARK: - Private properties
    private let channels: Variable<[Channel]> = Variable([Channel]())
    private let disposeBag = DisposeBag()
    
    // MARK: - Outputs
    public let observable: Observable<[Channel]>
    
    // MARK: - init
    init() {
        // it should be observable and send new values
        // assign observables before fill data to show concept of observing
        self.observable = self.channels.asObservable()
        self.channels.value = Channel.channels()
    }
    
}
