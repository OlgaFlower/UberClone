//
//  LocationInputView.swift
//  UberClone
//
//  Created by Olha Bereziuk on 15.02.2021.
//

import UIKit

protocol LocationInputViewDelegate: class {
    func dismissLocationInputView()
}

class LocationInputView: UIView {
    
    // MARK: - Properties
    weak var delegate: LocationInputViewDelegate?
    
    //Back button
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage( #imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal) //prevent default blue tint
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    //Title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stephan Dowless"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    //start indicator
    private let startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
     
    //link indicator
    private let linkingView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    //finish indicator
    private let destinationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    //start text field
    private lazy var startingLocationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Current Location"
        textfield.backgroundColor = .systemGroupedBackground
        textfield.isEnabled = false
        textfield.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        
        return textfield
    }()
    
    //finish text field
    private lazy var destinationLocationTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter a destination.."
        textfield.backgroundColor = .lightGray
        textfield.returnKeyType = .search
        textfield.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.setDimensions(height: 30, width: 8)
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        
        return textfield
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addShadow()
        backgroundColor = .white
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor,
                          paddingTop: 44, paddingLeft: 12,
                          width: 24, height: 25)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
        
        addSubview(startingLocationTextfield)
        startingLocationTextfield.anchor(top: backButton.bottomAnchor, left: leftAnchor,
                                         right: rightAnchor, paddingTop: 4, paddingLeft: 40,
                                         paddingRight: -40, height: 30)
        
        addSubview(destinationLocationTextfield)
        destinationLocationTextfield.anchor(top: startingLocationTextfield.bottomAnchor, left: leftAnchor,
                                         right: rightAnchor, paddingTop: 12, paddingLeft: 40,
                                         paddingRight: -40, height: 30)
        
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.centerY(inView: startingLocationTextfield, leftAnchor: leftAnchor,
                                           paddingLeft: 20)
        startLocationIndicatorView.setDimensions(height: 6, width: 6)
        startLocationIndicatorView.layer.cornerRadius = 6 / 2
        
        addSubview(destinationIndicatorView)
        destinationIndicatorView.centerY(inView: destinationLocationTextfield, leftAnchor: leftAnchor,
                                           paddingLeft: 20)
        destinationIndicatorView.setDimensions(height: 6, width: 6)
        
        addSubview(linkingView)
        linkingView.centerX(inView: startLocationIndicatorView)
        linkingView.anchor(top: startLocationIndicatorView.bottomAnchor,
                           bottom: destinationIndicatorView.topAnchor,
                           paddingTop: 4, paddingBottom: -4, width: 0.5)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleBackTapped() {
        delegate?.dismissLocationInputView()
    }
}
