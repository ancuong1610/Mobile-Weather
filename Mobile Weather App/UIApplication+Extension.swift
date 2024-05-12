//
//  UIApplication+Extension.swift
//  Mobile Weather App
//
//  Created by Cg kon on 12.05.24.
//

import UIKit

extension UIApplication{
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
