//
//  UpdatePetViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/20.
//

import UIKit

protocol SendBackDelegate {
    func dataReceived(data: Pet)
}

class UpdatePetViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!

    var delegate: SendBackDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnPressed))
        let confirmButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(confirmBtnPressed))
        cancelButton.tintColor = UIColor(named: "textColor")
        confirmButton.tintColor = UIColor(named: "textColor")

        navigationBar.leftBarButtonItem = cancelButton
        navigationBar.rightBarButtonItem = confirmButton
    }

    @objc func cancelBtnPressed() {
        self.dismiss(animated: true)
    }

    @objc func confirmBtnPressed() {
        // todo: Pet Model 업데이트
        print("confirm")

        if let name = nameTextField.text, let species = speciesTextField.text, let birth = birthTextField.text, let weight = weightTextField.text {
//            let myPet = Pet(name: name, species: species, birth: birth, weight: weight)
//            delegate?.dataReceived(data: myPet)
        }
        self.dismiss(animated: true)
    }
}
