//
//  ImagesTableViewCell.swift
//  thoughtctltest
//
//  Created by Abhishek Dhamdhere on 10/09/23.
//

import UIKit

class ImagesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var datelabel: UILabel!
    var representedAssetIdentifier: String? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
