//
//  GridLayout.swift
//  TvGuide
//
//  Created by Islam Elshazly on 10/10/18.
//  Copyright © 2018 360vuz. All rights reserved.
//

import UIKit

final class GridLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    
    private var startTime: Date!
    private var endTime: Date!
    private var xPos: CGFloat = 0
    private var yPos: CGFloat = 0
    private var layoutInfo: NSMutableDictionary?
    private var framesInfo: NSMutableDictionary?
    let titleWidth: CGFloat = 200
    let titleHeight: CGFloat = 70
    let cellIdentifier = "GridCell"
    
    private var channels: [Channel]?
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let cal = Calendar.current
        var date = Date()
        date = cal.startOfDay(for: date)
        date = (cal as NSCalendar).date(byAdding: .day, value: -1, to: date, options: [])!
        startTime = date
        endTime = startTime.addingTimeInterval(Constants.weekTimeInterval)
        layoutInfo = NSMutableDictionary()
        framesInfo = NSMutableDictionary()
        channels = Channel.channels()
    }
    
    // MARK: -  Life Cycle
    
    override func prepare() {
        calculateFramesForAllMovies()
        let newLayoutInfo = NSMutableDictionary()
        let cellLayoutInfo = NSMutableDictionary()
        guard let channels = channels else { return }
        
        for section in 0..<channels.count {
            let channel = channels[section]
            guard let movies = channel.movies else { continue }
            
            for index in 0..<movies.count {
                let indexPath = IndexPath(item: index, section: section)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = frameForItemAtIndexPath(indexPath)
                cellLayoutInfo[indexPath] = itemAttributes
            }
        }
        
        newLayoutInfo[cellIdentifier] = cellLayoutInfo
        layoutInfo = newLayoutInfo
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes  = [UICollectionViewLayoutAttributes]()
        
        let enumerateClosure = { (object: Any, attributes: Any, stop: UnsafeMutablePointer<ObjCBool>) in
            guard let attributes = attributes as? UICollectionViewLayoutAttributes, rect.intersects(attributes.frame) else { return }
            layoutAttributes.append(attributes)
        }
        
        layoutInfo?.enumerateKeysAndObjects({ (object: Any, elementInfo: Any, stop: UnsafeMutablePointer<ObjCBool>) in
            guard let infoDic = elementInfo as? NSDictionary else { return }
            infoDic.enumerateKeysAndObjects(enumerateClosure)
        })
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> (UICollectionViewLayoutAttributes?) {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = self.frameForItemAtIndexPath(indexPath)
        return attributes
    }
    
    override var collectionViewContentSize : CGSize {
        guard let channels = channels else { return CGSize.zero }
        
        let intervals = endTime.timeIntervalSince(startTime)
        let numberOfHours = CGFloat(intervals / Constants.hourTimeInterval)
        let width = numberOfHours * titleWidth
        let height = CGFloat(channels.count) * titleHeight
        return CGSize(width: width, height: height)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return !collectionView!.bounds.size.equalTo(newBounds.size)
    }
    
    override func invalidateLayout() {
        xPos = 0
        yPos = 0
        super.invalidateLayout()
    }
    
    // MARK: - Helping Methods
    
    private func tileSize(for movie : Movie) -> CGSize {
        let duartionFactor = movie.duration / Constants.hourTimeInterval
        let width: CGFloat = CGFloat(duartionFactor * Constants.titleWidth)
        return CGSize(width: width, height: titleHeight)
    }
    
    private func calculateFramesForAllMovies() {
        guard let channels = channels else { return }
        for i in 0..<channels.count {
            xPos = 0
            let channel = channels[i]
            guard let movies = channel.movies else {
                yPos += titleHeight
                continue
            }
            for index in 0..<movies.count {
                let movie = movies[index]
                let tileSize = self.tileSize(for: movie)
                let frame = CGRect(x: xPos, y: yPos, width: tileSize.width, height: tileSize.height)
                let rectString = NSCoder.string(for: frame)
                let indexPath = IndexPath(item: index, section: i)
                framesInfo?[indexPath] = rectString
                xPos = xPos+tileSize.width
            }
            yPos += titleHeight
        }
    }
    
    private func frameForItemAtIndexPath(_ indexPath : IndexPath) -> CGRect {
        guard let infoDic = framesInfo, let rectString = infoDic[indexPath] as? String else { return CGRect.zero }
        return NSCoder.cgRect(for: rectString)
    }

}
