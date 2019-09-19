//
//  ViewController.swift
//  EZButton
//
//  Created by Jemesl on 2019/9/16.
//  Copyright © 2019 Jemesl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        addBtn()
        test()
    }
    
    func addBtn() {
        let btn = EZButton()
        view.addSubview(btn)
        btn.backgroundColor = .lightGray
        btn.distribution = .leftIconRightTitle
        
        btn.alignemnt = .center
        
        btn.offset = 3
        btn.edge = UIEdgeInsetsMake(10, 10, 10, 10)
        btn.text = "123333"
        btn.image = UIImage(named: "tag_icon_orange")
        btn.imageSize = CGSize(width: 30, height: 30)
        btn.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 80))
        }
    }
    
    func test() {
        let out = UIView()
        let medium = UIView()
        let inner = UIView()
        
        out.backgroundColor = .gray
        medium.backgroundColor = .green
        inner.backgroundColor = .blue
        
        view.addSubview(out)
        out.addSubview(medium)
        out.addSubview(inner)
        
        inner.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
//            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.bottom.lessThanOrEqualTo(-20).priority(.medium)
            make.left.equalTo(20)
//            make.right.lessThanOrEqualTo(-20).priority(.medium)
        }
        
        medium.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 60))
            make.top.equalTo(20)
            make.bottom.lessThanOrEqualTo(-20)
            make.left.equalTo(inner.snp.right).offset(10)
            make.right.lessThanOrEqualTo(-20)
            
        }
        
        out.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 150))
        }
    }
    
    


}

