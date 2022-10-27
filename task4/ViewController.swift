//
//  ViewController.swift
//  task4
//
//  Created by Volosandro on 26.10.2022.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell
{
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image: UIImage)
    {
        self.imageView.image = image
    }
}

final class ViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: - Constants
    private let cellID = "UICollectionViewCellID"
    private let defaultCellSize = CGSize(width: 50, height: 50)
    
    // MARK: - Variables
    private var photoView = UIImageView()
    private var images: [UIImage] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillImagesArray()
        self.addSubviews()
    }
    
    // MARK: - Configure
    func addSubviews() {
        self.addCollectionView()
        //self.addPhotoViewController()
        self.addPhotoView()
    }
    
    func fillImagesArray()
    {
        self.images = Array(repeating: UIImage(named: "photo") ?? .remove,
                            count: Int.random(in: 5000...10000))
    }
    
    func addCollectionView()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: self.view.frame,
                                              collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: self.cellID)
        collectionView.contentSize = self.view.frame.size
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(collectionView)
        
        self.addConstraint(firstItem: self.view,
                           secondItem: collectionView)
    }
    
    func addPhotoView()
    {
        self.photoView = UIImageView(frame: self.view.frame)
        self.photoView.isHidden = true
        self.photoView.contentMode = .scaleAspectFit
        self.photoView.backgroundColor = .black
        self.photoView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                   action: #selector(closeImage)))
        self.view.addSubview(self.photoView)
        
        self.addConstraint(firstItem: self.view,
                           secondItem: self.photoView)
    }

    func addConstraint(firstItem: UIView, secondItem: UIView)
    {
        for attribute: NSLayoutConstraint.Attribute in [.top, .bottom, .trailing, .leading]
        {
            self.view.addConstraint(NSLayoutConstraint(item: firstItem,
                                                       attribute: attribute,
                                                       relatedBy: .equal,
                                                       toItem: secondItem,
                                                       attribute: attribute,
                                                       multiplier: 1,
                                                       constant: 0))
        }
    }
    
    // MARK: - Actions
    func showImage(image: UIImage)
    {
        self.photoView.image = image
        self.photoView.isUserInteractionEnabled = true
        self.changePhotoVisibility(setHidden: false)
    }
    
    func changePhotoVisibility(setHidden: Bool)
    {
        weak var weakSelf = self
        UIView.transition(with: self.photoView,
                          duration: 0.2,
                          options: .transitionCrossDissolve) {
            weakSelf?.photoView.isHidden = setHidden
        }
    }
    
    @objc func closeImage()
    {
        self.photoView.image = nil
        self.photoView.isUserInteractionEnabled = false
        self.changePhotoVisibility(setHidden: true)
    }
    
    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showImage(image: self.images[indexPath.row])
    }
}

// MARK: - Extensions
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellID,
                                                      for: indexPath) as! PhotoCollectionViewCell
        
        cell.setImage(image: self.images[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.defaultCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
