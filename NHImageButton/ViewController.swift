//
//  ViewController.swift
//  NHImageButton
//
//  Created by Nick luo on 2018/11/20.
//  Copyright © 2018 Nick luo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //初始化按钮
    @IBOutlet weak var testButton: NHImageButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        //设置标题
        testButton.setTitle("v间距10v", for: UIControl.State.normal)
        testButton.setTitle("<-间距20", for: UIControl.State.selected)
        //间距
        testButton.setContentMargin(10, for: UIControl.State.normal)
        testButton.setContentMargin(20, for: UIControl.State.selected)
        //设置图片显示方向
        testButton.setContentMode(NHImageButtonMode.imageBottom, for: UIControl.State.normal)
        testButton.setContentMode(NHImageButtonMode.imageLeft, for: UIControl.State.selected)
        testButton.addTarget(self, action: #selector(buttonIsTapped(sender:)), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func buttonIsTapped(sender:UIButton) {
        sender.isSelected = !sender.isSelected
    }


}

