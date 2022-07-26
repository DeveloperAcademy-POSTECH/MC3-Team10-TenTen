//
//  MainViewController.swift
//  OverTheRainbow
//
//  Created by Hyorim Nam on 2022/07/19.
//

import UIKit

class MainViewController: UIViewController {
    var numberOfLetters: Int = 0
    var pickedFlowerIndex: Int?
    var didFlowerToday: Bool = false

    @IBOutlet weak var flowerBoxView: FlowerBoxView!
    @IBOutlet weak var letterBoxView: LetterBoxView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        quoteLabel.text = quotes[Int.random(in: 0...4)]

        [guideLabel, quoteLabel].forEach {
            $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        }
        setIfFlowerPickedToday()
    }

    // 네비바 감추고 보이기 레퍼런스: https://stackoverflow.com/a/29953818/6183323
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)

        // 렘에서 fetch한 꽃의 인덱스, 편지 숫자
        // random: testing
        pickedFlowerIndex = Int.random(in: 0...4)
        numberOfLetters = Int.random(in: 0...100)

        flowerBoxView.updatePreview(flowerIndex: pickedFlowerIndex, didFlowerToday: didFlowerToday)
        letterBoxView.updatePreview(numberOfLetter: numberOfLetters)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func heavenTransitionButton(_ sender: UIButton) {
        heavenTransition()
    }
    @IBAction func heavenTransitionGesture(_ sender: UISwipeGestureRecognizer) {
        heavenTransition()
    }
}

extension MainViewController {
    // 버튼이나 제스쳐로 천국뷰로 이동할 때 조건에 따라 안내 문구를 표시하거나, 오늘 헌화한 상태를 업데이트합니다.
    // ref: https://moonibot.tistory.com/23
    private func heavenTransition() {
        // debug
        // alertCondition(didFlowerToday: &didFlowerToday, pickedFlowerIndex: &pickedFlowerIndex)

        if !didFlowerToday && (pickedFlowerIndex == nil) {
            let guideAlert = UIAlertController(
                title: "오늘 헌화할 꽃을 선택해주세요",
                message: "추모하러 가기 전에 꽃을 준비해주세요.",
                preferredStyle: UIAlertController.Style.alert)
            let offAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
            guideAlert.addAction(offAction)
            present(guideAlert, animated: true, completion: nil)
        } else {
            if !didFlowerToday {
                updateIfFlowerPickedToday()
            }

            // MARK: 렘에 현재 선택한 꽃 없애기

            // ref: https://m.blog.naver.com/horajjan/220622322609
            if let heavenVC = storyboard?.instantiateViewController(withIdentifier: "HeavenView") {
                heavenVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                navigationController?.pushViewController(heavenVC, animated: true)
            }
        }
    }
    // 천국뷰로 올라갈 때 조건이 맞으면 부르기
    private func updateIfFlowerPickedToday() {
        let key = "flowerPickedToday"
        didFlowerToday = true
        UserDefaults.standard.set([todayStr(): true], forKey: key)
        UserDefaults.standard.synchronize()
    }
    // 앱을 켤 때 유저디폴트를 사용해 오늘 헌화를 했는지 확인
    private func setIfFlowerPickedToday() {
        let key = "flowerPickedToday"
        let info = UserDefaults.standard.object(forKey: key) as? [String: Bool]
        if info?.keys.first != todayStr() {
            UserDefaults.standard.set([todayStr(): false], forKey: key)
            UserDefaults.standard.synchronize()
        } else {
            if let test = info?[todayStr()] {
                didFlowerToday = test
            }
        }
    }
    // 오늘 날짜를 yyyyMMdd 스트링으로 받기
    private func todayStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: Date())
    }
}

#if DEBUG
// DebugFunc
func clearUserDefault() {
    let key = "flowerPickedToday"
    UserDefaults.standard.removeObject(forKey: key)
}
func alertCondition(didFlowerToday: inout Bool, pickedFlowerIndex: inout Int?) {
    didFlowerToday = false
    pickedFlowerIndex = nil
}

// mockupdata
struct FlowerMockUpData {
    let title: String
    let image: UIImage
    let floriography: String
}
let mockUpFlowers = [
    FlowerMockUpData(title: "꽃1", image: UIImage(named: "flower1")!, floriography: "꽃말1, 꽃말1"),
    FlowerMockUpData(title: "꽃2", image: UIImage(named: "flower2")!, floriography: "꽃말2, 꽃말2"),
    FlowerMockUpData(title: "꽃3", image: UIImage(named: "flower3")!, floriography: "꽃말3, 꽃말3"),
    FlowerMockUpData(title: "꽃4", image: UIImage(named: "flower4")!, floriography: "꽃말4, 꽃말4"),
    FlowerMockUpData(title: "꽃5", image: UIImage(named: "flower5")!, floriography: "꽃말5, 꽃말5")
]
let quotes: [String] = [
    "상처를 치료해줄 사람 어디 없나.\n가만히 놔두다간 끊임없이 덧나.",
    "(위로1)상처를 치료해줄 사람 어디 없나.\n가만히 놔두다간 끊임없이 덧나.",
    "(위로2)상처를 치료해줄 사람 어디 없나.\n가만히 놔두다간 끊임없이 덧나.",
    "(투두1)오늘 하늘은 어떤 모양인가요?\n잠시 걸으며 공기의 냄새를 맡아보아요.",
    "오늘 하늘은 어떤 모양인가요?\n잠시 걸으며 공기의 냄새를 맡아보아요."
]

#endif
