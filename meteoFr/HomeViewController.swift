//
//  ViewController.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import UIKit

class HomeViewController: UIViewController {
    var contentView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .darkGray
        
    }
}

