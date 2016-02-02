import Foundation
import UIKit

public class SnapTagsViewConfiguration : NSObject {
    
    public var spacing = 5.0 as CGFloat
    public var horizontalMargin = 5.0 as CGFloat
    public var verticalMargin = 5.0 as CGFloat
    public var contentHeight = 30.0 as CGFloat
    public var scrollDirection : UICollectionViewScrollDirection = .Vertical
    
    var alignment : NSTextAlignment = .Left //*
    
    func isValid() -> Bool {
        return true
    }
    
    public static func defaultConfiguration() -> SnapTagsViewConfiguration {
        return SnapTagsViewConfiguration()
    }
    
}

