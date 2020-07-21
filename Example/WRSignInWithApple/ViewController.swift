//
//  ViewController.swift
//  WRSignInWithApple
//
//  Created by GodFighter on 07/15/2020.
//  Copyright (c) 2020 GodFighter. All rights reserved.
//

import UIKit
import WRSignInWithApple

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton.init(type: .system)
        view.addSubview(button)
        
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(action_signIn), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func action_signIn() {
        WRSignInWithApple.SignIn()
    }

}

