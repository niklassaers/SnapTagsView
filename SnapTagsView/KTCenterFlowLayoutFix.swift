import Foundation
import KTCenterFlowLayout

public extension KTCenterFlowLayout {
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        let modifiedLayoutAttributes = self.layoutAttributesForElementsInRect(CGRectInfinite)
        
        let layoutAttributesForIndexPath = modifiedLayoutAttributes?.filter({ indexPath.isEqual($0.indexPath) })
        if let desiredLayAttr = layoutAttributesForIndexPath?.first {
            return desiredLayAttr
        }
        else
        {
            NSLog("error")
            return super.layoutAttributesForItemAtIndexPath(indexPath)
        }
    }
}