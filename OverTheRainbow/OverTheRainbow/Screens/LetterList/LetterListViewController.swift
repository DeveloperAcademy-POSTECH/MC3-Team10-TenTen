//
//  LetterListViewController.swift
//  OverTheRainbow
//
//  Created by Jihye Hong on 2022/07/18.
//

import UIKit

class LetterLitstMainViewController: BaseViewController {
    let petID = UserDefaults.standard.string(forKey: "petID")
    let service = DataAccessProvider.dataAccessConfig.getService()
    var lists: [LetterResultDto] = []
    
    func setLists(_ petID:String) {
        self.lists = (try? service.findUnsentLetters(petID)) ?? []
    }
    
    var letterID: String = ""
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 16.0
        static let collectionVerticalSpacing: CGFloat = 17.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
        static let cellHeight: CGFloat = (UIScreen.main.bounds.size.width - collectionHorizontalSpacing
                                          * 2) / 2
        static let collectionInset = UIEdgeInsets(top: 5,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    private let writingButton = WritingButton()
    
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = Size.collectionInset
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        flowLayout.minimumLineSpacing = 33
        return flowLayout
    }()
    lazy var listCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(LetterCollectionViewCell.self,
                                forCellWithReuseIdentifier: LetterCollectionViewCell.className)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        listCollectionView.reloadData()
        setLists(petID!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listCollectionView.reloadData()
        setupButtonAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func render () {
        view.addSubview(listCollectionView)
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let listCollectionViewConstraints = [
            listCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            listCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 3),
            listCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 3),
            listCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 3),
        ]
        NSLayoutConstraint.activate(listCollectionViewConstraints)
    }
    
    override func configUI() {
        super.configUI()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let writingButtonView = makeBarButtonItem(with: writingButton)
        navigationItem.rightBarButtonItem = writingButtonView
        navigationItem.title = "리스트"
    }

    private func setupButtonAction() {
        let presentSendButtonAction = UIAction { _ in
            let storyboard = UIStoryboard(name: "WritingLetter", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "writeLetter") as? WritingLetterViewController else { return }
            viewController.parentVC = self
            self.navigationController?.modalPresentationStyle = .automatic
            self.present(viewController, animated: true, completion: nil)
        }
        writingButton.addAction(presentSendButtonAction, for: .touchUpInside)
    }
    
    private func pushDetailView(_ letterID: String) {
        let storyBoard = UIStoryboard(name: "WritingLetter", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "writtenLetter") as?  WrittenLetterViewController else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
        viewController.letterID = letterID
        viewController.parentVC = self
    }
}

// MARK: - UICollectionViewDataSource
extension LetterLitstMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lists.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LetterCollectionViewCell =  collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        //        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        cell.setLetterData(with: lists[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension LetterLitstMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushDetailView(lists[indexPath.item].id)
    }
}
