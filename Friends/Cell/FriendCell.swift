//
//  FriendCell.swift
//  Friends
//
//  Created by Tasia Mosahid on 21/5/21.
//

import UIKit

class FriendCell: UICollectionViewCell {

    @IBOutlet weak var pictureWidth: NSLayoutConstraint!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        makeCircular()
    }
    func makeCircular() {
        picture.layer.borderWidth = 1.0
        picture.layer.masksToBounds = false
        picture.layer.borderColor = UIColor.white.cgColor
        picture.layer.cornerRadius = CGFloat(AppConstants.CollectionCellDesignConstants.baseImageWidth / 2)
        picture.clipsToBounds = true
    }
    
    func resetData() {
        self.picture.image = nil
        self.nameLabel.text = ""
        self.countryLabel.text = ""
    }
    
    func setData(model : FriendModel)  {
        //ImageView width Calculation using base design sizes with respect to the dynamic cellSize
        self.pictureWidth.constant = CGFloat(AppConstants.CollectionCellDesignConstants.baseImageWidth) * (self.frame.width/CGFloat(AppConstants.CollectionCellDesignConstants.baseCellWidth))
        picture.layer.cornerRadius = self.pictureWidth.constant / 2
        if let thumb = model.pictureThumb {
            Utils.downloadImage(from: thumb) { data in
                if let data = data {
                    DispatchQueue.main.async() { [weak self] in
                                self?.picture.image = UIImage(data: data)
                            }
                    
                }
                
            }
        }
        self.nameLabel.text = model.fullName
        self.countryLabel.text = model.country
        
    }
        
        
    

}
