//
//  ImagesCollectionViewCell.swift
//  thoughtctltest
//
//  Created by Abhishek Dhamdhere on 10/09/23.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var datelabel: UILabel!
    var representedAssetIdentifier: String? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
