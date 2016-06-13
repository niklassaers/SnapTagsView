import Foundation

/*
 There is a bug in flow layout where it will not correctly lay out cells that are offscreen, but cache the error, 
 and use that cache to show it incorrectly when coming on-screen again
 */

public class LessBuggyCollectionViewFlowLayout : UICollectionViewFlowLayout {
 
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if var attributes = super.layoutAttributesForElementsInRect(rect) {
            var i = 0
            var fixInvaliidLayout = false
            for attribute in attributes {
                defer { i += 1 }
                
                if attribute.frame.origin.x == 0 && attribute.frame.origin.y == 0 {
                    fixInvaliidLayout = true

                    let attribute = attribute.copy() as! UICollectionViewLayoutAttributes
                    attribute.frame.origin.y = sectionInset.top
                    attributes[i] = attribute
                }
                
            }
            
            if fixInvaliidLayout == true {
                let sortedAttributes = attributes.sort({ (a, b) -> Bool in
                    if a.indexPath.section == b.indexPath.section {
                        return a.indexPath.item < b.indexPath.row
                    }
                    return a.indexPath.section < b.indexPath.section
                })

                var pos = sectionInset.left as CGFloat
                let relaidOutAttributes : [UICollectionViewLayoutAttributes] = sortedAttributes.map { inAttribute in
                    let attribute = inAttribute.copy() as! UICollectionViewLayoutAttributes
                    attribute.frame.origin.x = pos
                    pos += attribute.frame.size.width + minimumInteritemSpacing
                    return attribute
                }
                
                return relaidOutAttributes
                
            }
            
            return attributes
        }
        
        return nil
    }
}