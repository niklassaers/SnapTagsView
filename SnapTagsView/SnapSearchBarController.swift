import UIKit

public class SnapSearchBarController : UIViewController {

    public lazy var sizer = SnapTextWidthSizers()
    public var configuration : SnapTagsViewConfiguration!
    public var buttonConfiguration : SnapTagButtonConfiguration!
    public var height : CGFloat = 36.0
    private var tagScrollView : UIScrollView?
    private var searchTextField : UITextField?
    internal let tagsVc = SnapTagsCollectionViewController()
    private var searchBarInteractionEnabled = false

    public var placeholderText : String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    private var placeholderTextRepresentation : String {
        get {
            if data.count == 0 {
                if let placeholderText = placeholderText {
                    return placeholderText
                } else {
                    return "Hva leter du etter?"
                }
            } else {
                return ""
            }
        }
    }

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
            updatePlaceholder()
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


    public override func viewDidLoad() {
        super.viewDidLoad()
        assert(configuration != nil)
        assert(buttonConfiguration != nil)

        configuration.alignment = .Natural
        tagsVc.configuration = configuration
        tagsVc.buttonConfiguration = buttonConfiguration
        tagsVc.handlesViewConfigurationMargins = false

        searchBar.delegate = self
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()
        searchBarInteractionEnabled = false

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
        searchTextField.textAlignment = .Natural
        searchTextField.textColor = UIColor.blackColor()
        searchTextField.tintColor = UIColor.roseColor()
        self.searchTextField = searchTextField

        let hMargin = configuration.horizontalMargin
        let vMargin = configuration.verticalMargin
        
        tagScrollView = SnapTagsHorizontalScrollView.setupTagScrollViewAsSubviewOf(searchBar, horizontalMargin: hMargin, verticalMargin: vMargin)

        self.addChildViewController(tagsVc)
        tagScrollView?.addSubview(tagsVc.view)

        var constraints = [NSLayoutConstraint]()
        let dict = ["self": tagsVc.view, "super": tagScrollView]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.right = super.right", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.bottom = super.bottom", parameters: dict))
        tagScrollView?.addConstraints(constraints)

        tagsVc.scrollEnabled = false
        tagsVc.view.translatesAutoresizingMaskIntoConstraints = true

        var frame = tagsVc.view.frame
        frame.size.width = tagsVc.calculateContentSizeForTags(data).width
        frame.size.height = tagScrollView?.frame.height ?? 0.0
        tagsVc.view.frame = frame

        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()

        var textFieldFrame = searchTextField.frame
        textFieldFrame.size.height = 34
        searchTextField.frame = textFieldFrame

        updatePlaceholder()
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()

        tagsVc.scrollEnabled = true
    }
    
    public func setFont(font: UIFont) {
        searchTextField?.font = font
    }

    override public func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        //self.searchBar.layoutIfNeeded()
        //self.searchBar.layoutSubviews()

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
    
    public func beginEditingWithSearch(text: String) {
        tagScrollView?.hidden = true
        searchBarInteractionEnabled = true
        
        searchBar.text = text
        searchTextField?.becomeFirstResponder()
    }
    
    public func updateSearchString(text: String) {
        searchBar.text = text
    }
    
    public func updatePlaceholder() {
        searchBar.placeholder = placeholderTextRepresentation
    }
    
    public func endEditing(cancelled: Bool) -> String {
        tagScrollView?.hidden = false
        searchBarInteractionEnabled = false
        
        searchBar.resignFirstResponder()
        searchTextField?.resignFirstResponder()
        let newText = searchBar.text ?? ""
        searchBar.text = ""
        
        if cancelled {
            let oldText = data.map { $0.tag }.joinWithSeparator(" ")
            updatePlaceholder()
            delegate?.searchCompletedWithString?(oldText)
            return oldText
        }
        
        else {
            let newData = newText.componentsSeparatedByString(" ").map { SnapTagRepresentation(tag: $0) }
            self.data = newData
            reloadData()

            updatePlaceholder()
            delegate?.searchCompletedWithString?(newText)
            return newText
        }
    }
    
    public func reloadData() {
        tagsVc.reloadData()
        delay(0.2) {
            if let sv = self.tagScrollView?.subviews.first?.subviews.first as? UIScrollView {
                let x = fmax(0.0, (sv.contentSize.width - sv.bounds.size.width))
                sv.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            }
        }
    }
}

extension SnapSearchBarController : UISearchBarDelegate {
    public func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return searchBarInteractionEnabled
    }
    
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //searchBar.text = searchBar.text?.uppercaseString
        delegate?.searchTextChanged?(searchBar.text ?? "")
    }
    
    public func searchBarResultsListButtonClicked(searchBar: UISearchBar) {
        
    }
    
    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        endEditing(false)
    }
    
    public func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        endEditing(true)
    }
}
