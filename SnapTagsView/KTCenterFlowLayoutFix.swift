import Foundation
import KTCenterFlowLayout

public extension KTCenterFlowLayout {

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        let modifiedLayoutAttributes = self.layoutAttributesForElements(in: CGRect.infinite)

        let layoutAttributesForIndexPath = modifiedLayoutAttributes?.filter({ indexPath == $0.indexPath })
        if let desiredLayAttr = layoutAttributesForIndexPath?.first {
            return desiredLayAttr
        }
        else
        {
            NSLog("error")
            return super.layoutAttributesForItem(at: indexPath)
        }
    }
}
