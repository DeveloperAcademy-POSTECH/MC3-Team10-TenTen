// collectionView 안에 들어갈 인자를 넣는 뷰
// 데이터를 받아오는 뷰
import UIKit

class InterestViewController : UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBAction func pageChange(_ sender: UIPageControl) {

    }
    // 데이터를 인스턴스로 받아온다.
    var interests = Interest.fetchInterests()
    var currentIdx: CGFloat = 0.0
    var previousCellIndex = 0
    var nextCellIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        pageControl.numberOfPages = interests.count
//        pageControl.currentPage = 0
        // 셀의 사이즈 설정
        let screenSize = UIScreen.main.bounds.size // superView 의 스크린 사이즈
        let cellWidth = floor(210)
        let cellHeight = floor(522)
        let insetX = (view.bounds.width - cellWidth) / 2.0 // 90
        // minimumLineSpacing, itemSize 메소드를 사용하기 위해서 다운캐스팅
        let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout
        layout!.itemSize = CGSize(width: cellWidth, height: cellHeight) // 셀의 사이즈
        layout!.minimumLineSpacing = 37      // 옆셀과의 거리
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 104, right: insetX)
        // 컨텐츠의 여백 길이를 설정함으로 옆의 셀이 얼마나 나올지를 보여준다.
        // 컬렉션 뷰에게 데이터 소스를 제공해 주는 메소드
        // collectiomView의 dataSource는 이 class임을 알려주는
        // 문장이다.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    // 컬렉션뷰에 필요한 데이터 및 뷰를 제공하기 위한 기능을 정의한 프로토콜입니다.
    // 기존 객체를 수정하지 않고 프로토콜을 구현하기 위해
    // extension 사용
    }
    extension InterestViewController: UICollectionViewDataSource {
        // collrctionView의 색션 갯수를 return
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        // 한 색션에 몇가지 아이템이 있는지 return
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return interests.count
        }
        func collectionView
        (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCollectionViewCell", for: indexPath)
         as? InterestCollectionViewCell
            let interest = interests[indexPath.item]
            cell!.interest = interest
            return cell!
        }
    }
    extension InterestViewController: UIScrollViewDelegate, UICollectionViewDelegate {

    func scrollViewWillEndDragging
        (_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
         targetContentOffset: UnsafeMutablePointer<CGPoint>) {
             let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
            let cellWidthIncludingSpacing =  layout!.itemSize.width + layout!.minimumLineSpacing

            // targetContentOffset
           // 스크롤 동작이 정지할 때 예상되는 오프셋입니다.
            var offset = targetContentOffset.pointee // 움직인 x 좌표값을 받기위해 설정
            let index = (offset.x + scrollView.contentInset.left ) / cellWidthIncludingSpacing
            // 움직인 크기가 cellWidthIncludingSpacing을 넘어가면 index 변경
            if index > currentIdx {
                currentIdx += 1
            } else if index < currentIdx {
                if currentIdx != 0 {
                    currentIdx -= 1
                }
            }
            // 얼마나 넘어갈지 알려주는 명령어인데 왜 내가 설정한 만큼만 넘어가지않는건데ㅠㅠㅠ
            offset = CGPoint(x: currentIdx * cellWidthIncludingSpacing - scrollView.contentInset.left, y: 0)
            // 스크롤을 햇을때 정지할 offset
            targetContentOffset.pointee = offset

    }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // 위에와 같이 하나의 스크린 크기
            guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            let cellWidthIncludeSpacing = layout.itemSize.width + layout.minimumLineSpacing
            let offsetX = collectionView.contentOffset.x
            let index = (offsetX + collectionView.contentInset.left) / cellWidthIncludeSpacing
            let roundedIndex = round(index)
            print("roundedIndex\(roundedIndex)")
            print("previousCellIndex\(previousCellIndex)")
            print("nextCellIndex\(nextCellIndex)")
            // 줌 하는 현재 셀
            let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) {
                zoomFocusCell(cell: cell, isFocus: true)
            }
            //
            if Int(roundedIndex) == Int(roundedIndex) {
                let preIndexPath = IndexPath(item: previousCellIndex, section: 0)
                if let preCell = collectionView.cellForItem(at: preIndexPath) {
                    zoomFocusCell(cell: preCell, isFocus: false)
                }
                previousCellIndex = indexPath.item - 1
            }

            if Int(roundedIndex) == Int(roundedIndex) {
                let nextIndexPath = IndexPath(item: nextCellIndex, section: 0)
                if let nextCell = collectionView.cellForItem(at: nextIndexPath) {
                    zoomFocusCell(cell: nextCell, isFocus: false)
                }
                nextCellIndex = indexPath.item + 1
            }
        }

        private func zoomFocusCell(cell: UICollectionViewCell, isFocus: Bool ) {
             UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                 if isFocus {
                     cell.transform = .identity
                 } else {
                     cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                 }
             }, completion: nil)
         }

}
