//
//  GridItemView.swift
//  SpaceX
//
//  Created by serhat yaroglu on 16.12.2024.
//

import UIKit
import SnapKit

class GridItemView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 13)
        label.textColor = .clrSubtitle
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-SemiBold", size: 14)
        label.textColor = .black
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    private func setupLayout() {
        
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.lessThanOrEqualToSuperview().offset(-12)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.bottom.equalToSuperview().offset(-12)
            make.right.lessThanOrEqualToSuperview().offset(-12)
        }
    }
}
