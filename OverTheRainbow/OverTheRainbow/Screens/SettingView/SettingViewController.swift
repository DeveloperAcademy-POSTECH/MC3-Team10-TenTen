//
//  SettingViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/20.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let updateButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(updatePet))
        updateButton.tintColor = UIColor(named: "textColor")
        navigationBar.rightBarButtonItem = updateButton
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? UpdatePetViewController
        destinationVC!.delegate = self
    }

    @objc func updatePet() {
        print("Update pet")
        performSegue(withIdentifier: "UpdatePetView", sender: self)
    }
}

extension SettingViewController: SendBackDelegate {
    func dataReceived(data: Pet) {
        nameLabel.text = data.name
        speciesLabel.text = data.species
        birthLabel.text = data.birth
        weightLabel.text = data.weight
    }
}

// MARK: - Mock Data
struct Pet {
    var name: String
    var species: String
    var birth: String
    var weight: String
}
