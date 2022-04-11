//
//  ResultTableViewCell.swift
//  CityWeatherApp
//
//  Created by Andrew_Alekseyuk on 6.04.22.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var shevron: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        savedLabel.backgroundColor = .purple
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        savedLabel.isHidden = true
        savedLabel.backgroundColor = .purple
        spinner.hidesWhenStopped = true
        
        if #available(iOS 13.0, *) {
            spinner.style = .medium
            shevron.image = UIImage(systemName: "chevron.right")!
            shevron.tintColor = .label
        } else {
            spinner.color = .systemGray
            shevron.image = UIImage(named: "chervon")!
        }
    }
}
