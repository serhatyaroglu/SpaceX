//
//  GridInfoView.swift
//  SpaceX
//
//  Created by serhat yaroglu on 16.12.2024.
//

import UIKit
import SnapKit

class GridInfoView: UIView {
    
    private let landingAttemptView = GridItemView()
    private let landingSuccessView = GridItemView()
    private let landingTypeView = GridItemView()
    private let fightNumberView = GridItemView()
    private let upcomingView = GridItemView()
    private let datePrecisionView = GridItemView()
    
    private let row1Stack = UIStackView()
    private let row2Stack = UIStackView()
    private let row3Stack = UIStackView()
    private let gridStack = UIStackView()
    
    private let verticalSeparator = UIView()
    private let horizontalSeparator1 = UIView()
    private let horizontalSeparator2 = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        clipsToBounds = true
        
        setupStacks()
        addSubview(gridStack)
        gridStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupSeparators()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        landingAttempt: (String, String),
        landingSuccess: (String, String),
        landingType: (String, String),
        fightNumber: (String, String),
        upcoming: (String, String),
        datePrecision: (String, String)
    ) {
        landingAttemptView.configure(title: landingAttempt.0, value: landingAttempt.1)
        landingSuccessView.configure(title: landingSuccess.0, value: landingSuccess.1)
        landingTypeView.configure(title: landingType.0, value: landingType.1)
        fightNumberView.configure(title: fightNumber.0, value: fightNumber.1)
        upcomingView.configure(title: upcoming.0, value: upcoming.1)
        datePrecisionView.configure(title: datePrecision.0, value: datePrecision.1)
    }
    
    private func setupStacks() {
        row1Stack.axis = .horizontal
        row1Stack.distribution = .fillEqually
        row1Stack.spacing = 0
        row1Stack.addArrangedSubview(landingAttemptView)
        row1Stack.addArrangedSubview(landingSuccessView)
        
        row2Stack.axis = .horizontal
        row2Stack.distribution = .fillEqually
        row2Stack.spacing = 0
        row2Stack.addArrangedSubview(landingTypeView)
        row2Stack.addArrangedSubview(fightNumberView)
        
        row3Stack.axis = .horizontal
        row3Stack.distribution = .fillEqually
        row3Stack.spacing = 0
        row3Stack.addArrangedSubview(upcomingView)
        row3Stack.addArrangedSubview(datePrecisionView)
        
        gridStack.axis = .vertical
        gridStack.distribution = .fillEqually
        gridStack.spacing = 0
        gridStack.addArrangedSubview(row1Stack)
        gridStack.addArrangedSubview(row2Stack)
        gridStack.addArrangedSubview(row3Stack)
    }
    
    private func setupSeparators() {
        verticalSeparator.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        horizontalSeparator1.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        horizontalSeparator2.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        addSubview(verticalSeparator)
        addSubview(horizontalSeparator1)
        addSubview(horizontalSeparator2)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalWidth = bounds.width
        let totalHeight = bounds.height
        
        let columnWidth = totalWidth / 2
        let rowHeight = totalHeight / 3
        
        verticalSeparator.frame = CGRect(x: columnWidth, y: 0, width: 1, height: totalHeight)
        horizontalSeparator1.frame = CGRect(x: 0, y: rowHeight, width: totalWidth, height: 1)
        horizontalSeparator2.frame = CGRect(x: 0, y: rowHeight * 2, width: totalWidth, height: 1)
    }
}
