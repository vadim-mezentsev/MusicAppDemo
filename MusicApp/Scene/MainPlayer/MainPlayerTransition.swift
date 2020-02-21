//
//  MainPlayerTransition.swift
//  MusicApp
//
//  Created by Vadim on 20/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation
import UIKit

class MainPlayerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    
    var duration = 0.5
    var tabBarView: UIView?
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let mainPlayerViewController = transitionContext.viewController(forKey: .to) as? MainPlayerViewController,
            let miniPlayerViewController = transitionContext.viewController(forKey: .from) as? MiniPlayerViewController,
            let tabBarView = tabBarView,
            let presentedView = transitionContext.view(forKey: .to)
        else {
            assertionFailure()
            return
        }
        
        let superview = transitionContext.containerView
        let miniPlayerView = miniPlayerViewController.miniPlayerView
        let mainPlayerView = mainPlayerViewController.mainPlayerView
        
        // prepare presented view
        let pdesentedViewHeightOffset = presentedView.frame.height - (miniPlayerView.frame.height + tabBarView.frame.height)
        presentedView.transform = CGAffineTransform(translationX: 0, y: pdesentedViewHeightOffset)
        superview.addSubview(presentedView)
        
        // prepare main player view
        mainPlayerView.trackImageView.alpha = 0.0
        
        //prepare fake tab bar
        let fakeTabBar = makeFakeView(for: tabBarView)
        superview.insertSubview(fakeTabBar, aboveSubview: presentedView)
        
        //prepare fake mini player
        let fakeMiniPlayer = makeFakeView(for: miniPlayerView)
        superview.insertSubview(fakeMiniPlayer, aboveSubview: presentedView)
        
        //prepare fake track image
        let fakeImageView = makeCloneImageView(for: mainPlayerView.trackImageView)
        fakeImageView.frame = miniPlayerView.trackImageView.convert(miniPlayerView.trackImageView.frame, to: mainPlayerView)
        mainPlayerView.addSubview(fakeImageView)
        
        let animations = {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                fakeTabBar.transform = CGAffineTransform(translationX: 0, y: fakeTabBar.frame.height)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                fakeMiniPlayer.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 1) {
                presentedView.transform = .identity
                fakeImageView.frame = mainPlayerViewController.mainPlayerView.trackImageView.frame.offsetBy(dx: 30, dy: 0)
            }
        }
        
        let completion: (Bool) -> Void = { _ in
            mainPlayerViewController.mainPlayerView.trackImageView.alpha = 1.0
            
            fakeTabBar.removeFromSuperview()
            fakeMiniPlayer.removeFromSuperview()
            fakeImageView.removeFromSuperview()
            
            transitionContext.completeTransition(true)
        }
        
        performTransition(animations, completion)
    }
    
    // MARK: - Helper methods
    
    private func performTransition(_ animations: @escaping () -> Void, _ completion: @escaping (Bool) -> Void) {
        let animation = UIViewPropertyAnimator(duration: duration, curve: .easeInOut)
        animation.addAnimations {
            UIView.animateKeyframes(
                withDuration: self.duration,
                delay: 0.0,
                animations: animations,
                completion: completion
            )
        }
        animation.startAnimation()
    }
    
    private func makeFakeView(for view: UIView) -> UIView {
        guard let fakeView = view.snapshotView(afterScreenUpdates: false) else {
            assertionFailure()
            return UIView()
        }
        fakeView.frame = view.frame
        return fakeView
    }
    
    private func makeCloneImageView(for imageView: UIImageView) -> UIImageView {
        let cloneImageView = UIImageView()
        cloneImageView.image = imageView.image?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 100))
        cloneImageView.backgroundColor = imageView.backgroundColor
        cloneImageView.tintColor = imageView.tintColor
        cloneImageView.layer.cornerRadius  = imageView.layer.cornerRadius
        cloneImageView.contentMode = imageView.contentMode
        cloneImageView.clipsToBounds = true
        return cloneImageView
    }
    
}

// MARK: - UIViewControllerTransitionDelegate

extension MainPlayerTransition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
