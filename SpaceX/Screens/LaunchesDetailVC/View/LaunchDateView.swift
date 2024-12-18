//
//  LaunchDateView.swift
//  SpaceX
//
//  Created by serhat yaroglu on 16.12.2024.
//

import UIKit
import SnapKit

class LaunchDateView: UIView {
    
    private let launchDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "LAUNCH DATE"
        label.font = UIFont(name: "Inter-Medium", size: 13)
        label.textColor = .white
        return label
    }()
    
    private let launchDateValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont(name: "Inter-Regular", size: 10)
        label.textColor = .white
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont(name: "Inter-Medium", size: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    private let timeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 10)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var timer: Timer?
    private var targetDate: Date?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .black
        layer.cornerRadius = 8
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(date: String) {
        let truncatedDate = String(date.prefix(10))
        launchDateValueLabel.text = truncatedDate
        startTimer(date: date)
    }
    
    private func setupLayout() {
        addSubview(launchDateTitleLabel)
        addSubview(launchDateValueLabel)
        addSubview(timeLabel)
        addSubview(timeInfoLabel)
        launchDateTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
        
        launchDateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(launchDateTitleLabel.snp.bottom).offset(4)
            make.left.equalTo(launchDateTitleLabel)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        timeInfoLabel.text = "Hour : Minute : Second"
        timeInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    func formattedTime(time: Float) -> String {
        var remainingTime = Int(time)
        
        let secondsInYear = 365 * 24 * 3600
        let secondsInMonth = 30 * 24 * 3600
        let secondsInWeek = 7 * 24 * 3600
        let secondsInDay = 24 * 3600
        let secondsInHour = 3600
        let secondsInMinute = 60
        
        let years = remainingTime / secondsInYear
        remainingTime %= secondsInYear
        
        let months = remainingTime / secondsInMonth
        remainingTime %= secondsInMonth
        
        let weeks = remainingTime / secondsInWeek
        remainingTime %= secondsInWeek
        
        let days = remainingTime / secondsInDay
        remainingTime %= secondsInDay
        
        let hours = remainingTime / secondsInHour
        remainingTime %= secondsInHour
        
        let minutes = remainingTime / secondsInMinute
        let seconds = remainingTime % secondsInMinute
        
        var components: [String] = []
        
        if years > 0 {
            components.append("\(years)")
        }
        if months > 0 {
            components.append(" \(months)")
        }
        if weeks > 0 {
            components.append(" : \(weeks)")
        }
        if days > 0 {
            components.append(" : \(days)")
        }
        if hours > 0 {
            components.append(" : \(hours)")
        }
        if minutes > 0 {
            components.append(" : \(minutes)")
        }
        if seconds > 0 || components.isEmpty {
            components.append(" : \(seconds)")
        }
        
        return components.joined(separator: " ")
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startTimer(date: String) {
        let iso8601String = date
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date1 = isoFormatter.date(from: iso8601String) {
            print("Parsed Date: \(date1)")
            let now = Date()
            var timeInterval = Int(date1.timeIntervalSince(now) * -1) - 63072000
            
            timeLabel.text = formattedTime(time: Float(timeInterval))
            DispatchQueue.main.async {
                self.timer =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    timeInterval += 1
                    self.timeLabel.text = self.formattedTime(time: Float(timeInterval))
                }
            }
        } else {
            print("Failed to parse date.")
        }
    }
}
