import XCTest
import FBSnapshotTestCase
@testable import SnapTagsView

class SnapTagsViewTests: FBSnapshotTestCase {
    
    var viewConfig : SnapTagsViewConfiguration!
    var buttonConfig : SnapTagButtonConfiguration!
    
    override func setUp() {
        super.setUp()
        viewConfig = SnapTagsViewConfiguration.defaultConfiguration()
        buttonConfig = SnapTagButtonConfiguration.defaultConfiguration()
    }
    
    func testExample() {
        let tv = TagsView(frame: CGRectMake(0,0,320,44))
        
        tv.setViewConfig(viewConfig, buttonConfig: buttonConfig)
        tv.populateTagViewWithTagsAndDetermineHeight(initialTags())
        
        sut = tv
        snapshotVerifyView(sut)
    }
    
    internal func initialTags() -> [String] {
        return "Ave maris stella Dei Mater alma Atque semper Virgo Felix caeli porta".componentsSeparatedByString(" ")
    }
    
}
