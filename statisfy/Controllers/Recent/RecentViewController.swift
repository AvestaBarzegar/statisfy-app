//
//  RecentViewController.swift
//  statisfy-spotify-ios
//
//  Created by Avesta Barzegar on 2021-03-26.
//

import UIKit

class RecentViewController: UIViewController {
    
    // MARK: - Data
    
    private var informationType = AppTabBarController.informationType
    
    private var information: RecentTracksViewModelArray? {
        didSet {
            self.removeSpinner()
            self.tableView.reloadData()
            if information?.allInfo == nil {
                noInformationLabel.isHidden = false
            }
            guard let informationArr = information?.allInfo else { return }
            noInformationLabel.isHidden = !informationArr.isEmpty
        }
    }
    
    let headerInfo = SectionHeaderViewModel(title: "Recently Played", leftImageName: nil, rightImageName: nil)
    
    // MARK: - Init Views
    
    private lazy var noInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No History Available"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.spotifyWhite
        label.font = UIFont.welcomeSubtitleFont
        label.isHidden = true
        return label
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.backgroundColor
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.separatorStyle = .none
        view.register(RecentTrackTableViewCell.self, forCellReuseIdentifier: RecentTrackTableViewCell.identifier)
        return view
    }()
    
    private lazy var headerView: SectionHeaderView = {
        let header = SectionHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.info = headerInfo
        return header
    }()
    
    // MARK: - Layout Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getInformation()
        UIView.animate(withDuration: Double(Constants.animationDuration.rawValue),
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        self.tableView.alpha = 1.0
                        self.noInformationLabel.alpha = 1.0
                       },
                       completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView.alpha = 0
        self.noInformationLabel.alpha = 0.0
    }
    
    private func setup() {
        self.tableView.alpha = 0
        self.view.backgroundColor = UIColor.backgroundColor
        self.view.addSubview(tableView)
        self.view.addSubview(headerView)
        self.view.addSubview(noInformationLabel)
        let safeArea = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            noInformationLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            noInformationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 32),
            noInformationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -32),
            
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Constants.headerViewHeight.rawValue),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    deinit {
        print("deinit Recent")
    }
    
}

extension RecentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return information?.allInfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecentTrackTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentTrackTableViewCell.identifier) as? RecentTrackTableViewCell else { return UITableViewCell() }
        cell.recentTrackInfo = information?.allInfo?[indexPath.row]
        
        return cell
        
    }
    
}

// MARK: - Networking Logic

extension RecentViewController {
    
    private func getInformation() {
        self.showSpinner(onView: self.view)
        let controllerName = ViewControllerNames.recentTracks.rawValue
        if let expiryDate = UserDefaults.standard.object(forKey: controllerName) as? Date {
            let currentTime = Date().timeIntervalSince1970
            let expiryTime = expiryDate.timeIntervalSince1970
            if currentTime >= expiryTime {
                fetchInfo()
            }
        } else {
            let fiveMinutes: TimeInterval = 240
            let newExpiryDate = Date().addingTimeInterval(TimeInterval(fiveMinutes))
            UserDefaults.standard.setValue(newExpiryDate, forKey: controllerName)
            fetchInfo()
        }
    }
    
    func fetchInfo() {
        switch informationType {
        case .server:
            fetchServerInfo()
        case .demo:
            fetchMockInfo()
        }
    }
    
    private func fetchServerInfo() {
        let manager = AnalyticsManager()
        
        manager.getRecent { [weak self] recentArr, error in
            if error != nil {
                if let error = error {
                    DispatchQueue.main.async {
                        CustomAlertViewController.showAlertOn(self!, "ERROR", error, "Retry", cancelButtonText: "cancel") {
                            self?.getInformation()
                        } cancelAction: {
                            
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.information = recentArr
                }
            }
        }
    }
    
    private func fetchMockInfo() {
        MockManager.shared.fetchRecentTracksMock { [weak self] recentArr in
            DispatchQueue.main.async {
                self?.information = recentArr
            }
        }
    }
}
