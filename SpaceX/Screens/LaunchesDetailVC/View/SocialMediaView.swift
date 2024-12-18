//
//  SocialMediaView.swift
//  SpaceX
//
//  Created by serhat yaroglu on 16.12.2024.
//

import UIKit
import SnapKit

class SocialMediaView: UIView {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }

    func configure(launch: Launch) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard let links = launch.links else { return }
        
        if let redditCampaign = links.reddit?.campaign, !redditCampaign.isEmpty {
            addLinkView(iconName: "ic_reddit", title: "Reddit Campaign", url: redditCampaign)
        }
        if let redditLaunch = links.reddit?.launch, !redditLaunch.isEmpty {
            addLinkView(iconName: "ic_reddit", title: "Reddit Launch", url: redditLaunch)
        }
        if let redditMedia = links.reddit?.media, !redditMedia.isEmpty {
            addLinkView(iconName: "ic_reddit", title: "Reddit Media", url: redditMedia)
        }
        if let redditRecovery = links.reddit?.recovery, !redditRecovery.isEmpty {
            addLinkView(iconName: "ic_reddit", title: "Reddit Recovery", url: redditRecovery)
        }
        if let webcast = links.webcast, !webcast.isEmpty {
            addLinkView(iconName: "ic_youtube", title: "Youtube", url: webcast)
        }
        if let article = links.article, !article.isEmpty {
            addLinkView(iconName: "ic_spacex", title: "Article", url: article)
        }
        if let wikipedia = links.wikipedia, !wikipedia.isEmpty {
            addLinkView(iconName: "ic_wiki", title: "Wikipedia", url: wikipedia)
        }
        if let resskit = links.wikipedia, !resskit.isEmpty {
            addLinkView(iconName: "ic_presskit", title: "Resskit", url: resskit)
        }
    }
    
    private func addLinkView(iconName: String, title: String, url: String) {
        let container = UIView()
        container.layer.cornerRadius = 8
        container.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        container.layer.borderWidth = 1
        container.isUserInteractionEnabled = true

        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: iconName)
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 16
        iconImageView.clipsToBounds = true
        container.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Inter-SemiBold", size: 14)
        titleLabel.textColor = .black
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(12)
        }
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.contentMode = .scaleAspectFit
        container.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(8)
            make.height.equalTo(14)
        }
   
      

        let tap = UITapGestureRecognizer(target: self, action: #selector(linkTapped(_:)))
        container.addGestureRecognizer(tap)
        container.accessibilityHint = url
        stackView.addArrangedSubview(container)
        
        container.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
    }

    @objc private func linkTapped(_ gesture: UITapGestureRecognizer) {
        if let urlString = gesture.view?.accessibilityHint, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}


