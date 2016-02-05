import UIKit
import SnapTagsView
import NSLayoutConstraint_ExpressionFormat


class ViewController: UIViewController {
    
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var spacer: UIView!
    @IBOutlet weak var spacerWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    
    let searchBar = UISearchBar(frame: CGRectZero)
    let sizer = SnapTextWidthSizers()
    
    var leftAlignedCollectionViewHeightConstraint : NSLayoutConstraint!
    var centerAlignedCollectionViewHeightConstraint : NSLayoutConstraint!
    var leftAlignedMixedOnOffCollectionViewHeightConstraint : NSLayoutConstraint!
    var searchBarHeightConstraint : NSLayoutConstraint!
    var tagBarViewHeightConstraint : NSLayoutConstraint!

    
    
    var leftAlignedCollectionViewController : SnapTagsCollectionViewController!
    var centerAlignedCollectionViewController : SnapTagsCollectionViewController!
    var leftAlignedMixedOnOffCollectionViewController : SnapTagsCollectionViewController!
    var searchBarController : SnapTagsCollectionViewController!
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
    
    internal func setupLeftAlignedCollectionViewControllerAtIndex(index: Int) {
        leftAlignedCollectionViewController = SnapTagsCollectionViewController()
        leftAlignedCollectionViewController.sizer = sizer
        leftAlignedCollectionViewController.configuration = leftAlignedTagsViewConfig()
        leftAlignedCollectionViewController.buttonConfiguration = leftAlignedTagsViewButtonConfig()
        leftAlignedCollectionViewController.data = stringArrayToTags(initialTags())
        
        self.addChildViewController(leftAlignedCollectionViewController)
        contentStackView.insertArrangedSubview(leftAlignedCollectionViewController.view, atIndex: index)
        leftAlignedCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        leftAlignedCollectionViewHeightConstraint = NSLayoutConstraint(expressionFormat: "self.height = 190", parameters: ["self": leftAlignedCollectionViewController.view])
        leftAlignedCollectionViewController.view.addConstraint(leftAlignedCollectionViewHeightConstraint)
    }
    
    internal func setupCenterAlignedCollectionViewControllerAtIndex(index: Int) {
        centerAlignedCollectionViewController = SnapTagsCollectionViewController()
        centerAlignedCollectionViewController.sizer = sizer
        centerAlignedCollectionViewController.configuration = centerAlignedTagsViewConfig()
        centerAlignedCollectionViewController.buttonConfiguration = centerAlignedTagsViewButtonConfig()
        centerAlignedCollectionViewController.data = stringArrayToTags(initialTags())
        
        self.addChildViewController(centerAlignedCollectionViewController)
        contentStackView.insertArrangedSubview(centerAlignedCollectionViewController.view, atIndex: index)
        centerAlignedCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        centerAlignedCollectionViewHeightConstraint = NSLayoutConstraint(expressionFormat: "self.height = 190", parameters: ["self": centerAlignedCollectionViewController.view])
        centerAlignedCollectionViewController.view.addConstraint(centerAlignedCollectionViewHeightConstraint)
    }
    
    internal func setupLeftAlignedMixedOnOffCollectionViewControllerAtIndex(index: Int) {
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
        contentStackView.insertArrangedSubview(leftAlignedMixedOnOffCollectionViewController.view, atIndex: index)
        leftAlignedMixedOnOffCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        leftAlignedMixedOnOffCollectionViewHeightConstraint = NSLayoutConstraint(expressionFormat: "self.height = 190", parameters: ["self": leftAlignedMixedOnOffCollectionViewController.view])
        leftAlignedMixedOnOffCollectionViewController.view.addConstraint(leftAlignedMixedOnOffCollectionViewHeightConstraint)
    }
    
    
    
    internal func setupSearchBarControllerAtIndex(index: Int) {
        contentStackView.insertArrangedSubview(searchBar, atIndex: index)
        searchBar.delegate = self
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()
        var searchTextField_ : UITextField? = nil
        for subview in searchBar.subviews.first?.subviews ?? [UIView]() {
            if let subview = subview as? UITextField {
                searchTextField_ = subview
                break
            }
        }
        
        guard let searchTextField = searchTextField_ else {
            print("Could not find textfield in searchbar")
            return
        }
        
        searchTextField.leftViewMode = .Never
        searchTextField.rightViewMode = .Never

        let tagScrollView = setupTagScrollViewAsSubviewOf(searchTextField)


        
        searchBarController = SnapTagsCollectionViewController()
        searchBarController.sizer = sizer
        searchBarController.configuration = searchBarViewConfig()
        searchBarController.buttonConfiguration = searchBarViewButtonConfig()
        searchBarController.data = stringArrayToTags(initialTags())
        
        self.addChildViewController(searchBarController)
        tagScrollView.addSubview(searchBarController.view)
        
        var constraints = [NSLayoutConstraint]()
        let dict = ["self": searchBarController.view, "super": tagScrollView]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.right = super.right", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.bottom = super.bottom", parameters: dict))
        tagScrollView.addConstraints(constraints)

        searchBarController.scrollEnabled = false
        searchBarController.view.translatesAutoresizingMaskIntoConstraints = true
        
        var frame = searchBarController.view.frame
        frame.size.width = searchBarController.calculateContentSizeForTags(searchBarController.data).width
        frame.size.height = tagScrollView.frame.height
        searchBarController.view.frame = frame

        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()
        
        var textFieldFrame = searchTextField.frame
        textFieldFrame.size.height = 34
        searchTextField.frame = textFieldFrame
        
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.searchBar.layoutIfNeeded()
        self.searchBar.layoutSubviews()
        
//        var searchBarFrame = searchBar.frame
        let newHeight: CGFloat = 36 //desired textField Height.
        for subView in searchBar.subviews
        {
            for subsubView in subView.subviews
            {
                if let textField = subsubView as? UITextField
                {
                    var currentTextFieldBounds = textField.bounds
                    currentTextFieldBounds.size.height = newHeight
                    textField.bounds = currentTextFieldBounds
                    textField.borderStyle = UITextBorderStyle.RoundedRect
                    //textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                }
            }
        }
    }

    internal func createTagScrollView() -> UIScrollView {
        let tagScrollView = UIScrollView(frame: CGRectZero)
        tagScrollView.showsHorizontalScrollIndicator = false
        tagScrollView.showsVerticalScrollIndicator = false
        tagScrollView.bounces = true
        tagScrollView.alwaysBounceVertical = false
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        return tagScrollView
    }
    
    internal func setupTagScrollViewAsSubviewOf(view: UIView) -> UIScrollView {
        let tagScrollView = createTagScrollView()
        view.addSubview(tagScrollView)
        
        var constraints = [NSLayoutConstraint]()
        let dict : [String:UIView] = ["self": tagScrollView, "super": view]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.left = super.left + 3", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.right = super.right - 3", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.top = super.top + 4", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.bottom = super.bottom - 4", parameters: dict))
        view.addConstraints(constraints)
        return tagScrollView
    }
    
    internal func setupTagBarViewControllerAtIndex(index: Int) {
        
        let tagScrollView = createTagScrollView()
        contentStackView.insertArrangedSubview(tagScrollView, atIndex: index)
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
        constraints.append(NSLayoutConstraint(expressionFormat: "self.width >= \(sizeForTags.width)", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.height >= \(sizeForTags.height + (tagBarViewController.configuration.verticalMargin * 2))", parameters: dict))
        tagScrollView.addConstraints(constraints)

        
    }
    
    internal func stringArrayToTags(strings: [String]) -> [SnapTagRepresentation] {
        return strings.map {
            let tag = SnapTagRepresentation()
            tag.tag = $0.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
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
        
        centerAlignedCollectionViewController.scrollEnabled = false
        let centerAlignedContentSize = centerAlignedCollectionViewController.contentSize()
        centerAlignedCollectionViewHeightConstraint.constant = centerAlignedContentSize.height

        leftAlignedMixedOnOffCollectionViewController.scrollEnabled = false
        let leftAlignedMixedOnOffContentSize = leftAlignedMixedOnOffCollectionViewController.contentSize()
        leftAlignedMixedOnOffCollectionViewHeightConstraint.constant = leftAlignedMixedOnOffContentSize.height
        
        searchBarController.scrollEnabled = true

        tagBarViewController.scrollEnabled = false

    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        spacerWidthLayoutConstraint.constant = CGFloat(sender.value) * (-1.0)
        self.view.setNeedsLayout()
    }
    
    
    internal func centeredTagsViewConfig() -> SnapTagsViewConfiguration {
        let config = SnapTagsViewConfiguration.defaultConfiguration()

        return config
    }
    
    //MARK: Left aligned config
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
        config.alignment = .Left
        
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
        
        // c.onBackgroundImage = UIImage.Asset.RoundedButtonFilled.image
        // c.offBackgroundImage = UIImage.Asset.RoundedButton_WhiteWithGreyBorder.image
        
        c.offBorderColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        c.offBorderWidth = 1.0
        
        
        c.font = UIFont.boldWithSize(13.0)
        c.onBackgroundColor = UIColor.roseColor()
        c.offBackgroundColor = UIColor.whiteColor()
        c.onTextColor = UIColor.whiteColor()
        c.offTextColor = UIColor.roseColor()
        c.canBeTurnedOnAndOff = true
        c.hasOnOffButton = false
        c.labelVOffset = 0.5
        c.onCornerRadius = 5.0
        c.offCornerRadius = 5.0
        
        assert(c.isValid())
        return c
    }
    
    //MARK: Center aligned config
    internal func centerAlignedTagsViewConfig() -> SnapTagsViewConfiguration {
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
        
        return config
    }
    
    internal func centerAlignedTagsViewButtonConfig() -> SnapTagButtonConfiguration {
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
        
        //        c.onBackgroundImage = UIImage.Asset.RoundedButtonFilled.image
        c.offBackgroundImage = UIImage.Asset.RoundedButton_WhiteWithGreyBorder.image

        
        c.font = UIFont.boldWithSize(13.0)
        c.onBackgroundColor = UIColor.roseColor()
        c.offBackgroundColor = UIColor.whiteColor()
        c.onTextColor = UIColor.whiteColor()
        c.offTextColor = UIColor.roseColor()
        c.canBeTurnedOnAndOff = false
        c.hasOnOffButton = true
        c.isTappable = true
        c.labelVOffset = 0.5
        c.onCornerRadius = 5.0
        c.offCornerRadius = 5.0
        
        assert(c.isValid())
        return c
    }
    
    //MARK: Left aligned mixed on/off config
    internal func leftAlignedMixedOnOffTagsViewConfig() -> SnapTagsViewConfiguration {
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
        config.alignment = .Left
        //        config.alignment = .Natural
        
        return config
    }
    
    internal func leftAlignedMixedOnOffTagsViewButtonConfig() -> SnapTagButtonConfiguration {
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
        
        //c.onBackgroundImage = UIImage.Asset.RoundedButtonFilled.image
        c.offBackgroundImage = UIImage.Asset.RoundedButton_WhiteWithGreyBorder.image
        
        c.font = UIFont.boldWithSize(13.0)
        c.onBackgroundColor = UIColor.roseColor()
//        c.offBackgroundColor = UIColor.whiteColor()
        c.onTextColor = UIColor.whiteColor()
        c.offTextColor = UIColor.blackColor()
        c.canBeTurnedOnAndOff = true
        c.hasOnOffButton = true
        c.labelVOffset = 0.5
        c.onCornerRadius = 5.0
        c.offCornerRadius = 0.0
        
        assert(c.isValid())
        return c
    }
    
    //MARK: Search Bar config
    internal func searchBarViewConfig() -> SnapTagsViewConfiguration {
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
        config.horizontalMargin = 1.0 as CGFloat
        config.verticalMargin = 1.0 as CGFloat
        config.contentHeight = 13.0 as CGFloat
        config.alignment = .Left
        //        config.alignment = .Natural
        
        return config
    }
    
    internal func searchBarViewButtonConfig() -> SnapTagButtonConfiguration {
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
        
        //        c.onBackgroundImage = UIImage.Asset.RoundedButtonFilled.image
        c.offBackgroundImage = UIImage.Asset.RoundedButton_WhiteWithGreyBorder.image
        
        c.font = UIFont.boldWithSize(13.0)
        c.onBackgroundColor = UIColor.roseColor()
        c.offBackgroundColor = UIColor.whiteColor()
        c.onTextColor = UIColor.whiteColor()
        c.offTextColor = UIColor.roseColor()
        c.canBeTurnedOnAndOff = false
        c.hasOnOffButton = true
        c.labelVOffset = 0.5
        c.onCornerRadius = 3.0
        c.offCornerRadius = 3.0
        
        c.horizontalMargin = 6.0
        c.verticalMargin = 5.0
        
        assert(c.isValid())
        return c
    }
    
    //MARK: Tag bar config
    internal func tagBarViewConfig() -> SnapTagsViewConfiguration {
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
        config.alignment = .Left
        //        config.alignment = .Natural
        
        return config
    }
    
    internal func tagBarViewButtonConfig() -> SnapTagButtonConfiguration {
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
        
//        c.onOffButtonImage.onImage = UIImage.Asset.YellowCloseButton.image
//        c.onOffButtonImage.offTransform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI*45.0/180.0))
//        c.onOffButtonImage.offImage = UIImage.Asset.RedCloseButton.image
        
        c.offBackgroundImage = UIImage.Asset.RoundedButton_WhiteWithGreyBorder.image
        c.onBackgroundImage = UIImage.Asset.RoundedButton_WhiteWithGreyBorder.image

        c.font = UIFont.boldWithSize(13.0)
//        c.onBackgroundColor = UIColor.roseColor()
//        c.offBackgroundColor = UIColor.whiteColor()
        c.onTextColor = UIColor.roseColor()
        c.offTextColor = UIColor.roseColor()
        c.canBeTurnedOnAndOff = false
        c.hasOnOffButton = false
        c.labelVOffset = 0.5
        c.onCornerRadius = 0.0
        c.offCornerRadius = 0.0
        
        assert(c.isValid())
        return c
    }
    


}

extension ViewController : UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return false
    }
}