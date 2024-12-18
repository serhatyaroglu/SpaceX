//
//  ViewController.swift
//  SpaceX
//
//  Created by serhat yaroglu on 16.12.2024.
//

import UIKit
import SnapKit
class LaunchesVC: UIViewController {
    private let tableView = LaunchesTablewView()
    
    private let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Upcoming", "Past"])
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        sc.selectedSegmentTintColor = .white
        sc.backgroundColor = .clrSegmentDeSelect
        sc.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        return sc
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Launches"
        label.font = UIFont(name: "Inter-Medium", size: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    let viewModel = ViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        viewModel.fetchLaunches(for: .upcoming)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        viewModel.delegate = self
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        view.addSubview(tableView)
        tableView.launchesDelegate = self
        
        tableView.register(LaunchesCell.self, forCellReuseIdentifier: "LaunchesCell")
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            view.addSubview(tableView)
            make.top.equalTo(segmentedControl.snp.bottom).offset(24)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            
        }
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.fetchLaunches(for: .upcoming)
        case 1:
            viewModel.fetchLaunches(for: .past)
        default:
            viewModel.fetchLaunches(for: .upcoming)
        }
        
    }
    private func setupRefreshControl() {
        DispatchQueue.main.async {
            LottieManager.showFullScreenLottie(animation: .loadingCircle2)
        }
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
    }
    @objc private func handlePullToRefresh() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            DispatchQueue.main.async {
                LottieManager.showFullScreenLottie(animation: .loadingCircle2)
            }
            viewModel.fetchLaunches(for: .upcoming)
        case 1:
            DispatchQueue.main.async {
                LottieManager.showFullScreenLottie(animation: .loadingCircle2)
            }
            viewModel.fetchLaunches(for: .past)
        default:
            DispatchQueue.main.async {
                LottieManager.showFullScreenLottie(animation: .loadingCircle2)
            }
            viewModel.fetchLaunches(for: .upcoming)
        }
    }
   
}

extension LaunchesVC: ViewModelDelegate {
    func launchesDidFetch() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            LottieManager.removeFullScreenLottie()
        }
    }
    
    func errorOccurred(error: NetworkError) {
        DispatchQueue.main.async {
            switch error {
            case .unableToCompleteError:
                AlertManager.present(title: "İstek Tamamlanamadı", message: "İsteğinizi tamamlayamadık. Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.", style: .alert, viewController: self)
                LottieManager.removeFullScreenLottie()
            case .invalidResponse:
                AlertManager.present(title: "Geçersiz Yanıt", message: "Sunucudan geçersiz bir yanıt aldık. Lütfen tekrar deneyin.", style: .alert, viewController: self)
                LottieManager.removeFullScreenLottie()
            case .invalidData:
                AlertManager.present(title: "Geçersiz Veri", message: "Sunucudan alınan veri geçersiz. Lütfen tekrar deneyin.", style: .alert, viewController: self)
                LottieManager.removeFullScreenLottie()
            case .authError:
                AlertManager.present(title: "Kimlik Doğrulama Hatası", message: "Kimlik doğrulama hatası oluştu. Lütfen giriş bilgilerinizi kontrol edin.", style: .alert, viewController: self)
                LottieManager.removeFullScreenLottie()
            case .unknownError:
                AlertManager.present(title: "Bilinmeyen Hata", message: "Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.", style: .alert, viewController: self)
                LottieManager.removeFullScreenLottie()
            case .decodingError:
                AlertManager.present(title: "Veri Çözümleme Hatası", message: "Sunucudan alınan veriyi işleyemedik. Lütfen tekrar deneyin.", style: .alert, viewController: self)
                LottieManager.removeFullScreenLottie()
            }
        }
    }
}

extension LaunchesVC: LaunchesTableViewDelegate {
    func numberOfRows() -> Int {
        viewModel.numberOfRows()
    }
    func item(for row: Int) -> Launch {
        viewModel.item(for: row)
    }
    func didSelectLaunch(launch: Launch) {
        DispatchQueue.main.async {
            LottieManager.showFullScreenLottie(animation: .loadingCircle2)
        }
        let destinationVC = LaunchesDetailVC(launch: launch)
        present(destinationVC: destinationVC, slideDirection: .right)
    }
}
