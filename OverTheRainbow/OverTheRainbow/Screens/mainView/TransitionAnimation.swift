//
//  TransitionAnimation.swift
//  OverTheRainbow
//
//  Created by Hyorim Nam on 2022/07/21.
//

import UIKit

// references:
// https://www.youtube.com/watch?v=Nq2vBY0eC4A
// https://www.youtube.com/watch?v=FvdrNSi8orE&list=WL&index=1

// 커스텀 뷰 전환
// 네비 컨트롤러의 Operation에 따라 메인뷰와 천국뷰가 아래로 내려가거나 위로 올라감
class MainHeavenTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: Double = 1.0
    // 네비 컨트롤러 델리게이트에서 지정해준 값에 따름
    var operation: UINavigationController.Operation = .push

    // 애니메이션 속도 조절 (필수 구현)
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }

    // 애니메이션 구현 부분
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        let bounds = containerView.bounds
        var moveHeight = bounds.height // 아래로
        if operation == .pop { // 천국뷰 -> 메인뷰 이동의 경우
            moveHeight = -bounds.height // 위로
        }
        toView.frame = bounds.offsetBy(dx: 0, dy: -moveHeight) // 애니메이션 시작 전에 스크린보다 위에 있음
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
            // offsetBy가 지정하는 네모와 영역이 같아질 때까지 이동
            toView.frame = bounds.offsetBy(dx: 0, dy: 0)
            fromView.frame = bounds.offsetBy(dx: 0, dy: moveHeight) // 아래로 이동
        } completion: { position in
            transitionContext.completeTransition(true)
            // 이하는 추후 추가해보려는 UIPercentDrivenInteractiveTransition 관련
            // let finished = !transitionContext.transitionWasCancelled
            // transitionContext.completeTransition(finished)
        }
    }
}
