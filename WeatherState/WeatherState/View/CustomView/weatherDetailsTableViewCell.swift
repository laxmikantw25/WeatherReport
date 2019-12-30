//
//  weatherDetailsTableViewCell.swift
//  WeatherState
//
//  Created by SDB01 on 28/12/19.
//

import UIKit

class weatherDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
