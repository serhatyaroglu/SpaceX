//
//  LottieManager.swift
//  SpaceX
//
//  Created by serhat yaroglu on 18.12.2024.
//

import Foundation
import UIKit
import Lottie

public class LottieManager{
    
    public static func createLottie(animation : AnimationType) -> LottieAnimationView {
        
        var animLoading = LottieAnimationView()
        let defaultAnimationName = animation.rawValue.name
        
        switch animation {
        case .custom(name: _):
            animLoading = LottieAnimationView(name: defaultAnimationName)
            break
        default:
            let animationURL = Bundle.main.path(forResource: defaultAnimationName, ofType: "json")
            animLoading = LottieAnimationView(filePath: animationURL!)
            break
        }
        
        animLoading.backgroundColor = .clear
        animLoading.loopMode = .loop
        animLoading.animationSpeed = 1
        animLoading.backgroundBehavior = .pauseAndRestore
        animLoading.play()
        return animLoading
    }
    
    public static func showFullScreenLottie(animation : AnimationType, width : Int? = nil, color : UIColor? = nil, backgroundOpacity : Double = 0.65, playOnce : Bool = false, speed : Double = 1) {
        
        guard let window = UIApplication.shared.keyWindow else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001, execute: {
                self.showFullScreenLottie(animation: animation, width: width, color: color, backgroundOpacity : backgroundOpacity)
            })
            return
        }
        
        let viewLoading = UIView()
        viewLoading.frame = window.bounds
        viewLoading.tag = 10000
        viewLoading.backgroundColor = .black.withAlphaComponent(backgroundOpacity)
        
        let defaultAnimationWidht = animation.rawValue.width
        let defaultAnimationName = animation.rawValue.name
        var animLoading = LottieAnimationView()
        
        switch animation {
        case .custom(name: _):
            animLoading = LottieAnimationView(name: defaultAnimationName)
            break
        default:
            let animationURL = Bundle.main.path(forResource: defaultAnimationName, ofType: "json")
            animLoading = LottieAnimationView(filePath: animationURL!)
            break
        }
        
        animLoading.frame.size = CGSize(width: width ?? defaultAnimationWidht, height: width ?? defaultAnimationWidht)
        animLoading.center = window.center
        animLoading.backgroundColor = .clear
        animLoading.loopMode = playOnce ? .playOnce : .loop
        animLoading.animationSpeed = speed
        animLoading.backgroundBehavior = .pauseAndRestore
        viewLoading.addSubview(animLoading)
        if playOnce{
            animLoading.play { finished in
                LottieManager.removeFullScreenLottie()
            }
        }else{
            animLoading.play()
        }
        
        if let color{
            let viewTint = UIView()
            viewTint.frame = window.bounds
            viewTint.backgroundColor = color
            viewLoading.addSubview(viewTint)
            viewTint.mask = animLoading
        }
        
        window.addSubview(viewLoading)
    }
    
    public static func removeFullScreenLottie(){
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        for subview in window.subviews{
            if subview.tag == 10000{
                subview.removeFromSuperview()
            }
        }
    }
    
    public enum AnimationType : RawRepresentable{
        
        case loadingCircle2
        case custom(name : String)
        public typealias RawValue = (name: String, width: Int)
        
        public var rawValue: RawValue {
            switch self {
            case .custom(name: let name):
                return (name: name, width: 100)
                
            case .loadingCircle2:
                return (name: "loadingCircle2", width: 120)
            }
        }
        
        public init?(rawValue: RawValue) {
            switch rawValue {
            default:
                return nil
            }
        }
    }
}
