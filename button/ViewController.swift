//
//  ViewController.swift
//  button
//
//  Created by rd on 2017/4/14.
//  Copyright © 2017年 rd. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var NumPad: ButtonMask!

    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    

    
    @IBAction func buttonAction(_ sender: UIButton) {
   
        sender.isSelected = !sender.isSelected

    }
    
    
}




    

