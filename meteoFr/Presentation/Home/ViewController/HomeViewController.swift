//
//  ViewController.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import UIKit
import Inject

class HomeViewController: UIViewController {
    
    var contentView: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var actionButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.cornerStyle = .medium
        configuration.title = "Show weather info"
        let button: UIButton = .init(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var imageBody: UIImageView = {
        var imageView: UIImageView = .init(image: .init(named: "im_home")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        var label: UILabel = .init()
        label.text = "Image generated using @DALL*E"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        view.backgroundColor = .white
        
        setUpViews()
        setUpConstraints()
        
        // setup action button
        actionButton.addAction(UIAction { _ in
            // perform redirect
            let viewModel: WeatherDetailsViewModel = WeatherDetailsViewModel()
            let weatherVC = WeatherDetailViewController.instantiate(viewModel: viewModel)
            self.navigationController?.pushViewController(weatherVC, animated: true)
        }, for: .touchUpInside)
    }
}

// MARK: ViewConstraintAutoLayoutSetup
extension HomeViewController: ViewConstraintAutoLayoutSetup {

    func setUpViews() {
        contentView.addSubview(imageBody)
        contentView.addSubview(textLabel)
        contentView.addSubview(actionButton)
        
        view.addSubview(contentView)
    }
    
    func setUpConstraints() {
        contentView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        actionButton.anchor(top: nil, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor,
                            padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        imageBody.anchor(top: nil, leading: contentView.leadingAnchor, bottom: actionButton.topAnchor, trailing: contentView.trailingAnchor,
                         padding: .init(top: 0, left: 16, bottom: 45, right: 16),
                         size: .init(width: 0, height: 0))
        
        textLabel.anchor(top: imageBody.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor,
                         padding: .init(top: 8, left: 16, bottom: 0, right: 16))
    }
}
