//
//  WritingLetterViewController.swift
//  OverTheRainbow
//
//  Created by SeungHwanKim on 2022/07/25.
//

import UIKit
import Photos
import PhotosUI

class WritingLetterViewController: UIViewController {
    
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
        writingLetterNavBar.title = "편지 작성"

        let attributes: [NSAttributedString.Key: Any] = [ .font: UIFont.boldSystemFont(ofSize: 18) ]
        navBarRightItem.setTitleTextAttributes(attributes, for: .normal)

        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setTitle("취소", for: .normal)
//        button.sizeToFit()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
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
        letterTitle.delegate = self
        letterTitle.returnKeyType = .done

        letterContent.delegate = self
        letterContent.text = "어떤 말을 전하고 싶나요?"
        letterContent.textColor = UIColor.lightGray

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy.MM.dd"
        writingDate.text = dateFormatter.string(from: date)

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    @IBAction func doneWritingLetter(_ sender: UIBarButtonItem) {
        print("작성을 완료했습니다.")
        dismiss(animated: true)
    }

    @objc func dismissKeyboard() {
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

extension WritingLetterViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if !textView.text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    } // 텍스트 뷰에 포커스 잡히면 원래 있던 글자가 placeholder 처럼 작동하도록 변경

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "어떤 말을 전하고 싶나요?"
            textView.textColor = UIColor.lightGray
        }
    } // 텍스트 뷰가 비어있으면 placeholder 유지
}

extension WritingLetterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.letterTitle {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

@available(iOS 14, *)
extension WritingLetterViewController: PHPickerViewControllerDelegate {
    @objc func pickImage(sender: UIButton) {
        selectPicture = sender
        var configuration = PHPickerConfiguration()

        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        dismissKeyboard() // 편지 작성하다가도 사진 불러오기 버튼 누르면 키보드 사라지도록 변경
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider

        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, _) in
                DispatchQueue.main.async {
                    self.openGallery.image = image as? UIImage
                    self.openGallery.contentMode = .scaleAspectFill
                    if (image) != nil {
                        self.selectPicture.setImage(UIImage(), for: .normal)
                    }
                }
            }
        }
    }
}
