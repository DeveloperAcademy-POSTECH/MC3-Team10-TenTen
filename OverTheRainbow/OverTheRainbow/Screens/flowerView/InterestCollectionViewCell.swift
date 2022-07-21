// collectionView에 들어갈 outlet label을 위한 뷰
import UIKit

class InterestCollectionViewCell: UICollectionViewCell {
    // CollectionView의 outlet을 만든다.
    @IBOutlet weak var flowerImageView: UIImageView!
    @IBOutlet weak var flowerMeans: UILabel!
    @IBOutlet weak var flowerTitleLabel: UILabel!
    @IBOutlet weak var backgroundLabel: UIView!
    @IBOutlet weak var boxLabel: UIView!

    // set 되었을때 interest에서 정보를 가지고 오기위해서
    var interest: Interest! {
        didSet {
            self.updateUI()
        }
    }
    func updateUI() {
        if let interest = interest {
            flowerImageView.image = interest.flowerImage
            flowerTitleLabel.text = interest.label
            flowerMeans.text = interest.means
        }
        backgroundLabel.layer.cornerRadius = 15.0
//        backgroundLabel.layer.masksToBounds = true[.layerMinXMinYCorner, .layerMaxXMinYCorner]
        boxLabel.layer.cornerRadius = 15.0
        boxLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
}
