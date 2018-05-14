//
//  PresentViewPost.swift
//  Melo
//
//  Created by Dipali Bajaj on 5/13/18.
//  Copyright © 2018 Dipali Bajaj. All rights reserved.
//

import UIKit

class PresentViewPost: NSObject, UIViewControllerAnimatedTransitioning {
    var cellFrame: CGRect!
    var cellTransform: CATransform3D!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let destination = transitionContext.viewController(forKey: .to) as? ViewPostViewController
        let containterView = transitionContext.containerView
        containterView.addSubview((destination?.view)!)
        
        //Initial state
        let animator = UIViewPropertyAnimator(duration: 5, dampingRatio: 0.7) {
            //Finalstate
        }
        animator.addCompletion {
            (finished) in
            
            //Completion
            
            transitionContext.completeTransition(true)
        }
    }
}
