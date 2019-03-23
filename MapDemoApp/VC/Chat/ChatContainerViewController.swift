//
//  ChatContainerViewController.swift
//  MapDemoApp
//
//  Created by kitaharamugirou on 2019/03/21.
//  Copyright © 2019 kitaharamugirou. All rights reserved.
//

import UIKit
import PullToDismissTransition


/*バグるから使わない*/
class ChatContainerViewController: UIViewController, PullToDismissable  {
    private let chatVC : ChatViewController = {
        return ChatViewController()
    }()
    
    private(set) lazy var pullToDismissTransition: PullToDismissTransition = {
        let pullToDismissTransition = PullToDismissTransition(
            viewController: self,
            transitionType: .slideStatic
        )
        
        ////
        // NOTE: Optional, unless you implement any of the delegate methods:
        //pullToDismissTransition.delegate = self
        
        return pullToDismissTransition
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.chatVC.view)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        setupPullToDismiss()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPullToDismiss()
        
        let scrollView = chatVC.getScrollView()
        pullToDismissTransition.monitorActiveScrollView(scrollView: scrollView)
    }
}


extension ChatContainerViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            guard isPullToDismissEnabled else { return nil }
            return pullToDismissTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            guard isPullToDismissEnabled else { return nil }
            return pullToDismissTransition
    }
}
