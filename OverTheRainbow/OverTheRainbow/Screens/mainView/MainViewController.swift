//
//  MainViewController.swift
//  OverTheRainbow
//
//  Created by Hyorim Nam on 2022/07/19.
//

import UIKit
//import RealmSwift
class MainViewController: UIViewController {
    var numberOfLetters: Int = 0
    var pickedFlower: FlowerResultDto?
    var didFlowerToday: Bool = false
    var petID: String?
    let service = DataAccessProvider.dataAccessConfig.getService()
    var userData: MainViewResultDto?

    @IBOutlet weak var flowerBoxView: FlowerBoxView!
    @IBOutlet weak var letterBoxView: LetterBoxView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!

    override func viewDidLoad() {
//        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        super.viewDidLoad()
        petID = UserDefaults.standard.string(forKey: "petID")
        if petID != nil {
            userData = try? service.getMainView(petID!)
        }
        quoteLabel.text = userData?.word.content ?? "DEBUG word 없음"

        [guideLabel, quoteLabel].forEach {
            $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
        }
        setIfFlowerPickedToday()
    }

    override func viewWillAppear(_ animated: Bool) {
        // 네비바 감추고 보이기 레퍼런스: https://stackoverflow.com/a/29953818/6183323
        navigationController?.setNavigationBarHidden(true, animated: animated)

        // 세팅뷰에서
        petID = UserDefaults.standard.string(forKey: "petID")

        // 렘에서 정보 받기
        if petID != nil {
            userData = try? service.getMainView(petID!)
        }
        pickedFlower = userData?.flower
        numberOfLetters = userData?.letterCount ?? 0

        // 정보에 따라 박스에 보이는 정보 업데이트
        flowerBoxView.updatePreview(flower: pickedFlower, didFlowerToday: didFlowerToday)
        letterBoxView.updatePreview(numberOfLetter: numberOfLetters)
    }
    override func viewWillDisappear(_ animated: Bool) {
        // 네비바 감추고 보이기 레퍼런스: https://stackoverflow.com/a/29953818/6183323
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func flowerBoxTapped(_ sender: UITapGestureRecognizer) {
        if petID == nil {
            petRegisterGuideAlert()
        } else {
            navigateToStoryboardVC("FLOWERVIEW")
        }
    }
    @IBAction func letterBoxTapped(_ sender: UITapGestureRecognizer) {
        if petID == nil {
            petRegisterGuideAlert()
        } else {
            navigateToStoryboardVC("LETTERVIEW")
        }
    }
    @IBAction func heavenTransitionButton(_ sender: UIButton) {
        if petID == nil {
            petRegisterGuideAlert()
        } else {
            heavenTransition()
        }
    }
    @IBAction func heavenTransitionGesture(_ sender: UISwipeGestureRecognizer) {
        if petID == nil {
            petRegisterGuideAlert()
        } else {
            heavenTransition()
        }
    }
}

// 뷰 이동 관련 메소드 모음
extension MainViewController {
    // 펫 정보가 없을 때 안내 가이드 띄우기
    private func petRegisterGuideAlert() {
        let guideAlert = UIAlertController(
            title: "추모할 반려동물의\n정보를 입력해주세요",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        let offAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default)
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { _ in
            self.navigateToStoryboardVC("SETTINGVIEW")
        })
        guideAlert.addAction(offAction)
        guideAlert.addAction(okAction)
        present(guideAlert, animated: true, completion: nil)
    }

    // 버튼이나 제스쳐로 천국뷰로 이동할 때 조건에 따라 안내 문구를 표시하거나, 오늘 헌화한 상태를 업데이트
    // ref: https://moonibot.tistory.com/23
    private func heavenTransition() {
        // debug
        // alertCondition(didFlowerToday: &didFlowerToday, pickedFlowerIndex: &pickedFlowerIndex)

        if !didFlowerToday && (pickedFlower == nil) {
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

            try? service.send(petID ?? "DEBUG REQUIRED")

            navigateToStoryboardVC("HeavenView")
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
}

// 유틸 함수 모음
extension MainViewController {
    // 오늘 날짜를 yyyyMMdd 스트링으로 받기
    private func todayStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: Date())
    }

    // 연결할 스토리보드 뷰컨트롤러 설정
    // ref: https://m.blog.naver.com/horajjan/220622322609
    private func navigateToStoryboardVC(_ viewControllerName: String) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: viewControllerName) {
            viewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

#if DEBUG
// DebugFunc
func clearUserDefault() {
    let key = "flowerPickedToday"
    UserDefaults.standard.removeObject(forKey: key)
}
func alertCondition(didFlowerToday: inout Bool, pickedFlower: inout FlowerResultDto?) {
    didFlowerToday = false
    pickedFlower = nil
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
