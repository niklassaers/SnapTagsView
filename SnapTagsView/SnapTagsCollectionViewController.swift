import UIKit
import KTCenterFlowLayout
import UICollectionViewLeftAlignedLayout
import UICollectionViewRightAlignedLayout

private let reuseIdentifier = "SnapTagCell"

open class SnapTagsCollectionViewController: UIViewController {

    open var data = [SnapTagRepresentation]()
    open var configuration : SnapTagsViewConfiguration!
    open var buttonConfiguration : SnapTagButtonConfiguration!
    open weak var delegate : SnapTagsButtonDelegate?

    internal var collectionView : UICollectionView?
    internal var handlesViewConfigurationMargins = true

    open lazy var sizer = SnapTextWidthSizers()

    override open func viewDidLoad() {
        super.viewDidLoad()

        assert(configuration != nil)
        assert(buttonConfiguration != nil)

        setupLayout()

        collectionView?.delegate = self
        collectionView?.dataSource = self

        setupConstraints()
        self.view.backgroundColor = UIColor.clear
        collectionView?.isUserInteractionEnabled = true

        // Register cell classes
        collectionView?.register(UINib(nibName: "SnapTagCell", bundle: Bundle(for: SnapTagCell.self)), forCellWithReuseIdentifier: reuseIdentifier)
    }

    internal func setupLayout() {
        var layout : UICollectionViewFlowLayout
        if configuration.alignment == .center {
            layout = KTCenterFlowLayout()
        } else if configuration.alignment == .right {
            layout = UICollectionViewRightAlignedLayout()
        } else if configuration.alignment == .left {
            layout =  UICollectionViewLeftAlignedLayout()
        } else {
            layout = LessBuggyCollectionViewFlowLayout()
        }

        layout.minimumLineSpacing = configuration.spacing
        layout.minimumInteritemSpacing = configuration.spacing
        layout.scrollDirection = configuration.scrollDirection
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        layout.sectionInset = configuration.padding
        layout.itemSize = buttonConfiguration.intrinsicContentSize

        // KTCenterFlowLayout crashes if estimatedItemSize != (0.0, 0.0) (see their README on GitHub)
        if configuration.alignment != .center {
            layout.estimatedItemSize = buttonConfiguration.intrinsicContentSize
        }


        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        if let collectionView = collectionView {
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.backgroundColor = UIColor.clear
            
            let backgroundView = UIView()
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.backgroundView = backgroundView
            backgroundView.backgroundColor = UIColor.clear
            let tapGr = UITapGestureRecognizer(target: self, action: #selector(SnapTagsCollectionViewController.tappedOutsideCell))
            backgroundView.addGestureRecognizer(tapGr)
            
            let viewDict = [ "collectionView": collectionView, "backgroundView": backgroundView ]
            let leading = NSLayoutConstraint(expressionFormat: "backgroundView.leading = collectionView.leading", parameters: viewDict)
            let trailing = NSLayoutConstraint(expressionFormat: "backgroundView.trailing = collectionView.trailing", parameters: viewDict)
            let top = NSLayoutConstraint(expressionFormat: "backgroundView.top = collectionView.top", parameters: viewDict)
            let bottom = NSLayoutConstraint(expressionFormat: "backgroundView.bottom = collectionView.bottom", parameters: viewDict)
            collectionView.addConstraints([leading!, trailing!, top!, bottom!])
            
            view.addSubview(collectionView)
        }
    }
    
    @objc fileprivate func tappedOutsideCell(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.tappedOutsideTagButtons?()
    }

    internal func setupConstraints() {
        guard let collectionView = collectionView else {
            return
        }
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        var configuration = self.configuration
        if !handlesViewConfigurationMargins {
            configuration?.horizontalMargin = 0.0
            configuration?.verticalMargin = 0.0
        }

        let metrics = [
            "hMargin": configuration?.horizontalMargin ?? 5.0,
            "vMargin": configuration?.verticalMargin ?? 5.0]
        let views = [ "cv": collectionView ]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hMargin)-[cv]-(hMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vMargin)-[cv]-(vMargin)-|",
            options: [],
            metrics: metrics,
            views: views)
        self.view.addConstraints(hConstraints)
        self.view.addConstraints(vConstraints)
    }

    open func allowBouncingHorizontally(_ horizontalBounce: Bool, vertically verticalBounce: Bool) {
        guard let collectionView = collectionView else {
            return
        }

        collectionView.bounces = horizontalBounce || verticalBounce
        collectionView.alwaysBounceHorizontal = horizontalBounce
        collectionView.alwaysBounceVertical = verticalBounce
    }

    open func calculateContentSizeForTags(_ tags: [SnapTagRepresentation]) -> CGSize {
        guard let collectionView = collectionView else {
            return CGSize.zero
        }

        var width = CGFloat(0.0)
        width += fmax(0.0 ,CGFloat(collectionView.numberOfItems(inSection: 0) - 1) * configuration.spacing)
        var height = CGFloat(0.0)
        let sizes = tags.map { sizer.calculateSizeForTag($0.tag, configuration: buttonConfiguration) }
        height += sizes.reduce(CGFloat(0.0), { (last, size) -> CGFloat in
            return fmax(last, size.height)
        })
        width += sizes.reduce(CGFloat(0.0), { (sum, size) -> CGFloat in
            return sum + size.width
        })
        return CGSize(width: width, height: height)
    }

    open func contentOffset() -> CGPoint {
        return collectionView?.contentOffset ?? CGPoint(x: 0,y: 0)
    }

    open func contentSize() -> CGSize {
        var size = collectionView?.contentSize ?? CGSize(width: 0, height: 0)
        size.width += 2 * configuration.horizontalMargin
        size.height += 2 * configuration.verticalMargin
        return size
    }

    open var scrollEnabled : Bool {
        get {
            return collectionView?.isScrollEnabled ?? false
        }

        set(value) {
            collectionView?.isScrollEnabled = value
        }
    }

    open func reloadData() {
        collectionView?.reloadData()
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tag : SnapTagRepresentation
        
        // Guard against reload situations where the indexpath and data are out of sync
        if (indexPath as NSIndexPath).item < data.count {
            tag = data[(indexPath as NSIndexPath).item]
        } else {
            tag = SnapTagRepresentation(tag: "OutOfBounds", isOn: false)
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SnapTagCell

        cell.sizer = sizer
        cell.setText(tag.tag)
        
        if var config = buttonConfiguration {
            config.isOn = tag.isOn
            cell.applyConfiguration(config)
        }

        return cell
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = data[(indexPath as NSIndexPath).item]
        let size = sizer.calculateSizeForTag(tag.tag, configuration: buttonConfiguration)

        return CGSize(width: round(size.width), height: round(size.height))
    }
}

extension SnapTagsCollectionViewController : UICollectionViewDelegate {

//    private func printIsMainThread() {
//        let t = NSThread.isMainThread()
//        if t {
//            print("Is main thread")
//        } else {
//            print("IS NOT MAIN THREAD!!!!!")
//        }
//    }

    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        printIsMainThread()
//        print("shouldHighlightItemAtIndexPath")
        return buttonConfiguration.canBeTurnedOnAndOff || buttonConfiguration.isTappable
    }

    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        printIsMainThread()
//        print("didHighlightItemAtIndexPath")
        let cell = collectionView.cellForItem(at: indexPath) as! SnapTagCell
        cell.setHighlightState(true)
    }

    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        printIsMainThread()
//        print("didUnhighlightItemAtIndexPath")
        let cell = collectionView.cellForItem(at: indexPath) as! SnapTagCell
        UIView.animate(withDuration: 0.3, animations: {
            cell.setHighlightState(false)
        }) 
        didSelect(collectionView, indexPath: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        printIsMainThread()
//        print("shouldSelectItemAtIndexPath")
        return buttonConfiguration.canBeTurnedOnAndOff || buttonConfiguration.isTappable
    }



//    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    fileprivate func didSelect(_ collectionView: UICollectionView, indexPath: IndexPath) {
//        printIsMainThread()
//        print("YES!!! didSelectItemAtIndexPath")
        let tag = data[(indexPath as NSIndexPath).row]
        if buttonConfiguration.canBeTurnedOnAndOff {
            tag.isOn = !tag.isOn
            data[(indexPath as NSIndexPath).row] = tag

            let cell = collectionView.cellForItem(at: indexPath) as! SnapTagCell
            UIView.animate(withDuration: 0.3, animations: {
                if tag.isOn {
                    cell.setOnState()
                } else {
                    cell.setOffState()
                }
            }) 
            
            delegate?.snapTagButtonTapped(tag, sender: self)
            if tag.isOn {
                delegate?.snapTagButtonTurnedOn?(tag.tag)
            } else {
                delegate?.snapTagButtonTurnedOff?(tag.tag)
            }
            
        } else if buttonConfiguration.isTappable {
            delegate?.snapTagButtonTapped(tag, sender: self)
        }
    }


    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {

//        printIsMainThread()
        return buttonConfiguration.canBeTurnedOnAndOff
    }

    public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

    }



}
