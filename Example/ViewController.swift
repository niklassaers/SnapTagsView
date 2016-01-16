import UIKit
import SnapTagsView

class ViewController: UIViewController {
    
    @IBOutlet weak var normalSizeTagsView: TagsView!
    @IBOutlet weak var reducedHeightTagsView: TagsView!
    @IBOutlet weak var centeredTagsView: TagsView!
    
    var currentTag = [ 0, 0, 0 ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        normalSizeTagsView.setViewConfig(normalSizeViewConfig(), buttonConfig: normalSizeButtonConfig())
        normalSizeTagsView.tag = 0
        
        reducedHeightTagsView.setViewConfig(reducedHeightViewConfig(), buttonConfig: reducedHeightButtonConfig())
        normalSizeTagsView.tag = 1
        
        centeredTagsView.setViewConfig(centeredViewConfig(), buttonConfig: centeredButtonConfig())
        normalSizeTagsView.tag = 2

        
        let normalSize = normalSizeTagsView.populateTagViewWithTagsAndDetermineHeight(initialTags())
        let reducedSize = reducedHeightTagsView.populateTagViewWithTagsAndDetermineHeight(initialTags())
        let centeredSize = centeredTagsView.populateTagViewWithTagsAndDetermineHeight(initialTags())
        
    }
    
    internal func initialTags() -> [String] {
        return "Ave maris stella Dei Mater alma Atque semper Virgo Felix caeli porta".componentsSeparatedByString(" ")
    }
    
    internal func nextTag(view: TagsView) -> String {
        let rest = (
                "Sumens illud Ave " +
                "Gabrielis ore " +
                "Funda nos in pace " +
                "Mutans Evae nomen " +
                "Solve vincla reis " +
                "Profer lumen caecis " +
                "Mala nostra pelle " +
                "Bona cuncta posce " +
                "Monstra te esse matrem " +
                "Sumat per te preces " +
                "Qui pro nobis natus " +
                "Tulit esse tuus " +
                "Virgo singularis " +
                "Inter omnes mitis " +
                "Nos culpis solutos " +
                "Mites fac et castos " +
                "Vitam praesta puram " +
                "Iter para tutum " +
                "Ut videntes Jesum " +
                "Semper collaetemur " +
                "Sit laus Deo Patri " +
                "Summo Christo decus " +
                "Spiritui Sancto " +
                "Tribus honor unus Amen").componentsSeparatedByString(" ")

        let index = currentTag[view.tag]
        let tag = rest[index]
        currentTag[view.tag] = (index + 1) % rest.count
        return tag
    }

    internal func normalSizeViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration.defaultConfiguration()

        return config
    }
    
    internal func normalSizeButtonConfig() -> SnapTagButtonConfiguration {
        let config = SnapTagButtonConfiguration.defaultConfiguration()
        
        return config
    }
    
    internal func reducedHeightViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration.defaultConfiguration()
        
        return config
    }
    
    internal func reducedHeightButtonConfig() -> SnapTagButtonConfiguration {
        let config = SnapTagButtonConfiguration.defaultConfiguration()
        
        return config
    }
    
    internal func centeredViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration.defaultConfiguration()
        
        return config
    }
    
    internal func centeredButtonConfig() -> SnapTagButtonConfiguration {
        let config = SnapTagButtonConfiguration.defaultConfiguration()
        
        return config
    }
    

}

