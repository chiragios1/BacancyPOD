//
//  Helper.swift
//  DOTX
//
//  Created by Shraddha on 31/03/23.
//

import Foundation
import UIKit

public class Helper {
     
  public  class func hexStringToUIColor(hex:String) -> UIColor
    {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#"))
        {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6)
        {
            return .white
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
   
 
 
   
}
public class AutosizeTableView: UITableView {
    var setPaddingDiff : Double = 0.0
    public override var contentSize: CGSize {
        didSet {
          self.invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
      }

    public override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height - setPaddingDiff)
      }
    public override func reloadData() {
         super.reloadData()
         invalidateIntrinsicContentSize()
       }

    

}
public class AutosizeCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
            super.init(frame: frame, collectionViewLayout: layout)
            commonInit()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }

        private func commonInit() {
            isScrollEnabled = true
        }

    public override var contentSize: CGSize {
            didSet {
                invalidateIntrinsicContentSize()
            }
        }

    public override func reloadData() {
            super.reloadData()
            self.invalidateIntrinsicContentSize()
        }

    public override var intrinsicContentSize: CGSize {
            return contentSize
        }

    

}

public class OverlapLayout: UICollectionViewFlowLayout {
    
    var overlap: CGFloat = 20
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let arr = super.layoutAttributesForElements(in: rect)!
        return arr.map { atts in
            var atts = atts
            if atts.representedElementCategory == .cell {
                let ip = atts.indexPath
                atts = self.layoutAttributesForItem(at: ip)!
            }
            return atts
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let atts = super.layoutAttributesForItem(at: indexPath)!
        var xPosition = atts.center.x
        if indexPath.item == 0 {
            return atts
        }else{
            xPosition -= self.overlap * CGFloat(atts.indexPath.row)
            atts.center = CGPoint(x: xPosition, y: atts.center.y)
            return atts
        }
        
    }
     
    
}


class CustomizableSegmentControl: UISegmentedControl {
    
    private(set) lazy var radius:CGFloat = bounds.height / 2
    
    /// Configure selected segment inset, can't be zero or size will error when click segment
    private var segmentInset: CGFloat = 0.1{
        didSet{
            if segmentInset == 0{
                segmentInset = 0.1
            }
        }
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        
        //MARK: - Configure Background Radius
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true
        let normalTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : Helper.hexStringToUIColor(hex: "6A737D"),
            NSAttributedString.Key.font : UIFont(name: "RobotoCondensed-Regular", size: 17) as Any
                   ]

        let selectedTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "RobotoCondensed-Regular", size: 17) as Any
                   ]

        self.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.setTitleTextAttributes(normalTextAttributes, for: .highlighted)
        self.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        //MARK: - Find selectedImageView
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView
        {
            //MARK: - Configure selectedImageView Color
            selectedImageView.backgroundColor = .white
            selectedImageView.image = nil

            //MARK: - Configure selectedImageView Inset with SegmentControl
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)

            //MARK: - Configure selectedImageView cornerRadius
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = 22

            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")

        }
       
    }
   

    
    

}
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder!.next
        }
        return nil
    }
}
