//
//  ButtonMask.swift
//  ButtonMask
//
//  Created by rd on 2017/4/19.
//  Copyright © 2017年 ShaoAN. All rights reserved.
//

import  UIKit

class ButtonMask: UIView {
    
    @IBInspectable var coverImageColor: UIColor? = UIColor.clear
    
    @IBInspectable var customCornerRadius : CGFloat = 0.0
    
    @IBInspectable var customBorder : CGFloat = 0.0
    
    
    lazy var BackGroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "test_bg")
        imageView.contentMode = UIViewContentMode.scaleToFill
        
        return imageView
    }()
    
    lazy var coverView: UIImageView = {
        let coverImage = UIImageView()
        coverImage.backgroundColor = self.coverImageColor
        
        return coverImage
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //UIView的最底層顏色與最上層所選的顏色一致
        layer.backgroundColor = self.coverImageColor?.cgColor
        BackGroundImageView.frame = CGRect(x: 1, y: 1, width: frame.width - 1 , height: frame.height - 1 )
        coverView.frame = bounds
        addSubview(BackGroundImageView)
        addSubview(coverView)
        
        sendSubview(toBack: coverView)
        sendSubview(toBack: BackGroundImageView)
        
        //繼承UIbutton的SubClass套用按下透明的效果(
//        let buttonSubClass = subviews.filter({ $0 is DoubleLineButton }).map({$0 as! UIButton})
//        
//        for b in buttonSubClass {
//            b.layer.backgroundColor = UIColor.clear.cgColor
//            b.layer.masksToBounds = true
//            b.tintColor = .clear
//            
//            b.setBackgroundImage(UIImage.color(coverImageColor!), for: .normal)
//            b.setBackgroundImage(UIImage.color(.clear), for: .selected)
//            b.setBackgroundImage(UIImage.color(.clear), for: .highlighted)
//            
//            b.setTitleColor(.white, for: .normal)
//            b.setTitleColor(.white, for: .selected)
//            
//        }
        //沒繼承UIButton的按鈕也套用按下透明的效果
        let buttons = subviews.filter({ $0 is UIButton }).map({$0 as! UIButton})
        
        for b in buttons {
            b.layer.backgroundColor = UIColor.clear.cgColor
            b.layer.masksToBounds = true
            b.tintColor = .clear
            
            b.setBackgroundImage(UIImage.color(coverImageColor!), for: .normal)
            b.setBackgroundImage(UIImage.color(.clear), for: .selected)
            b.setBackgroundImage(UIImage.color(.clear), for: .highlighted)
            
            b.setTitleColor(.white, for: .normal)
            b.setTitleColor(.white, for: .selected)
        }
        
    }
    
    func parameter(rects: [CGRect] , cornerRadius: [CGFloat] ) {
        
        let path = UIBezierPath(roundedRect: coverView.bounds, cornerRadius: 0)
        
        //鑽的洞設定比button再大一點
        let recountRects = rects.map {CGRect(x: $0.origin.x - customBorder, y: $0.origin.y - customBorder, width: $0.size.width + customBorder * 2, height: $0.size.height + customBorder * 2)}
        
        for i in 0 ..< recountRects.count {
            
            let bezier = UIBezierPath(roundedRect: recountRects[i], cornerRadius: cornerRadius[i])
            path.append(bezier)
        }
        
        path.usesEvenOddFillRule = true
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillRule = kCAFillRuleEvenOdd
        //        layer.fillColor = UIColor.white.cgColor
        coverView.layer.mask = layer
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        //取得按鈕位置與大小
        let rects = subviews
            .filter { $0 is UIButton }
            .map    { $0.frame }
        
        //取得按鈕圓角
        let cornerRadius = subviews
            .filter { $0 is UIButton }
            .map    { $0.layer.cornerRadius + customCornerRadius}
        
        //帶入parameter()挖洞
        parameter(rects: rects , cornerRadius: cornerRadius)
        
        //直接改UIView上的所有按鈕圓角數值
        subviews
            .filter  { $0 is UIButton }
            .forEach { $0.layer.cornerRadius = customCornerRadius }
        
        
        //直接改UIView上有繼承DoubleLineButton的所有按鈕圓角數值
        //        subviews
        //            .filter  ({ $0 is DoubleLineButton })
        //            .forEach { $0.layer.cornerRadius = customCornerRadius }
        
        
        
    }
    
}

extension UIImage {
    static func color(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
