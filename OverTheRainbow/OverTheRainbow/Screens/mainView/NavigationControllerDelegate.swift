//
//  NavigationControllerDelegate.swift
//  OverTheRainbow
//
//  Created by Hyorim Nam on 2022/07/25.
//

import UIKit

// references:
// https://www.youtube.com/watch?v=Nq2vBY0eC4A

// 특정 뷰들 사이의 이동에만 커스텀 전환 효과를 주기 위한 델리게이트
// 스토리보드에서 델리게이트 코드를 연결하는 방법: 뷰컨트롤러에 "Object"를 추가한 후, Object의 인스펙터에서 델리게이트 클래스를 연결하고, 뷰컨트롤러에서 Object로 드래그로 연결한다
class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController, to toVC: UIViewController) ->
    UIViewControllerAnimatedTransitioning? {
        // 접근성에서 움직임을 적게 했다면 커스텀 뷰 전환 효과를 주지 않음
        if UIAccessibility.isReduceMotionEnabled {return nil}
        
        let transition: UIViewControllerAnimatedTransitioning?
        
        // 시작 뷰와 다음 뷰에 따라 커스텀 뷰 전환 지정
        switch(fromVC, toVC) {
        // 메인뷰 -> 천국뷰 이동
        case (is MainViewController, is TestHeavenViewController):
            let mainHeavenTransition = MainHeavenTransition()
            mainHeavenTransition.operation = .push
            transition = mainHeavenTransition
        // 천국뷰 -> 메인뷰 이동
        case (is TestHeavenViewController, is MainViewController):
            let mainHeavenTransition = MainHeavenTransition()
            mainHeavenTransition.operation = .pop
            transition = mainHeavenTransition
        // 그 외: transition이 nil이면 네비게이션 기본 전환이 사용됨
        default: transition = nil
        }
        return transition
    }
}
