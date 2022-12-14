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
        progressView.trackTintColor = .darkGray
        progressView.layer.sublayers![1].cornerRadius = 10
        progressView.subviews[1].clipsToBounds = true
        return progressView
    }()
    
    lazy var progressLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var progressIndicatorLabel: UILabel = {
        let label: UILabel = .init(frame: .zero)
        label.textColor = .white
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        configuration.title = "Recommencer"
        let button: UIButton = .init(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { _ in
            self.viewModel.startFetchJob()
        }, for: .touchUpInside)
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
                self?.progressIndicatorLabel.text = "\(Int(progress * 100))%"
            }
            .store(in: &cancellables)
        
        viewModel.$loadingMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.progressLabel.text = message
            }
            .store(in: &cancellables)
        
        viewModel.$dataSource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupMode(status: ViewStatus) {
        switch status {
        case .loading:
            setupLoadingMode()
        case .idle:
            setupIdleMode()
        case .error(let message):
            // show error
            let alert = UIAlertController(title: "Error", message: "Error \(message)", preferredStyle: .alert)
            self.present(alert, animated: true)
            setupIdleMode()
        }
    }
    
    private func setupIdleMode() {
        tableView.isHidden = false
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        stateContainerView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        stateContainerView.addSubview(actionButton)
        
        actionButton.anchor(top: nil, leading: stateContainerView.leadingAnchor, bottom: nil, trailing: stateContainerView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        NSLayoutConstraint.activate([
            actionButton.centerXAnchor.constraint(equalTo: stateContainerView.centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: stateContainerView.centerYAnchor)
        ])
    }
    
    private func setupLoadingMode() {
        view.addSubview(activityIndicator)
        tableView.isHidden = true
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        stateContainerView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        progressBar.addSubview(progressIndicatorLabel)
        stateContainerView.addSubview(progressBar)
        
        progressIndicatorLabel.anchor(top: progressBar.topAnchor, leading: nil, bottom: progressBar.bottomAnchor, trailing: progressBar.trailingAnchor, padding: .init(top: 2, left: 0, bottom: 2, right: 2))
        progressBar.anchor(top: nil, leading: stateContainerView.leadingAnchor, bottom: stateContainerView.bottomAnchor, trailing: stateContainerView.trailingAnchor,
                           padding: .init(top: 0, left: 16, bottom: 16, right: 16),
                           size: .init(width: 0, height: 20))
        
        activityIndicator.startAnimating()
        
        stateContainerView.addSubview(progressLabel)
        progressLabel.anchor(top: stateContainerView.topAnchor, leading: stateContainerView.leadingAnchor, bottom: progressBar.topAnchor, trailing: stateContainerView.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 8, right: 8))
    }
}

extension WeatherDetailViewController: ViewConstraintAutoLayoutSetup {
    func setUpViews() {
        view.addSubview(tableView)
        view.addSubview(stateContainerView)
        
        // setup tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherDetailsCell.self, forCellReuseIdentifier: WeatherDetailsCell.identifier)
    }
    
    func setUpConstraints() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: stateContainerView.topAnchor, trailing: view.trailingAnchor)
        
        stateContainerView.anchor(top: tableView.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 100))
    }
}

extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDetailsCell.identifier) as? WeatherDetailsCell else {
            return UITableViewCell()
        }
        
        cell.setup(with: viewModel.dataSource[indexPath.row])
        
        return cell
    }
}
