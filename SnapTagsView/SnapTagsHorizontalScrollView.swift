import UIKit
import NSLayoutConstraint_ExpressionFormat

open class SnapTagsHorizontalScrollView : UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    open static func createTagScrollView() -> UIScrollView {
        let tagScrollView = UIScrollView(frame: CGRect.zero)
        setupTagScrollView(tagScrollView)
        return tagScrollView
    }

    open static func setupTagScrollView(_ tagScrollView: UIScrollView) {
        tagScrollView.showsHorizontalScrollIndicator = false
        tagScrollView.showsVerticalScrollIndicator = false
        tagScrollView.bounces = true
        tagScrollView.alwaysBounceVertical = false
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
    }

    open static func setupTagScrollViewAsSubviewOf(_ view: UIView, horizontalMargin: CGFloat = 3, verticalMargin: CGFloat = 4) -> UIScrollView {
        let tagScrollView = SnapTagsHorizontalScrollView.createTagScrollView()
        setupTagScrollView(tagScrollView)
        view.addSubview(tagScrollView)

        var constraints = [NSLayoutConstraint]()
        let dict : [String:UIView] = ["self": tagScrollView, "super": view]
        constraints.append(NSLayoutConstraint(expressionFormat: "self.left = super.left + \(horizontalMargin)", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.right = super.right - \(horizontalMargin)", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.top = super.top + \(verticalMargin)", parameters: dict))
        constraints.append(NSLayoutConstraint(expressionFormat: "self.bottom = super.bottom - \(verticalMargin)", parameters: dict))
        view.addConstraints(constraints)
        return tagScrollView
    }
}
