import UIKit
import NSLayoutConstraint_ExpressionFormat

public class SnapTagsHorizontalScrollView : UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    public static func createTagScrollView() -> UIScrollView {
        let tagScrollView = UIScrollView(frame: CGRectZero)
        setupTagScrollView(tagScrollView)
        return tagScrollView
    }

    public static func setupTagScrollView(tagScrollView: UIScrollView) {
        tagScrollView.showsHorizontalScrollIndicator = false
        tagScrollView.showsVerticalScrollIndicator = false
        tagScrollView.bounces = true
        tagScrollView.alwaysBounceVertical = false
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
    }

    public static func setupTagScrollViewAsSubviewOf(view: UIView) -> UIScrollView {
        let tagScrollView = SnapTagsHorizontalScrollView.createTagScrollView()
        setupTagScrollView(tagScrollView)
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
}
