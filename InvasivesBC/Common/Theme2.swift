//
//  Theme2.swift
//  InvasivesBC
//
//  Created by Amir Shayegh on 2020-07-24.
//  Copyright © 2020 Government of British Columbia. All rights reserved.
//

import Foundation
import UIKit

extension Theme {
    
    // MARK: Colors
    // Gradiant UIView
    public func setGradiantBackground(view: UIView) {
        setGradientBackground(view: view, colorOne: UIColor(hex: "#0053A4"), colorTwo: UIColor(hex:"#002C71"));
    }
    
    // Gradiant Navbar
    public func setGradiantBackground(navigationBar: UINavigationBar) {
        setGradiantBackground(navigationBar: navigationBar, colorOne: UIColor(hex:"#002C71"), colorTwo: UIColor(hex: "#0053A4"))
    }
    
    // MARK: Fonts
    public func getSubHeaderFont() -> UIFont {
        return UIFont.bold(size: 17)
    }
    
    public func getInputFieldFont() -> UIFont {
        return UIFont.bold(size: 15)
    }
    
    public func getSwitcherFont() -> UIFont {
        return UIFont.bold(size: 15)
    }
    
    // MARK: Label Text
    
    // Body
    public func styleBody(label: UILabel, darkBackground: Bool? = false) {
        label.textColor = darkBackground ?? false ? UIColor.white : UIColor.bodyText
        label.font = UIFont.regular(size: 15)
    }
    
    // Sub-header
    public func styleSubHeader(label: UILabel, darkBackground: Bool? = false) {
        label.textColor = darkBackground ?? false ? UIColor.white : UIColor.bodyText
        label.font = getSubHeaderFont()
        label.change(kernValue: -0.52)
        label.adjustsFontSizeToFitWidth = true
    }
    
    // Input field header
    public func styleFieldHeader(label: UILabel) {
        label.textColor = UIColor.inputHeaderText
        label.font = UIFont.bold(size: 14)
        label.adjustsFontSizeToFitWidth = true
    }
    
    // Input field content
    private func styleFieldInput(textField: UITextField) {
        textField.textColor = UIColor.inputText
        textField.backgroundColor = UIColor.inputBackground
        textField.font = getInputFieldFont()
        textField.layer.cornerRadius = 3
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.inputBackground.cgColor
    }
    
    private func styleFieldInputReadOnly(textField: UITextField) {
        textField.textColor = UIColor.inputText
        textField.backgroundColor = .clear
        textField.font = getInputFieldFont()
        textField.layer.cornerRadius = 0
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    public func styleInput(field: UITextField, header: UILabel, editable: Bool) {
        if editable {
            styleFieldInput(textField: field)
            styleFieldHeader(label: header)
        } else {
            styleFieldHeader(label: header)
            styleFieldInputReadOnly(textField: field)
        }
        
    }
    
    // Input field content
    public func styleFieldInput(textField: UITextView) {
        textField.textColor = UIColor.inputText
        textField.backgroundColor = UIColor.inputBackground
        textField.font = getInputFieldFont()
        textField.layer.cornerRadius = 3
        textField.layer.borderColor = UIColor.inputBackground.cgColor
    }
    
    // Form Section title
    public func styleSectionTitle(label: UILabel) {
        label.textColor = UIColor.primary
        label.font = UIFont.bold(size: 22)
    }
    
    // MARK: Buttons
    public func styleHollowButton(button: UIButton) {
        styleButton(button: button, bg: UIColor.white, borderColor: UIColor.primary.cgColor, titleColor: UIColor.primary)
        button.tintColor = UIColor.primary
    }
    
    public func styleDisable(button: UIButton) {
        styleButton(button: button, bg: UIColor.white, borderColor: UIColor.gray.cgColor, titleColor: UIColor.gray)
    }
    
    public func styleFillButton(button: UIButton) {
        styleButton(button: button, bg: UIColor.primary, borderColor: UIColor.primary.cgColor, titleColor: UIColor.white)
        if let label = button.titleLabel {
            label.font = UIFont.regular(size: 17)
        }
    }
    
    private func styleButton(button: UIButton, bg: UIColor, borderColor: CGColor, titleColor: UIColor) {
        button.layer.cornerRadius = 5
        button.backgroundColor = bg
        button.layer.borderWidth = 1
        button.layer.borderColor = borderColor
        button.setTitleColor(titleColor, for: .normal)
    }
    
    // MARK: View & Layer
    public func roundCorners(layer: CALayer) {
        layer.cornerRadius = 8
    }
    
    public func styleCard(layer: CALayer) {
        roundCorners(layer: layer)
        addShadow(to: layer, opacity: 08, height: 2)
    }
    
    public func styleDivider(view: UIView) {
        view.backgroundColor = UIColor.secondary
    }
    public func styleDividerGrey(view: UIView) {
        view.backgroundColor = UIColor.Status.LightGray
    }
}
