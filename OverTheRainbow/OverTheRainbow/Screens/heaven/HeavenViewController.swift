//
//  HeavenViewController.swift
//  OverTheRainbow
//
//  Created by 김승창 on 2022/07/20.
//

import PhotosUI
import UIKit

class HeavenViewController: UIViewController {

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var frameImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // todo: 배경 바꾸기
        self.view.backgroundColor = UIColor(named: "heavenLetterBackgroundColor")

        drawPictureFrame()
    }

    @IBAction func petImageButtonPressed(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }

    private func drawPictureFrame() {
        UIGraphicsBeginImageContext(frameImageView.frame.size)

        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(20.0)
        context.setStrokeColor(UIColor.white.cgColor)

        let pictureFrame = CGRect(x: 0, y: 0, width: 250, height: 270)
        context.addRect(pictureFrame)
        context.strokePath()

        frameImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
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
        // todo: Realm Model에 image 추가
    }
}
