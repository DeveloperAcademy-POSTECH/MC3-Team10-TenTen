//
//  LetterListViewController.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/18.
//

import UIKit

class LetterLitstMainViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupNavigationBar() {
        super.setupNavigationBar()
    }
}



// MARK: - uikit preview

#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    // update
    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        
    }
    // makeui
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        LetterLitstMainViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View{
        ViewControllerRepresentable().previewDisplayName("아이폰 11")
    }
}
#endif
