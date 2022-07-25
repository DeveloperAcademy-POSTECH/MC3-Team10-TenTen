//
//  WrittenLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/25.
//

import UIKit

class WrittenLetterViewController: UIViewController {
    @IBOutlet weak var selectedLetterNavBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedLetterNavBar.title="편지 상세"
        // Do any additional setup after loading the view.
    }

}
