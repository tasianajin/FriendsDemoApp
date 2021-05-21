//
//  ViewController.swift
//  Friends
//
//  Created by Tasia Mosahid on 21/5/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    var friendArray : [FriendModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        let friendNib = UINib(nibName: AppConstants.Cells.FriendCell, bundle: nil)
        self.collectionView.register(friendNib, forCellWithReuseIdentifier: AppConstants.Cells.FriendCell)
        friendArray = [FriendModel]()
        messageLabel.isHidden = false
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        getData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func rotated() {
        if activityIndicator.isHidden {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func generateData() {
        friendArray = [FriendModel]()
        for _ in 0...AppConstants.numberOfFriends {
            getData()
        }
    }
    
    func getData() {
        
        Utils.sendRequest(AppConstants.friendsUrl) {
            responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                print(error ?? "Unknown error")
                DispatchQueue.main.async() { [weak self] in
                    let alert = Utils.showAlert(header: "Error", message: AppConstants.AlertMessages.errorMessage)
                    self?.messageLabel.isHidden = true
                    self?.activityIndicator.stopAnimating()
                    self?.collectionView.reloadData()
                    self?.present(alert, animated: true, completion: nil)
                }
                
                return
            }
            print(responseObject)
            if let results = responseObject["results"] as? [[String : Any]] , let result = results.first {
                let friendModel = FriendModel()
                friendModel.parseData(dictionary : result)
                print(friendModel)
                self.friendArray?.append(friendModel)
                
                DispatchQueue.main.async() { [weak self] in
                    
                    guard let array = self?.friendArray else {
                       return
                    }
                    if(array.count < AppConstants.numberOfFriends) {
                        self?.getData()
                    } else {
                        self?.messageLabel.isHidden = true
                        self?.activityIndicator.stopAnimating()
                        self?.collectionView.reloadData()
                    }
            }
            
        }
        
        }
       
    }
    


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let friendArray = friendArray else {
            return 0
        }
        return friendArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cells.FriendCell, for: indexPath) as? FriendCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cells.FriendCell, for: indexPath)

            return cell
        }
        guard  let friendArray = friendArray else {
            return cell
        }
        let friend = friendArray[indexPath.row]
        //resetting data as we are reusing cells
        cell.resetData()
        //setup model data to cell ux
        cell.setData(model: friend)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let details = storyboard.instantiateViewController(withIdentifier: AppConstants.ViewControllers.DetailsViewController) as? DetailsController else {
            return
        }
        guard  let friendArray = friendArray else {
            return
        }
        details.selectedFriend = friendArray[indexPath.row]
        self.present(details, animated: true, completion: nil)
        
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = CGFloat(AppConstants.CollectionViewSettings.numberOfColumns)
        let spacing: CGFloat = CGFloat(AppConstants.CollectionViewSettings.spacing)
        let totalHorizontalSpacing = (columns - 1) * spacing

        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)

        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(AppConstants.CollectionViewSettings.spacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(AppConstants.CollectionViewSettings.spacing)
    }
}
