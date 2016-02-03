import UIKit
import SnapTagsView
import NSLayoutConstraint_ExpressionFormat


class ViewController: UIViewController {
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var spacer: UIView!
    @IBOutlet weak var spacerWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    
    let sizer = SnapTextWidthSizers()
    var leftAlignedCollectionViewHeightConstraint : NSLayoutConstraint!

    
    @IBOutlet weak var leftAlignLabel: UILabel!
    var leftAlignedCollectionViewController : SnapTagsCollectionViewController!
    var currentTag = [ 0, 0, 0, 0 ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftAlignedCollectionViewController = SnapTagsCollectionViewController()
        leftAlignedCollectionViewController.sizer = sizer
        leftAlignedCollectionViewController.configuration = leftAlignedTagsViewConfig()
        leftAlignedCollectionViewController.buttonConfiguration = leftAlignedTagsViewButtonConfig()
        leftAlignedCollectionViewController.data = stringArrayToTags(initialTags())
        
        self.addChildViewController(leftAlignedCollectionViewController)
        contentStackView.insertArrangedSubview(leftAlignedCollectionViewController.view, atIndex: 2)
        leftAlignedCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        leftAlignedCollectionViewHeightConstraint = NSLayoutConstraint(expressionFormat: "self.height = 190", parameters: ["self": leftAlignedCollectionViewController.view])
        leftAlignedCollectionViewController.view.addConstraint(leftAlignedCollectionViewHeightConstraint)

    }
    
    internal func stringArrayToTags(strings: [String]) -> [SnapTagRepresentation] {
        var i = 0
        return strings.map {
            let tag = SnapTagRepresentation()
            tag.tag = $0.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            tag.isOn = i % 2 == 0
            i += 1
            return tag
        }
    }
    
    internal func initialTags() -> [String] {
        return "Sienaasappellimonadesiroop Ave maris stella Dei Mater alma Atque semper Virgo Felix caeli porta".componentsSeparatedByString(" ")
    }
    
    /*
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
    }*/
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        slider.minimumValue = Float(self.view.bounds.size.width) * (-1.0)
        self.sliderValueChanged(slider)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        leftAlignedCollectionViewController.scrollEnabled = false
        let leftAlignedContentSize = leftAlignedCollectionViewController.contentSize()
        leftAlignedCollectionViewHeightConstraint.constant = leftAlignedContentSize.height
//        leftAlignedCollectionViewHeightConstraint = NSLayoutConstraint(expressionFormat: "self.height = \(leftAlignedContentSize.width)", parameters: ["self": leftAlignedCollectionViewController.view])
        contentStackView.setNeedsLayout()
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
        // 30 dp high
        // 5 dp vertical spacing
        // 5 horizontal spacing
        // 10 dp between last letter and X
        // 10 dp between leading edge and first letter
        // 10 dp betwwen trailing X and trailing edge
        // 10 dp margin top and bottom
        // Font 13dp Medium #FFFFFF
        // Background #FF0058
        // Corner radius 4dp
        
        let config = SnapTagsViewConfiguration()
        config.spacing = 5.0 as CGFloat
        config.horizontalMargin = 5.0 as CGFloat
        config.verticalMargin = 5.0 as CGFloat
        config.contentHeight = 13.0 as CGFloat
        config.alignment = .Center
//        config.alignment = .Left
//        config.alignment = .Natural
        
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
        // 30 dp high
        // 5 dp vertical spacing
        // 5 horizontal spacing
        // 10 dp between last letter and X
        // 10 dp between leading edge and first letter
        // 10 dp betwwen trailing X and trailing edge
        // 10 dp margin top and bottom
        // Font 13dp Medium #FFFFFF
        // Background #FF0058
        // Corner radius 4dp

        let c = SnapTagButtonConfiguration()
        
        c.onOffButtonImage.onImage = UIImage.Asset.YellowCloseButton.image
        c.onOffButtonImage.offTransform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI*45.0/180.0))
        c.onOffButtonImage.offImage = UIImage.Asset.RedCloseButton.image
        
        c.onBackgroundImage = UIImage.Asset.RoundedButtonFilled.image
        c.offBackgroundImage = UIImage.Asset.RoundedButton.image

        c.font = UIFont.boldWithSize(13.0)
        c.onBackgroundColor = UIColor.roseColor()
        c.offBackgroundColor = UIColor.whiteColor()
        c.onTextColor = UIColor.whiteColor()
        c.offTextColor = UIColor.roseColor()
        c.isTurnOnOffAble = true
        
        assert(c.isValid())
        return c
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

