//
//  WritingLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/25.
//

import UIKit
import Photos
import PhotosUI

class WritingLetterViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var writingLetterNavBar: UINavigationItem!
    @IBOutlet weak var navBarRightItem: UIBarButtonItem!
    @IBOutlet weak var openGallery: UIImageView!
    @IBOutlet weak var letterTitle: UITextField!
    @IBOutlet weak var letterContent: UITextView!
    @IBOutlet weak var writingDate: UILabel!
    @IBOutlet weak var selectPicture: UIButton!
    var button = UIButton(type: .system)
    let date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        writingLetterNavBar.title="편지 작성"

        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("취소", for: .normal)
        button.sizeToFit()
        button.tintColor = UIColor(named: "textColor")
        writingLetterNavBar.leftBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        openGallery.layer.cornerRadius = 10

        let largeSymbol = UIImage.SymbolConfiguration(pointSize: 86, weight: .bold, scale: .large)
        let largeBoldButton = UIImage(systemName: "plus.square.dashed", withConfiguration: largeSymbol)

        selectPicture.setImage(largeBoldButton, for: .normal)
        selectPicture.tintColor = UIColor(named: "textColor")
        selectPicture.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        letterTitle.placeholder = "제목을 작성해주세요"

        letterContent.delegate = self
        letterContent.text = "어떤 말을 전하고 싶나요?"
        letterContent.textColor = UIColor.lightGray

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy.MM.dd"
        writingDate.text = dateFormatter.string(from: date)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false

            view.addGestureRecognizer(tap)
        }

    @IBAction func doneWritingLetter(_ sender: UIBarButtonItem) {
        print("작성을 완료했습니다.")
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @objc func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let first = UIAlertAction(title: "임시 저장", style: .default) {
            action in print("1")
            self.dismiss(animated: true)
        }
        let second = UIAlertAction(title: "임시저장 삭제", style: .destructive) {
            action in print("2")
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel){action in}

        actionSheet.addAction(first)
        actionSheet.addAction(second)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
}

extension ViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "일반 TextView 입니다."
            textView.textColor = UIColor.lightGray
        }
    }
}

@available(iOS 14, *)
extension WritingLetterViewController: PHPickerViewControllerDelegate {
    @objc func pickImage(sender: UIButton) {
        selectPicture = sender
        var configuration = PHPickerConfiguration()
//    이미지 정보를 가지고 올 필요가 있을땐 photolibarary 를 사용해준다. //use when need image file info.
//            let photoLibrary = PHPhotoLibrary.shared()
//            var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)

        configuration.selectionLimit = 1 //한번에 가지고 올 이미지 갯수 제한 //limit selectable image counts
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        var imgData: Data?
        var img: UIImage?


        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider

        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) {
                (image, error) in
                DispatchQueue.main.async {
                    self.openGallery.image = image as? UIImage
                }
            }
        }
    }
}
