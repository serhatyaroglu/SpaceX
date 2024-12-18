//
//  ViewModel.swift
//  SpaceX
//
//  Created by serhat yaroglu on 17.12.2024.
//
import Foundation
import Lottie
protocol ViewModelDelegate: AnyObject {
    func launchesDidFetch()
    func errorOccurred(error: NetworkError)
}

class ViewModel {
    weak var delegate: ViewModelDelegate?
    var Launches: [Launch] = []
    func fetchLaunches(for launchState: NetworkEndPoint) {
        NetworkLayer.shared.getRequest(launchState) { result in
            switch result {
            case .success(let launches):
                DispatchQueue.main.async {
                    LottieManager.removeFullScreenLottie()
                }
                self.Launches = launches
                self.delegate?.launchesDidFetch()
            case .failure(let error):
                self.delegate?.errorOccurred(error: error)
            }
        }
    }
    
    func numberOfRows() -> Int {
        return Launches.count
    }
    func item(for row: Int) -> Launch {
        return Launches[row]
    }
    
    func didSelectRow(at: Int) -> Launch {
        return Launches[at]
    }
}
