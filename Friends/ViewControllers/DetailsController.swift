//
//  DetailsController.swift
//  Friends
//
//  Created by Tasia Mosahid on 21/5/21.
//

import UIKit

class DetailsController: UIViewController {
    
    var selectedFriend : FriendModel?

    @IBOutlet weak var cellPhone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var cityStateCountry: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeImageCircular()
        self.setupData()
    }
    
    func makeImageCircular() {
        picture.layer.borderWidth = 1.0
        picture.layer.masksToBounds = false
        picture.layer.borderColor = UIColor.white.cgColor
        picture.layer.cornerRadius = self.picture.frame.width / 2
        picture.clipsToBounds = true
    }
    
    func setupData() {
        guard let model = selectedFriend else {
            return
        }
        if let thumb = model.pictureThumb {
            Utils.downloadImage(from: thumb) { data in
                if let data = data {
                    DispatchQueue.main.async() { [weak self] in
                                self?.picture.image = UIImage(data: data)
                            }
                    
                }
                
            }
        }
        self.fullName.text = model.fullName
        self.address.text = model.address
        if let city = model.city {
            if let state = model.state {
                if let country = model.country {
                    self.cityStateCountry.text = city + ", " + state + ", " + country
                } else {
                    self.cityStateCountry.text = city + ", " + state
                }
            } else {
                if let country = model.country {
                    self.cityStateCountry.text = city + ", " + country
                } else {
                    self.cityStateCountry.text = city
                }
            }
        } else {
            if let state = model.state {
                if let country = model.country {
                    self.cityStateCountry.text = state + ", " + country
                } else {
                    self.cityStateCountry.text = state
                }
            } else {
                if let country = model.country {
                    self.cityStateCountry.text = country
                } else {
                    self.cityStateCountry.text = AppConstants.AlertMessages.infoNotAvailable
                }
            }
        }
        self.email.text = model.email
        self.cellPhone.text = model.cellPhone
        
    }

}
