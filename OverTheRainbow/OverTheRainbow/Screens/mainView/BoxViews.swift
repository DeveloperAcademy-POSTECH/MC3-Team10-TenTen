//
//  BoxStyleView.swift
//  OverTheRainbow
//
//  Created by Hyorim Nam on 2022/07/19.
//

import UIKit

class FlowerBoxView: BoxStyleView, BoxStyle {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // 프리뷰 업데이트시 필요한 프로퍼티
    let stackView = UIStackView()
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var floriographyLabel = UILabel() // 꽃말
    let noFlowerGuideLabel = UILabel()

    func commonInit() {
        setBarTitle(titleText: "Flower")
        let previewView = UIView()

        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 0.0

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(floriographyLabel)

        [nameLabel, floriographyLabel].forEach {
            $0.adjustsFontForContentSizeCategory = true
            $0.textAlignment = .center
            $0.frame.size = $0.intrinsicContentSize
        }
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        floriographyLabel.font = UIFont.preferredFont(forTextStyle: .body)

        noFlowerGuideLabel.adjustsFontForContentSizeCategory = true
        noFlowerGuideLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        noFlowerGuideLabel.text = "오늘의 꽃을 골라주세요."
        noFlowerGuideLabel.textAlignment = .center
        noFlowerGuideLabel.lineBreakMode = .byWordWrapping

        previewView.addSubview(stackView)
        previewView.addSubview(noFlowerGuideLabel)

        imageView.contentMode = .scaleAspectFit

        stackView.translatesAutoresizingMaskIntoConstraints = false
        noFlowerGuideLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.7),
            stackView.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: previewView.centerYAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: previewView.widthAnchor),
            stackView.topAnchor.constraint(lessThanOrEqualTo: previewView.topAnchor, constant: 16),
            noFlowerGuideLabel.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            noFlowerGuideLabel.centerYAnchor.constraint(equalTo: previewView.centerYAnchor, constant: -16)
        ])

        setPreviewView(previewView: previewView)
    }

    // 꽃 이미지, 꽃 이름, 꽃말 업데이트
    func updatePreview(flowerIndex: Int?, didFlowerToday: Bool = false) {
        if flowerIndex == nil {
            stackView.alpha = 0
            if didFlowerToday {
                noFlowerGuideLabel.text = "헌화를 했습니다."
            } else {
                noFlowerGuideLabel.text = "오늘의 꽃을 골라주세요."
            }
            noFlowerGuideLabel.alpha = 1
        } else {
            stackView.alpha = 1
            noFlowerGuideLabel.alpha = 0

            imageView.image = flowers[flowerIndex ?? 0].image
            nameLabel.text = flowers[flowerIndex ?? 0].title
            floriographyLabel.text = flowers[flowerIndex ?? 0].floriography

            nameLabel.frame.size = nameLabel.intrinsicContentSize
            floriographyLabel.frame.size = floriographyLabel.intrinsicContentSize
        }
    }
}

class LetterBoxView: BoxStyleView, BoxStyle {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    var badgeView = UIImageView()
    var badgeNumberLabel = UILabel()

    func commonInit() {
        setBarTitle(titleText: "Letter")
        let previewView = UIView()
        let envelopeView = UIImageView(image: UIImage(systemName: "envelope"))
        previewView.addSubview(envelopeView)
        envelopeView.addSubview(badgeView)
        badgeView.addSubview(badgeNumberLabel)
        badgeNumberLabel.alpha = 0

        envelopeView.contentMode = .scaleAspectFit
        envelopeView.tintColor = .black
        badgeView.image = UIImage(systemName: "circle.fill")
        badgeView.tintColor = .systemRed
        badgeView.contentMode = .scaleAspectFit
        badgeView.alpha = 0
        badgeNumberLabel.textColor = .white
        badgeNumberLabel.textAlignment = .center

        [envelopeView, badgeView, badgeNumberLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            envelopeView.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            envelopeView.centerYAnchor.constraint(equalTo: previewView.centerYAnchor, constant: 8),
            envelopeView.widthAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: 0.7),
            envelopeView.heightAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: 0.7),
            badgeView.trailingAnchor.constraint(equalTo: envelopeView.trailingAnchor, constant: -2),
            badgeView.topAnchor.constraint(equalTo: envelopeView.topAnchor, constant: 8),
            badgeView.widthAnchor.constraint(equalTo: envelopeView.widthAnchor, multiplier: 0.3),
            badgeView.heightAnchor.constraint(equalTo: envelopeView.widthAnchor, multiplier: 0.3),
            badgeNumberLabel.widthAnchor.constraint(equalTo: badgeView.widthAnchor, multiplier: 0.8),
            badgeNumberLabel.heightAnchor.constraint(equalTo: badgeView.heightAnchor, multiplier: 0.8),
            badgeNumberLabel.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            badgeNumberLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor)
        ])

        setPreviewView(previewView: previewView)
    }

    func updatePreview(numberOfLetter: Int) {
        if numberOfLetter > 0 {
            badgeView.alpha = 1
            badgeNumberLabel.alpha = 1
            // SF symbol 사용시 숫자가 투명하고, 50까지만 있어서 쓰지 않음
            badgeNumberLabel.text = "\(numberOfLetter)"
        } else {
            badgeView.alpha = 0
            badgeNumberLabel.alpha = 0
        }
    }
}

class SettingBoxView: BoxStyleView, BoxStyle {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        setBarTitle(titleText: "Setting")
        let previewView = UIView()
        let imageView = UIImageView(image: UIImage(systemName: "gearshape"))
        previewView.addSubview(imageView)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: 0.7)
        ])
        setPreviewView(previewView: previewView)
    }
}

protocol BoxStyle: UIView {
    func commonInit()
}

// 박스 모양 설정: 배경색, 둥근 모서리, 아래쪽 색깔 바, 제목, 프리뷰(꽃, 편지) 이미지 위치 설정
class BoxStyleView: UIView {

    var colorBar = UIView()
    var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "whiteColor")
        layer.cornerRadius = 15
        setBarColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor(named: "whiteColor")
        layer.cornerRadius = 15
        setBarColor()
    }

    private func setBarColor() {
        colorBar.backgroundColor = UIColor(named: "boxBarColor")
        colorBar.clipsToBounds = true
        colorBar.layer.cornerRadius = 15
        // ref: https://stackoverflow.com/q/31232689/6183323
        colorBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        addSubview(colorBar)

        colorBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colorBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorBar.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.16)
        ])
    }

    fileprivate func setBarTitle(titleText: String = "Test") {
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.text = titleText
        addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: colorBar.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    fileprivate func setPreviewView(previewView: UIView = UIView()) {
        addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            previewView.centerXAnchor.constraint(equalTo: centerXAnchor),
            previewView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            previewView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16)
        ])
    }
}