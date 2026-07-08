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
            let viewModel: WeatherDetailsViewModel = WeatherDetailsViewModel(weatherStore: WeatherStore())
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
                         padding: .init(top: 0, left: 16, bottom: 100, right: 16),
                         size: .init(width: 0, height: 0))
        
        textLabel.anchor(top: imageBody.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor,
                         padding: .init(top: 8, left: 16, bottom: 0, right: 16))
    }
}


/*

 final class PokerAvailableTicketLabel: UILabel {

 override var intrinsicContentSize: CGSize {
 let size = super.intrinsicContentSize
 return CGSize(
 width: size.width + inset.left + inset.right,
 height: size.height + inset.top + inset.bottom
 )
 }

 // MARK: Props

 private var inset: UIEdgeInsets = .zero

 // MARK: Initializers

 convenience init(inset: UIEdgeInsets) {
 self.init(frame: .zero)
 self.inset = inset
 }

 override init(frame: CGRect) {
 super.init(frame: frame)
 setup()
 }

 required init?(coder: NSCoder) {
 super.init(coder: coder)
 setup()
 }

 // MARK: Setup with custom properties

 override func drawText(in rect: CGRect) {
 super.drawText(in: rect.inset(by: inset))
 }

 private func setup() {

 layer.backgroundColor = UIColor.red.cgColor
 layer.cornerRadius = 6
 layer.borderColor = UIColor.black.cgColor
 layer.borderWidth = 1

 textColor = UIColor.white
 font = .italicSystemFont(ofSize: 8)
 textAlignment = .center

 }
 }

 class HomeViewController: UITabBarController {

 lazy var cLabel: UILabel = {
 let label: PokerAvailableTicketLabel = .init(inset: .init(top: 0, left: 4, bottom: 0, right: 4))
 label.translatesAutoresizingMaskIntoConstraints = false
 label.text = "XX3"
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

 let vc1 = UIViewController()
 vc1.title = "vc1"
 vc1.tabBarItem = .init(title: "vc1", image: .init(systemName: "eraser"), selectedImage: nil)

 let vc2 = UIViewController()
 vc2.title = "vc2"
 vc2.tabBarItem = .init(title: "vc2", image: .init(systemName: "eraser"), selectedImage: nil)

 let vc3 = UIViewController()
 vc3.title = "vc3"
 vc3.tabBarItem = .init(title: "vc3", image: .init(systemName: "eraser"), selectedImage: nil)

 let vc4 = UIViewController()
 vc4.title = "vc4"
 vc4.tabBarItem = .init(title: "vc4", image: .init(systemName: "eraser"), selectedImage: nil)

 let vc5 = UIViewController()
 vc5.title = "vc5"
 vc5.tabBarItem = .init(title: "vc5", image: .init(systemName: "eraser"), selectedImage: nil)

 let vc6 = UIViewController()
 vc6.title = "vc6"
 vc6.tabBarItem = .init(title: "vc6", image: .init(systemName: "eraser"), selectedImage: nil)

 self.viewControllers = [
 vc1,
 vc2,
 vc3,
 vc4,
 vc5,
 //        vc6,
 ]

 //        self.addChild(vc6)

 initBasketView()

 view.addSubview(cLabel)

 NSLayoutConstraint.activate([
 cLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
 cLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
 cLabel.heightAnchor.constraint(equalToConstant: 13),
 cLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 21),
 cLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 31),
 ])

 }

 override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
 super.viewWillTransition(to: size, with: coordinator)
 print("bro")
 //        self.viewControllers?.append(UIViewController())
 }

 private func initBasketView() {
 let basketViewController = UIViewController()
 basketViewController.view.frame = CGRect(
 origin: CGPoint(
 x: view.bounds.size.width - 50,
 y: tabBar.frame.origin.y - 50

 ),
 size: CGSize(width: 50, height: 50)
 )

 addBasketViewControllerAsChildViewController(vc: basketViewController, to: self)
 basketViewController.view.frame = frameFromParentViewController
 basketViewController.view.backgroundColor = .red
 }

 private func addBasketViewControllerAsChildViewController(vc: UIViewController, to viewController: UIViewController) {

 //        viewController.addChild(vc)
 viewController.view.addSubview(vc.view)
 viewController.didMove(toParent: viewController)
 }

 private var frameFromParentViewController: CGRect {
 return CGRect(
 x: view.frame.maxX
 - 50
 - 50,
 y: view.frame.size.height
 - tabBar.frame.size.height
 - 50
 - 50,
 width: 50,
 height: 50
 )
 }
 }


 */
