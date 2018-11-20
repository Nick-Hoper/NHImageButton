//
//  NHImageButton.swift
//  NHImageButton
//
//  Created by Nick luo on 2018/11/20.
//  Copyright © 2018 Nick luo. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

//图片位置
public enum NHImageButtonMode:NSInteger {
    case imageRight
    case imageLeft
    case imageTop
    case imageBottom
}

class NHImageButton: UIButton {
    
    //titleLabel的内容自适应尺寸
    private var titleFitSize:CGSize = CGSize.zero
    //image的内容自适应尺寸
    private var imageFitSize:CGSize = CGSize.zero
    //使用freeMode情况下的title宽度
    private var titleWidth:CGFloat?
    //使用freeMode情况下的title高度
    private var titleHeight:CGFloat?
    //使用freeMode情况下的image宽度
    private var imageWidth:CGFloat?
    //使用freeMode情况下的image高度
    private var imageHeight:CGFloat?
    
    // 记录不同controlState状态下的contentMode对应的字典
    private var modeDicForState = [String : NHImageButtonMode]()
    private var marginDicForState = [String : CGFloat]()
    
    // 返回当前controlState状态下对应的contentMode属性
    private var buttonContentMode:NHImageButtonMode?  {
        get{
            var finalState:UIControl.State = state
            
            // 默认点击高亮的时候的显示效果和高亮之后要切换的状态一致
            if isHighlighted, Int(state.rawValue) % 2 != 0 {
                finalState = UIControl.State.init(rawValue:UInt(state.rawValue) - 1)
            }
            
            guard let mode = modeDicForState[String.init(describing: finalState)]  else{
                return nil
            }
            return mode
        }
    }
    
    private var contentMargin:CGFloat  {
        get{
            // 默认点击高亮的时候的显示效果和高亮之后要切换的状态一致,否则点击切换状态的时候会有一个中间状态
            var finalState:UIControl.State = state
            if isHighlighted, Int(state.rawValue) % 2 != 0 {
                finalState = UIControl.State.init(rawValue:UInt(state.rawValue) - 1)
            }
            
            guard let margin = marginDicForState[String.init(describing: finalState)]  else{
                return 0
            }
            return margin
        }
    }

    //为不同状态设置不同的freeMode
    public func setContentMode(_ mode: NHImageButtonMode?, for state: UIControl.State) {
        modeDicForState[String.init(describing: state)] = mode
    }
    
    public func setContentMargin(_ margin: CGFloat, for state: UIControl.State) {
        marginDicForState[String.init(describing: state)] = margin
    }
    
    public func set(image: UIImage,title:String,titleColr:UIColor,contentMargin marigin: CGFloat,_ mode: NHImageButtonMode?,for state: UIControl.State) {
        self.setContentMode(mode, for: state)
        self.setContentMargin(marigin, for: state)
        self.setImage(image, for: state)
        self.setTitle(title, for: state)
        self.setTitleColor(titleColr, for: state)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        
        guard self.shouldLayoutFreeModeWithContentRect(contentRect) else {
            return super.titleRect(forContentRect: contentRect)
        }
        
        var titleTargetRect:CGRect = CGRect.zero
        
        switch self.buttonContentMode! {
        case .imageRight:
            titleTargetRect = CGRect.init(x: (contentRect.width - titleWidth! - imageWidth! - contentMargin)/2, y: (contentRect.height - titleHeight!)/2, width: titleWidth!, height: titleHeight!)
        case .imageLeft:
            titleTargetRect = CGRect.init(x: (contentRect.width - titleWidth! - imageWidth! - contentMargin)/2 + imageWidth! + contentMargin, y: (contentRect.height - titleHeight!)/2, width: titleWidth!, height: titleHeight!)
        case .imageTop:
            titleTargetRect = CGRect.init(x: (contentRect.width - titleWidth!)/2, y: (contentRect.height - titleHeight! - imageHeight! - contentMargin)/2 + imageHeight! + contentMargin, width: titleWidth!, height: titleHeight!)
        case .imageBottom:
            titleTargetRect = CGRect.init(x: (contentRect.width - titleWidth!)/2, y: (contentRect.height - titleHeight! - imageHeight! - contentMargin)/2, width: titleWidth!, height: titleHeight!)
        }
        return titleTargetRect
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        
        guard self.shouldLayoutFreeModeWithContentRect(contentRect) else {
            return super.imageRect(forContentRect: contentRect)
        }
        
        var imageTargetRect:CGRect = CGRect.zero
        
        switch self.buttonContentMode! {
        case .imageRight:
            imageTargetRect = CGRect.init(x: (contentRect.width - titleWidth! - imageWidth! - contentMargin)/2 + titleWidth! + contentMargin, y: (contentRect.height - imageHeight!)/2, width: imageWidth!, height: imageHeight!)
        case .imageLeft:
            imageTargetRect = CGRect.init(x: (contentRect.width - titleWidth! - imageWidth! - contentMargin)/2, y: (contentRect.height - imageHeight!)/2, width: imageWidth!, height: imageHeight!)
        case .imageTop:
            imageTargetRect = CGRect.init(x: (contentRect.width - imageWidth!)/2, y: (contentRect.height - titleHeight! - imageHeight! - contentMargin)/2, width: imageWidth!, height: imageHeight!)
        case .imageBottom:
            imageTargetRect = CGRect.init(x: (contentRect.width - imageWidth!)/2, y: (contentRect.height - titleHeight! - imageHeight! - contentMargin)/2 + titleHeight! + contentMargin, width: imageWidth!, height: imageHeight!)
        }
        
        return imageTargetRect
    }
    
    //判断是否应该使用freeMode
    func shouldLayoutFreeModeWithContentRect(_ contentRect:CGRect) -> Bool {
        
        //设置了freeMode，并且titleLabel和imageView都存在之后，才能够设置freeMode效果
        guard let _ = self.buttonContentMode,
            self.subviews.count > 1 else {
                return false
        }
        
        //考虑到button存在不同的状态，例如normal/selected。要检测到 目前状态的image和title都有，才进行设置
        guard let image = currentImage,let _ = currentTitle,let _ = titleLabel,let _ = imageView else {
            titleFitSize = CGSize.zero
            imageFitSize = CGSize.zero
            return false
        }
        //此时，可以获取title和imageView的原始fit尺寸了
        titleFitSize = (titleLabel?.sizeThatFits(contentRect.size))!
        imageFitSize = image.size
        self.caculateFreeModeLayoutSize(with: contentRect)
        return true
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        
    }
    
    func caculateFreeModeLayoutSize(with contentRect:CGRect) {
        
        switch buttonContentMode! {
        case .imageRight,.imageLeft:
            //在title过长，或者button过窄/矮的时候，压缩title，尽量保持image的尺寸
            titleWidth =  max(min(contentRect.width - imageFitSize.width - contentMargin, titleFitSize.width), 0)
            titleHeight = min(titleFitSize.height, contentRect.height)
            //如果title没有被压缩的看不到，并且image尺寸存在,
            imageHeight = min(contentRect.height, imageFitSize.height)
            imageWidth = imageFitSize.width
            
        case .imageTop,.imageBottom:
            titleHeight =  max(min(contentRect.height - imageFitSize.height - contentMargin, titleFitSize.height), 0)
            titleWidth = min(contentRect.width, titleFitSize.width)
            imageHeight = min(contentRect.height, imageFitSize.height)
            imageWidth =  min(contentRect.width, imageFitSize.width)
        }
    }
    
}

