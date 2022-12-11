//
//  WeatherDetailsViewController.swift
//  meteoFr
//
//  Created by Elyes Derouich on 11/12/2022.
//

import Foundation
import UIKit
import Combine

class WeatherDetailViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    lazy var stateContainerView: UIView = {
        let view: UIView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView: UIProgressView = .init(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.0
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 10
        progressView.subviews[1].clipsToBounds = true
        return progressView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init(style: UIActivityIndicatorView.Style.large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    lazy var actionButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.cornerStyle = .medium
        configuration.title = "Refresh"
        let button: UIButton = .init(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var viewModel: WeatherDetailsViewModel!
    
    private var cancellables = Set<AnyCancellable>()
    
    internal static func instantiate(viewModel: WeatherDetailsViewModel) -> WeatherDetailViewController {
        let viewController = WeatherDetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // setting up view
        setUpViews()
        setUpConstraints()
        
        // setup reactive
        setupListeners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.startFetchJob()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.reset()
    }
    
    func setupListeners() {
        viewModel.$currentStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.setupMode(status: status)
            }
            .store(in: &cancellables)
        
        viewModel.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.progressBar.setProgress(progress, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func setupMode(status: ViewStatus) {
        switch status {
        case .loading:
            setupLoadingMode()
        case .idle:
            // dont do anythign
            setupIdleMode()
        case .error(let message):
            // show error
            
            setupIdleMode()
        case .loaded:
            // clean UI
            setupLoadingMode()
        }
    }
    
    private func setupIdleMode() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        stateContainerView.addSubview(actionButton)
        
        actionButton.anchor(top: nil, leading: stateContainerView.leadingAnchor, bottom: nil, trailing: stateContainerView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: stateContainerView.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: stateContainerView.centerYAnchor)
        ])
    }
    
    private func setupLoadingMode() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        actionButton.removeFromSuperview()
        stateContainerView.addSubview(progressBar)
        
        progressBar.anchor(top: nil, leading: stateContainerView.leadingAnchor, bottom: stateContainerView.bottomAnchor, trailing: stateContainerView.trailingAnchor,
                           padding: .init(top: 0, left: 16, bottom: 16, right: 16),
                           size: .init(width: 0, height: 20))
        
        progressBar.setProgress(0.5, animated: true)
        activityIndicator.startAnimating()
    }
}

extension WeatherDetailViewController: ViewConstraintAutoLayoutSetup {
    func setUpViews() {
        view.addSubview(tableView)
        view.addSubview(stateContainerView)
    }
    
    func setUpConstraints() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: stateContainerView.topAnchor, trailing: view.trailingAnchor)
        
        stateContainerView.anchor(top: tableView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 100))
        
        tableView.debugView()
        
        stateContainerView.debugView()
        
    }
}
