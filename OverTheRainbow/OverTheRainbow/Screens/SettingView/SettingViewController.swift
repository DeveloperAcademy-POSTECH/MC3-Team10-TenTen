//
//  SettingViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/27.
//
// swiftlint:disable force_cast

import UIKit

enum UpdateMode: String {
    case add = "ADD"
    case update = "UPDATE"
}

class PetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
}

class SettingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    private let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    var pets = [PetResultDto]() {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    var mode: UpdateMode?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("load")
        // TODO: pets에 현재 UserDefaults 펫을 먼저 넣고 나머지 펫들을 append시키기

        UserDefaults.standard.set("62e1351dedd840ec0d2c01d4", forKey: "petID")

//        updatePetList()

//        collectionView.delegate = self
//        collectionView.dataSource = self
        let updateButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(showActionSheet))
        updateButton.tintColor = UIColor(named: "textColor")
        navItem.rightBarButtonItem = updateButton

        //        do {
        //            let petDTO = try service.findPet(id: "62e0952349d71adbcea8ae97")
        //        } catch {
        //            print("Error finding pet : \(error)")
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear")
        updatePetList()
    }

    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: "펫 설정하기", message: "", preferredStyle: .actionSheet)
        let addPet = UIAlertAction(title: "펫 추가하기", style: .default) { action in
            self.mode = .add
            self.performSegue(withIdentifier: "UpdatePetView", sender: self)
        }
        let updatePet = UIAlertAction(title: "현재 펫 수정하기", style: .default) { action in
            self.mode = .update
            self.performSegue(withIdentifier: "UpdatePetView", sender: self)
        }
        let deletePet = UIAlertAction(title: "현재 펫 삭제하기", style: .default) { action in
            // TODO: UserDefaults에 있는 현재 Pet 삭제 후 그 다음 Pet을 UserDefaults로?
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
        }

        actionSheet.addAction(addPet)
        actionSheet.addAction(updatePet)
        actionSheet.addAction(deletePet)
        actionSheet.addAction(cancelAction)
        actionSheet.view.tintColor = UIColor(named: "textColor")

        present(actionSheet, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? UpdatePetViewController else {
            return
        }
        // TODO: UserDefaults에서 펫 ID 가져오기
        do {
            if mode == .add {
                destinationVC.currentPet = nil
            } else {
                destinationVC.currentPet = try service.findPet(id: UserDefaults.standard.string(forKey: "petID") ?? "")
            }
        } catch {
            print("Error finding pet : \(error)")
        }
        destinationVC.parentVC = self
    }

    func updatePetList() {
        print("update!")
        pets = [PetResultDto]()

        let currentPetID = UserDefaults.standard.string(forKey: "petID")

        do {
            try pets.append(service.findPet(id: currentPetID!))
        } catch {
            print("Error finding pet : \(error)")
        }

        let otherPets = service.findAllPet().filter {
            $0.id != currentPetID
        }

        for pet in otherPets {
            pets.append(pet)
        }

        print("pets : \(pets)")
    }
}

// MARK: - DataSource, Delegate of CollectionView
extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as? PetCollectionViewCell else {
            return UICollectionViewCell()
        }
        let pet = pets[indexPath.row]

        if pet.id == UserDefaults.standard.string(forKey: "petID") {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "checkmark.circle")
            let fullString = NSMutableAttributedString(string: "\(pet.name) ")
            fullString.append(NSAttributedString(attachment: imageAttachment))
            cell.nameLabel.attributedText = fullString
        } else {
            cell.nameLabel.text = pet.name
        }
        cell.weightLabel.text = String(pet.age)
        cell.speciesLabel.text = pet.species
        return cell
    }
}

// MARK: - Layout of CollectionView
extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 260

        return CGSize(width: width, height: height)
    }
}