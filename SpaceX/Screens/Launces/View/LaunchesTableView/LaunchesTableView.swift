//
//  LaunchesTablewView.swift
//  SpaceX
//
//  Created by serhat yaroglu on 16.12.2024.
//

import UIKit
protocol LaunchesTableViewDelegate: AnyObject {
    func didSelectLaunch(launch: Launch)
    func numberOfRows() -> Int
    func item(for row: Int) -> Launch
}

class LaunchesTablewView: UITableView ,UITableViewDataSource, UITableViewDelegate{


    weak var launchesDelegate: LaunchesTableViewDelegate?

   override init(frame: CGRect, style: UITableView.Style) {
         super.init(frame: .zero, style: style)
        setupTableView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        self.register(LaunchesCell.self, forCellReuseIdentifier: "LaunchesCell")
        self.separatorStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false
        
        dataSource = self
        delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.launchesDelegate!.numberOfRows()
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchesCell", for: indexPath) as? LaunchesCell else {
            return UITableViewCell()
        }
        
        let item = self.launchesDelegate!.item(for: indexPath.row)
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.launchesDelegate!.item(for: indexPath.row)
        self.launchesDelegate?.didSelectLaunch(launch: item)
    }
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

}
