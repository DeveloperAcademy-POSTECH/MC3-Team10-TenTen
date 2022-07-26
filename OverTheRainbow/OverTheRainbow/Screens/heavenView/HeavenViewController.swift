//
//  HeavenViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/26.
//

import PhotosUI
import UIKit

class HeavenViewController: UIViewController {
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var letterButton: UIButton!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var recentFlowerImageView: UIImageView!

    let service: DataAccessService = DataAccessProvider.dataAccessConfig.getService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(mainTransition))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)

        photoButton.layer.cornerRadius = photoButton.layer.frame.size.width / 2
        petImageView.layer.cornerRadius = petImageView.layer.frame.size.width / 2

        do {
            // TODO: 현재 Pet의 ID를 UserDefaults에서 가져오기
            var resultDTO = try service.getHeavenView("62df7c5eedd840ec0d2c01c2")
            recentFlowerImageView.image = UIImage(named: resultDTO.lastFlower!.name)

            // TODO: recentFlowers 수정 후 다시 코드 짜기
            print(resultDTO.recentFlowers)
            var xPos = 20

            for flower in resultDTO.recentFlowers {
                let flowerImageView = UIImageView(frame: CGRect(x: xPos, y: 300, width: 70, height: 140))
                self.view.addSubview(flowerImageView)

                flowerImageView.image = UIImage(named: flower.name)
                xPos += 100

            }
        } catch {
            print("Error getting heaven view : \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        // TODO: Realm에 저장된 현재 이미지 불러와서 petImageView에 넣기
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func photoButtonPressed(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }

    @IBAction func letterButtonPressed(_ sender: UIButton) {
        // TODO: 편지 리스트뷰로 이동
    }

    @objc func mainTransition() {
        navigationController?.popViewController(animated: true)
    }
}

extension HeavenViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.petImageView.image = image as? UIImage
                }
            }
        }
        // TODO: Realm에 image 추가
    }
}
