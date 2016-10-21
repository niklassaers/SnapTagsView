import UIKit
import SnapTagsView
import NSLayoutConstraint_ExpressionFormat


class ViewController: UIViewController {

    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var spacer: UIView!
    @IBOutlet weak var spacerWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!

    var searchBarController : SnapSearchBarController!
    let sizer = SnapTextWidthSizers()

    var leftAlignedCollectionViewHeightConstraint : NSLayoutConstraint!
    var centerAlignedCollectionViewHeightConstraint : NSLayoutConstraint!
    var leftAlignedMixedOnOffCollectionViewHeightConstraint : NSLayoutConstraint!
//    var searchBarHeightConstraint : NSLayoutConstraint!
//    var tagBarViewHeightConstraint : NSLayoutConstraint!



    var leftAlignedCollectionViewController : SnapTagsCollectionViewController!
    var centerAlignedCollectionViewController : SnapTagsCollectionViewController!
    var leftAlignedMixedOnOffCollectionViewController : SnapTagsCollectionViewController!
    var tagBarViewController : SnapTagsCollectionViewController!

    var currentTag = [ 0, 0, 0, 0, 0 ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLeftAlignedCollectionViewControllerAtIndex(1)
        setupCenterAlignedCollectionViewControllerAtIndex(4)
        setupLeftAlignedMixedOnOffCollectionViewControllerAtIndex(7)
        setupSearchBarControllerAtIndex(10)
        setupTagBarViewControllerAtIndex(13)
    }

    internal func setupLeftAlignedCollectionViewControllerAtIndex(_ index: Int) {
        leftAlignedCollectionViewController = SnapTagsCollectionViewController()
        leftAlignedCollectionViewController.sizer = sizer
        leftAlignedCollectionViewController.configuration = leftAlignedTagsViewConfig()
        leftAlignedCollectionViewController.buttonConfiguration = leftAlignedTagsViewButtonConfig()
        leftAlignedCollectionViewController.data = stringArrayToTags(initialTags())

        self.addChildViewController(leftAlignedCollectionViewController)
        contentStackView.insertArrangedSubview(leftAlignedCollectionViewController.view, at: index)
        leftAlignedCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false

        leftAlignedCollectionViewHeightConstraint = NSLayoutConstraint(expressionFormat: "self.height = 190", parameters: ["self": leftAlignedCollectionViewController.view])
        leftAlignedCollectionViewController.view.addConstraint(leftAlignedCollectionViewHeightConstraint)
    }

    internal func setupCenterAlignedCollectionViewControllerAtIndex(_ index: Int) {
        centerAlignedCollectionViewController = SnapTagsCollectionViewController()
        centerAlignedCollectionViewController.sizer = sizer
        centerAlignedCollectionViewController.configuration = centerAlignedTagsViewConfig()
        centerAlignedCollectionViewController.buttonConfiguration = centerAlignedTagsViewButtonConfig()
        centerAlignedCollectionViewController.data = stringArrayToTags(initialTags())

        self.addChildViewController(centerAlignedCollectionViewController)
        contentStackView.insertArrangedSubview(centerAlignedCollectionViewController.view, at: index)
        centerAlignedCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false

        centerAlignedCollectionViewHeightConstraint = NSLayoutConstraint(expressionFormat: "self.height = 190", parameters: ["self": centerAlignedCollectionViewController.view])
        centerAlignedCollectionViewController.view.addConstraint(centerAlignedCollectionViewHeightConstraint)
    }

    internal func setupLeftAlignedMixedOnOffCollectionViewControllerAtIndex(_ index: Int) {
        leftAlignedMixedOnOffCollectionViewController = SnapTagsCollectionViewController()
        leftAlignedMixedOnOffCollectionViewController.sizer = sizer
        leftAlignedMixedOnOffCollectionViewController.configuration = leftAlignedMixedOnOffTagsViewConfig()
        leftAlignedMixedOnOffCollectionViewController.buttonConfiguration = leftAlignedMixedOnOffTagsViewButtonConfig()
        leftAlignedMixedOnOffCollectionViewController.data = stringArrayToTags(initialTags())

        var i = 0
        for tag in leftAlignedMixedOnOffCollectionViewController.data {
            tag.isOn = i % 2 == 0
            i += 1
        }

        self.addChildViewController(leftAlignedMixedOnOffCollectionViewController)
        contentStackView.insertArrangedSubview(leftAlignedMixedOnOffCollectionViewController.view, at: index)
        leftAlignedMixedOnOffCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false

        leftAlignedMixedOnOffCollectionViewHeightConstraint = NSLayoutConstraint(expressionFormat: "self.height = 190", parameters: ["self": leftAlignedMixedOnOffCollectionViewController.view])
        leftAlignedMixedOnOffCollectionViewController.view.addConstraint(leftAlignedMixedOnOffCollectionViewHeightConstraint)
    }



    internal func setupSearchBarControllerAtIndex(_ index: Int) {

        let storyBoard = UIStoryboard(name: "SnapTagsView", bundle: Bundle(for: SnapSearchBarController.self))
        searchBarController = storyBoard.instantiateViewController(withIdentifier: "SnapSearchBarController") as! SnapSearchBarController
        searchBarController.sizer = sizer
        searchBarController.configuration = searchBarViewConfig()
        searchBarController.buttonConfiguration = searchBarViewButtonConfig()
        searchBarController.data = stringArrayToTags(initialTags())

        contentStackView.insertArrangedSubview(searchBarController.view, at: index)

    }





    internal func setupTagBarViewControllerAtIndex(_ index: Int) {

        let tagScrollView = SnapTagsHorizontalScrollView.createTagScrollView()
        contentStackView.insertArrangedSubview(tagScrollView, at: index)
        var constraints = [NSLayoutConstraint]()
        var dict : [String:UIView] = ["self": tagScrollView, "super": contentStackView]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.width = super.width", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.height = 44", parameters: dict))
        view.addConstraints(constraints)

        tagBarViewController = SnapTagsCollectionViewController()
        tagBarViewController.sizer = sizer
        tagBarViewController.configuration = tagBarViewConfig()
        tagBarViewController.buttonConfiguration = tagBarViewButtonConfig()
        tagBarViewController.data = stringArrayToTags(initialTags())

        self.addChildViewController(tagBarViewController)
        tagScrollView.addSubview(tagBarViewController.view)

        constraints = [NSLayoutConstraint]()
        dict = ["self": tagBarViewController.view, "super": tagScrollView]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.left = super.left", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.right = super.right", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.top = super.top", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.bottom = super.bottom", parameters: dict))
        tagScrollView.addConstraints(constraints)

        tagBarViewController.scrollEnabled = false
        let sizeForTags = tagBarViewController.calculateContentSizeForTags(tagBarViewController.data)

        constraints = [NSLayoutConstraint]()
        dict = ["self": tagBarViewController.view, "super": tagScrollView]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.width >= \(round(sizeForTags.width) + (tagBarViewController.configuration.horizontalMargin * 2))", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.height >= \(round(sizeForTags.height) + (tagBarViewController.configuration.verticalMargin * 2))", parameters: dict))
        tagScrollView.addConstraints(constraints)

    }

    internal func stringArrayToTags(_ strings: [String]) -> [SnapTagRepresentation] {
        return strings.map {
            let tag = SnapTagRepresentation()
            tag.tag = $0.trimmingCharacters(in: .whitespacesAndNewlines )
            return tag
        }
    }

    internal func initialTags() -> [String] {
        return "Sienaasappellimonadesiroop Ave maris stella Dei Mater alma Atque semper Virgo Felix caeli porta".components(separatedBy: " ")
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        slider.minimumValue = Float(self.view.bounds.size.width) * (-1.0)
        self.sliderValueChanged(slider)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        leftAlignedCollectionViewController.scrollEnabled = false
        let leftAlignedContentSize = leftAlignedCollectionViewController.contentSize()
        leftAlignedCollectionViewHeightConstraint.constant = leftAlignedContentSize.height

        centerAlignedCollectionViewController.scrollEnabled = false
        let centerAlignedContentSize = centerAlignedCollectionViewController.contentSize()
        centerAlignedCollectionViewHeightConstraint.constant = centerAlignedContentSize.height

        leftAlignedMixedOnOffCollectionViewController.scrollEnabled = false
        let leftAlignedMixedOnOffContentSize = leftAlignedMixedOnOffCollectionViewController.contentSize()
        leftAlignedMixedOnOffCollectionViewHeightConstraint.constant = leftAlignedMixedOnOffContentSize.height


        tagBarViewController.scrollEnabled = false

    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        spacerWidthLayoutConstraint.constant = CGFloat(sender.value) * (-1.0)
        self.view.setNeedsLayout()
    }


    internal func centeredTagsViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration()

        return config
    }

    //MARK: Left aligned config
    internal func leftAlignedTagsViewConfig() -> SnapTagsViewConfiguration {

        var config = SnapTagsViewConfiguration()
        config.spacing = 5.0
        config.horizontalMargin = 5.0
        config.verticalMargin = 5.0
        config.alignment = .left

        return config
    }

    internal func leftAlignedTagsViewButtonConfig() -> SnapTagButtonConfiguration {

        var c = SnapTagButtonConfiguration()
        c.font = UIFont.boldWithSize(13.0)
        c.canBeTurnedOnAndOff = true
        c.margin = UIEdgeInsets.zero
        c.labelInset = UIEdgeInsets(top: 6.5, left: 8.0, bottom: 6.5, right: 8.0)

        var onState = ButtonStateConfiguration()
        onState.buttonImage = UIImage.SnapTagsViewAssets.YellowCloseButton.image
        onState.backgroundColor = UIColor.roseColor()
        onState.textColor = UIColor.white
        onState.hasButton = false
        onState.cornerRadius = 5.0

        var offState = onState
        offState.buttonImage = UIImage.SnapTagsViewAssets.RedCloseButton.image
        offState.buttonTransform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI*45.0/180.0))
        offState.backgroundColor = UIColor.white
        offState.textColor = UIColor.roseColor()
        offState.borderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        offState.borderWidth = 1.0

        var highlightedOnState = onState
        highlightedOnState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)

        var highlightedOffState = offState
        highlightedOffState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)

        c.onState = onState
        c.offState = offState
        c.highlightedWhileOnState = highlightedOnState
        c.highlightedWhileOffState = highlightedOffState

        return c
    }

    //MARK: Center aligned config
    internal func centerAlignedTagsViewConfig() -> SnapTagsViewConfiguration {

        var config = SnapTagsViewConfiguration()
        config.spacing = 5.0
        config.horizontalMargin = 5.0
        config.verticalMargin = 5.0
        config.alignment = .center

        return config
    }

    internal func centerAlignedTagsViewButtonConfig() -> SnapTagButtonConfiguration {

        var c = SnapTagButtonConfiguration()
        c.font = UIFont.boldWithSize(13.0)
        c.canBeTurnedOnAndOff = false
        c.margin = UIEdgeInsets.zero
        c.labelInset = UIEdgeInsets(top: 6.5, left: 8.0, bottom: 6.5, right: 0.0)
        c.buttonInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 10.0)
        c.isTappable = true

        var onState = ButtonStateConfiguration()
        onState.buttonImage = UIImage.SnapTagsViewAssets.YellowCloseButton.image
        onState.backgroundColor = UIColor.roseColor()
        onState.textColor = UIColor.white
        onState.hasButton = true
        onState.cornerRadius = 5.0

        var offState = onState
        offState.backgroundImage = UIImage.SnapTagsViewAssets.RoundedButton_WhiteWithGreyBorder.image
        offState.backgroundColor = UIColor.white
        offState.textColor = UIColor.roseColor()
        offState.buttonImage = UIImage.SnapTagsViewAssets.RedCloseButton.image
        offState.buttonTransform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI*45.0/180.0))


        var highlightedOnState = onState
        highlightedOnState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)

        var highlightedOffState = offState
        highlightedOffState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)

        c.onState = onState
        c.offState = offState
        c.highlightedWhileOnState = highlightedOnState
        c.highlightedWhileOffState = highlightedOffState

        return c
    }

    //MARK: Left aligned mixed on/off config
    internal func leftAlignedMixedOnOffTagsViewConfig() -> SnapTagsViewConfiguration {

        var config = SnapTagsViewConfiguration()
        config.spacing = 5.0
        config.horizontalMargin = 5.0
        config.verticalMargin = 5.0
        config.alignment = .left

        return config
    }

    internal func leftAlignedMixedOnOffTagsViewButtonConfig() -> SnapTagButtonConfiguration {

        var c = SnapTagButtonConfiguration()
        c.font = UIFont.boldWithSize(13.0)
        c.canBeTurnedOnAndOff = true
        c.margin = UIEdgeInsets.zero
        c.labelInset = UIEdgeInsets(top: 6.5, left: 8.0, bottom: 6.5, right: 0.0)
        c.buttonInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 10.0)
        c.isTappable = true

        var onState = ButtonStateConfiguration()
        onState.buttonImage = UIImage.SnapTagsViewAssets.YellowCloseButton.image
        onState.backgroundColor = UIColor.roseColor()
        onState.textColor = UIColor.white
        onState.hasButton = true
        onState.cornerRadius = 5.0

        var offState = onState
        offState.backgroundImage = UIImage.SnapTagsViewAssets.RoundedButton_WhiteWithGreyBorder.image
        offState.backgroundColor = UIColor.white
        offState.textColor = UIColor.black
        offState.buttonImage = UIImage.SnapTagsViewAssets.RedCloseButton.image
        offState.buttonTransform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI*45.0/180.0))

        var highlightedOnState = onState
        highlightedOnState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)

        var highlightedOffState = offState
        highlightedOffState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)

        c.onState = onState
        c.offState = offState
        c.highlightedWhileOnState = highlightedOnState
        c.highlightedWhileOffState = highlightedOffState

        return c
    }

    //MARK: Search Bar config
    internal func searchBarViewConfig() -> SnapTagsViewConfiguration {

        var config = SnapTagsViewConfiguration()
        config.spacing = 5.0
        config.horizontalMargin = 11.0
        config.verticalMargin = 4.0
        config.alignment = .left
        config.scrollDirection = .horizontal
        config.padding = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 3.0, right: 66.0)

        return config
    }

    internal func searchBarViewButtonConfig() -> SnapTagButtonConfiguration {

        var c = SnapTagButtonConfiguration()
        c.intrinsicContentSize = CGSize(width: 80, height: 36)
        
        c.font = UIFont.mediumWithSize(13.0)
        c.canBeTurnedOnAndOff = false
        c.isTappable = true
        c.margin = UIEdgeInsets(top: 11.0, left: 1.0, bottom: 11.0, right: 0.0)
        c.labelInset = UIEdgeInsets(top: 7.0, left: 8.0, bottom: 7.0, right: 0.0)
        c.buttonInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10.0)
        
        var onState = ButtonStateConfiguration()
        onState.backgroundColor = UIColor.roseColor()
        onState.textColor = UIColor.white
        onState.buttonImage = UIImage.SnapTagsViewAssets.YellowCloseButton.image
        onState.hasButton = true
        onState.cornerRadius = 3.0
        onState.spacingBetweenLabelAndOnOffButton = 0
        
        var offState = onState
        offState.backgroundImage = UIImage.SnapTagsViewAssets.RoundedButton_WhiteWithGreyBorder.image
        offState.backgroundColor = UIColor.white
        offState.textColor = UIColor.roseColor()
        offState.buttonImage = UIImage.SnapTagsViewAssets.RedCloseButton.image
        offState.buttonTransform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI*45.0/180.0))
        
        var highlightedOnState = onState
        highlightedOnState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)
        
        var highlightedOffState = offState
        highlightedOffState.backgroundColor = UIColor(red: 229.0/255.0, green: 0.0, blue: 79.0/255.0, alpha: 1.0)
        
        c.onState = onState
        c.offState = offState
        c.highlightedWhileOnState = highlightedOnState
        c.highlightedWhileOffState = highlightedOffState


        return c
    }

    //MARK: Tag bar config
    internal func tagBarViewConfig() -> SnapTagsViewConfiguration {

        var config = SnapTagsViewConfiguration()
        config.spacing = 5.0
        config.horizontalMargin = 5.0
        config.verticalMargin = 5.0
        config.alignment = .left

        return config
    }

    internal func tagBarViewButtonConfig() -> SnapTagButtonConfiguration {

        var c = SnapTagButtonConfiguration()
        c.font = UIFont.boldWithSize(13.0)
        c.canBeTurnedOnAndOff = false
        c.margin = UIEdgeInsets.zero
        c.labelInset = UIEdgeInsets(top: 6.5, left: 8.0, bottom: 6.5, right: 8.0)

        var onState = ButtonStateConfiguration()
        onState.backgroundColor = UIColor.white
        onState.backgroundImage = UIImage.SnapTagsViewAssets.RoundedButton_WhiteWithGreyBorder.image
        onState.textColor = UIColor.roseColor()
        onState.cornerRadius = 0.0
        onState.hasButton = false

        let offState = onState

        let highlightedOnState = onState

        let highlightedOffState = offState

        c.onState = onState
        c.offState = offState
        c.highlightedWhileOnState = highlightedOnState
        c.highlightedWhileOffState = highlightedOffState

        return c
    }

}
