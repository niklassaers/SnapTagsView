import UIKit
import SnapTagsView

class ViewController: UIViewController {
    
    @IBOutlet weak var spacer: UIView!
    @IBOutlet weak var spacerWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var centeredTagsView: TagsView!
    @IBOutlet weak var leftAlignedTagsView: TagsView!
    @IBOutlet weak var searchTagsView: TagsView!
    @IBOutlet weak var tagBarView: TagsView!
    
    var currentTag = [ 0, 0, 0, 0 ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centeredTagsView.setViewConfig(centeredTagsViewConfig(), buttonConfig: centeredTagsViewButtonConfig())
        centeredTagsView.tag = 0
        
        leftAlignedTagsView.setViewConfig(leftAlignedTagsViewConfig(), buttonConfig: leftAlignedTagsViewButtonConfig())
        leftAlignedTagsView.tag = 1
        
        searchTagsView.setViewConfig(searchTagsViewConfig(), buttonConfig: searchTagsViewButtonConfig())
        leftAlignedTagsView.tag = 2
        
        tagBarView.setViewConfig(tagBarViewConfig(), buttonConfig: tagBarViewButtonConfig())
        searchTagsView.tag = 3

        
        let centeredTagsViewSize = centeredTagsView.populateTagViewWithTagsAndDetermineHeight(initialTags())
        let leftAlignedTagsViewSize = leftAlignedTagsView.populateTagViewWithTagsAndDetermineHeight(initialTags())
        let searchTagsViewSize = searchTagsView.populateTagViewWithTagsAndDetermineHeight(initialTags())
        let tagBarViewSize = tagBarView.populateTagViewWithTagsAndDetermineHeight(initialTags())
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        slider.minimumValue = Float(self.view.bounds.size.width) * (-1.0)
        self.sliderValueChanged(slider)
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        spacerWidthLayoutConstraint.constant = CGFloat(sender.value) * (-1.0)
        self.view.setNeedsLayout()
    }
    
    
    internal func centeredTagsViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration.defaultConfiguration()

        return config
    }
    
    internal func leftAlignedTagsViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration.defaultConfiguration()
        
        return config
    }
    
    internal func searchTagsViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration.defaultConfiguration()
        
        return config
    }
    
    internal func tagBarViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration.defaultConfiguration()
        
        return config
    }
    

    
    
    internal func centeredTagsViewButtonConfig() -> SnapTagButtonConfiguration {
        let config = SnapTagButtonConfiguration.defaultConfiguration()
        
        return config
    }
    
    internal func leftAlignedTagsViewButtonConfig() -> SnapTagButtonConfiguration {
        let config = SnapTagButtonConfiguration.defaultConfiguration()
        
        return config
    }
    
    internal func searchTagsViewButtonConfig() -> SnapTagButtonConfiguration {
        let config = SnapTagButtonConfiguration.defaultConfiguration()
        
        return config
    }

    internal func tagBarViewButtonConfig() -> SnapTagButtonConfiguration {
        let config = SnapTagButtonConfiguration.defaultConfiguration()
        
        return config
    }


}

