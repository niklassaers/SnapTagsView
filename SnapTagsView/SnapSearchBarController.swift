import UIKit

public class SnapSearchBarController : UIViewController {

    public lazy var sizer = SnapTextWidthSizers()
    public var configuration : SnapTagsViewConfiguration!
    public var buttonConfiguration : SnapTagButtonConfiguration!
    public var height : CGFloat = 36.0

    public var searchBar : UISearchBar {
        get {
            return self.view as! UISearchBar
        }
    }

    public var data : [SnapTagRepresentation] {
        get {
            return tagsVc.data
        }
        set(value) {
            tagsVc.data = value
        }
    }

    public var delegate : SnapTagsButtonDelegate? {
        get {
            return tagsVc.delegate
        }
        set(value) {
            tagsVc.delegate = value
        }
    }

    internal let tagsVc = SnapTagsCollectionViewController()

    public override func viewDidLoad() {
        super.viewDidLoad()
        assert(configuration != nil)
        assert(buttonConfiguration != nil)

        tagsVc.configuration = configuration
        tagsVc.buttonConfiguration = buttonConfiguration

        searchBar.delegate = self
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()

        var searchTextField_ : UITextField? = nil
        for firstLevelSubview in searchBar.subviews {
            for subview in firstLevelSubview.subviews ?? [UIView]() {
                if let subview = subview as? UITextField {
                    searchTextField_ = subview
                    break
                }
            }
        }

        guard let searchTextField = searchTextField_ else {
            print("Could not find textfield in searchbar")
            return
        }

        searchTextField.leftViewMode = .Never
        searchTextField.rightViewMode = .Never


        let tagScrollView = SnapTagsHorizontalScrollView.setupTagScrollViewAsSubviewOf(searchTextField)

        self.addChildViewController(tagsVc)
        tagScrollView.addSubview(tagsVc.view)

        var constraints = [NSLayoutConstraint]()
        let dict = ["self": tagsVc.view, "super": tagScrollView]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.right = super.right", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.bottom = super.bottom", parameters: dict))
        tagScrollView.addConstraints(constraints)

        tagsVc.scrollEnabled = false
        tagsVc.view.translatesAutoresizingMaskIntoConstraints = true

        var frame = tagsVc.view.frame
        frame.size.width = tagsVc.calculateContentSizeForTags(data).width
        frame.size.height = tagScrollView.frame.height
        tagsVc.view.frame = frame

        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()

        var textFieldFrame = searchTextField.frame
        textFieldFrame.size.height = 34
        searchTextField.frame = textFieldFrame

        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()

        tagsVc.scrollEnabled = true
    }

    override public func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.searchBar.layoutIfNeeded()
        self.searchBar.layoutSubviews()

        let newHeight: CGFloat = self.height
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
                }
            }
        }
    }
}

extension SnapSearchBarController : UISearchBarDelegate {
    public func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return false
    }
}
