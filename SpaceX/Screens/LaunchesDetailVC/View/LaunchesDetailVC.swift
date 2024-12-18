//
//  LaunchesDetailVC.swift
//  SpaceX
//
//  Created by serhat yaroglu on 16.12.2024.
//

import UIKit
import SnapKit
import Kingfisher

class LaunchesDetailVC: UIViewController {
    
    // MARK: - UI Elements
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming Lanch"
        label.font = UIFont(name: "Inter-Medium", size: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let rocketImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 24
        iv.layer.masksToBounds = true
        iv.image = UIImage(named: "rocket_placeholder")
        return iv
    }()
    
    private let rocketNameLabel: UILabel = {
        let label = UILabel()
        label.text = "CRS - 20"
        label.font = UIFont(name: "Inter-SemiBold", size: 18)
        label.textColor = .black
        return label
    }()
    private let launchDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 13)
        label.textColor = .clrSubtitle
        return label
    }()
    
    let gridInfoView = GridInfoView()
    private let blackInfoView = LaunchDateView()
    private let socialMediaLinksView = SocialMediaView()
    let launch: Launch
    
    init(launch:Launch) {
        self.launch = launch
        super.init(nibName: nil, bundle: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        blackInfoView.timer?.invalidate()
        blackInfoView.timer = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if launch.upcoming {
            gridInfoView.snp.remakeConstraints { make in
                make.top.equalTo(blackInfoView.snp.bottom).offset(24)
                make.left.right.equalToSuperview().inset(20)
            }
        }else{
            gridInfoView.snp.remakeConstraints { make in
                make.top.equalTo(launchDateLabel.snp.bottom).offset(24)
                make.left.right.equalToSuperview().inset(20)
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        stateControl()
        DispatchQueue.main.async {
            LottieManager.removeFullScreenLottie()
        }
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        rocketImageView.kf.setImage(with: launch.links?.patch?.small.flatMap(URL.init), placeholder: UIImage(named: "img_rocket"))
        
        view.addSubview(rocketImageView)
        rocketImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(48)
        }
        
        rocketNameLabel.text = launch.name
        view.addSubview(rocketNameLabel)
        rocketNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rocketImageView)
            make.left.equalTo(rocketImageView.snp.right).offset(12)
        }
        
        stateControl()
        view.addSubview(launchDateLabel)
        launchDateLabel.snp.makeConstraints { make in
            make.top.equalTo(rocketImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }
        
        blackInfoView.configure(date: launch.dateUtc)
        view.addSubview(blackInfoView)
        blackInfoView.snp.makeConstraints { make in
            make.top.equalTo(rocketImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        view.addSubview(gridInfoView)
        gridInfoView.snp.makeConstraints { make in
            make.top.equalTo(blackInfoView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
        }
        
        gridInfoView.configure(
            landingAttempt: ("Landing Attempt",
                             launch.cores?.first?.landingAttempt.map { $0 ? "True" : "False" } ?? "-"),
            landingSuccess: ("Landing Success",
                             launch.cores?.first?.landingSuccess.map { $0 ? "True" : "False" } ?? "-"),
            landingType: ("Landing Type",
                          launch.cores?.first?.landingType ?? "-"),
            fightNumber: ("Fight Number",
                          launch.flightNumber.map { "\($0)" } ?? "-"),
            upcoming: ("Upcoming",
                       launch.upcoming ? "True" : "False"),
            datePrecision: ("Date Precision",
                            launch.datePrecision ?? "-")
        )
        socialMediaLinksView.configure(launch: launch)
        
        view.addSubview(socialMediaLinksView)
        socialMediaLinksView.snp.makeConstraints { make in
            make.top.equalTo(gridInfoView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func stateControl(){
        if launch.upcoming{
            blackInfoView.isHidden = false
            titleLabel.text = "Upcoming Lanch"
        }else{
            titleLabel.text = "Past Lanch"
            blackInfoView.isHidden = true
            setAttributedText()
        }
    }
    
    func setAttributedText() {
        let normalText = "Launch Date: "
        let truncatedDate = String(launch.dateUtc.prefix(10))
        let boldText = truncatedDate
        
        let attributedString = NSMutableAttributedString(string: normalText, attributes: [
            .font: UIFont(name: "Inter-Regular", size: 14) ?? UIFont(name: "Inter-Regular", size: 14)!,
            .foregroundColor: UIColor.clrSubtitle
        ])
        
        let boldAttributedString = NSAttributedString(string: boldText, attributes: [
            .font: UIFont(name: "Inter-SemiBold", size: 14) ?? UIFont(name: "Inter-SemiBold", size: 14)!,
            .foregroundColor: UIColor.clrSubtitle
        ])
        
        attributedString.append(boldAttributedString)
        launchDateLabel.attributedText = attributedString
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
}
