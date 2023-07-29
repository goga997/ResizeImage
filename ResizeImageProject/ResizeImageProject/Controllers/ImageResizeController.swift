//
//  ImageResizeController.swift
//  DiTatiCuVladu
//
//  Created by Grigore on 12.07.2023.
//

import UIKit
import Photos

//(26.5, 26.5)
//(260.5, 26.5)
//(26.5, 260.5)
//(260.5, 260.5)

/* imag viiew miinX minY cazu 1 //centru
 minX = 39
 minY = 39
 final min x = 10
 final minY = 10
 
 compensez distanta in paralel jos prin a adauga fix aasa valoare width shi height
 */


/*
 cand faci tap pe imagine trebuie sa se miste prin containeruView(alb), sa nu iasa din afara, se misca doar imageVie
 - tap gesture Recognizer
 - touchesBEgan (functions) clasa aparte ca la button
 - swipeGesture Recognizer
 */
class ImageResizeController: UIViewController {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        view.frame = .init(x: 30, y: 250, width: 300, height: 300)
        return view
    }()
    
    private lazy var imageView: ImageViewForPicture = {
        let imageView = ImageViewForPicture(imageController: self)
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        imageView.frame = .init(x: 30, y: 30, width: 240, height: 240)
        return imageView
    }()
    
    private lazy var myLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Please select an Image"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.tintColor = .systemBlue
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var buttonsArray = [UIButton]()
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        
        buttonsArray[0].frame.size = CGSize(width: 24, height: 24)
        buttonsArray[0].center = CGPoint(x: imageView.frame.minX, y: imageView.frame.minY)
        
        
        buttonsArray[1].frame.size = CGSize(width: 24, height: 24)
        buttonsArray[1].center = CGPoint(x: imageView.frame.maxX, y: imageView.frame.minY)
        
        
        buttonsArray[2].frame.size = CGSize(width: 24, height: 24)
        buttonsArray[2].center = CGPoint(x: imageView.frame.minX, y: imageView.frame.maxY)
        
        buttonsArray[3].frame.size = CGSize(width: 24, height: 24)
        buttonsArray[3].center = CGPoint(x: imageView.frame.maxX, y: imageView.frame.maxY)
        
    }
    
    //MARK: - SetUpView + Funcs
    
    private func setUpView() {
        view.backgroundColor = .black
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        
        view.addSubview(myLabel)
        view.addSubview(addButton)
        
        createResisedButtons()
    }
    
    @objc private func addButtonTapped() {
        photoLibraryAcces()
    }
    
    private func photoLibraryAcces() {
        PHPhotoLibrary.requestAuthorization { [weak self] authStatus in
            if authStatus == .authorized {
                DispatchQueue.main.async {
                    let pickerVC = UIImagePickerController()
                    pickerVC.sourceType = .photoLibrary
                    pickerVC.delegate = self
                    pickerVC.allowsEditing = true
                    self?.present(pickerVC, animated: true)
                }
            } else {
                //                print("alert")
                DispatchQueue.main.async {
                    self?.photoLibraryAccesAlertController(title: "NO Acces Permission", message: "Go to settings and allow the app to have permission to acces photo Library")
                }
            }
        }
    }
    
    private func createResisedButtons() {
        for indexButton in 0..<4 {
            let button = ButtonForDrag()
            button.tag = indexButton
            button.backgroundColor = .systemBlue
            button.isUserInteractionEnabled = true
            if indexButton == 0 {
                button.buttonID = .leftTop
            } else if indexButton == 1 {
                button.buttonID = .rightTop
            } else if indexButton == 2 {
                button.buttonID = .leftDown
            } else if indexButton == 3 {
                button.buttonID = .rightDown
            }
            button.addTarget(self, action: #selector(dragResizeButton), for: .allTouchEvents)
            button.layer.cornerRadius = 10
            
            containerView.addSubview(button)
            buttonsArray.append(button)
        }
    }
    
    //MARK: -  dragResizeButton (SWITCH)
    @objc private func dragResizeButton(sender: ButtonForDrag) {
        
        switch sender.buttonID {
            //LEFT TOP
        case .leftTop:
            print(sender.center)
            
            if sender.center.x <= imageView.frame.minX && sender.center.y <= imageView.frame.minY,
               sender.center.x >= imageView.frame.minX && sender.center.y >= imageView.frame.minY {
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1) {
                        
                        let resize = CGSize(width: self.imageView.frame.maxX - sender.center.x,
                                            height: self.imageView.frame.maxY - sender.center.y)
                        
                        self.imageView.frame = .init(x: sender.center.x, y: sender.center.y,
                                                     width: resize.width,
                                                     height: resize.height)
                        
                        self.adjustButtonsForResize()
                        
                        //height = maxY - center.y(sender)
                    }
                    
                }
            }
            
            // LEFT DOWN
        case .leftDown:
            print(sender.center)
            
            if sender.center.x <= imageView.frame.minX && sender.center.y >= imageView.frame.maxY,
               sender.center.x <= imageView.frame.minX && sender.center.y <= imageView.frame.maxY {
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1) {
                        
                        let resize = CGSize(width: self.imageView.frame.maxX - sender.center.x,
                                            height: self.imageView.frame.minY - sender.center.y)
                        
                        self.imageView.frame = .init(x: sender.center.x, y: sender.center.y,
                                                     width: resize.width,
                                                     height: resize.height)
                        
                        self.adjustButtonsForResize()
                    }
                }
                
            }
            
            // RIGHT TOP
        case .rightTop:
            print(sender.center)
            
            if sender.center.x >= imageView.frame.maxX && sender.center.y <= imageView.frame.minY,
               sender.center.x <= imageView.frame.maxX && sender.center.y >= imageView.frame.minY {
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1) {
                        let resize = CGSize(width: self.imageView.frame.minX - sender.center.x,
                                            height: self.imageView.frame.maxY - sender.center.y)
                        
                        self.imageView.frame = .init(x: sender.center.x, y: sender.center.y,
                                                     width: resize.width,
                                                     height: resize.height)
                        
                        self.adjustButtonsForResize()
                        
                    }
                }
                
            }
            
            // RIGHT DOWN
        case .rightDown:
            print(sender.center)
            
            if sender.center.x >= imageView.frame.maxX && sender.center.y >= imageView.frame.maxY,
               sender.center.x <= imageView.frame.maxX && sender.center.y <= imageView.frame.maxY {
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.1) {
                        
                        let resize = CGSize(width: self.imageView.frame.minX - sender.center.x,
                                            height: self.imageView.frame.minY - sender.center.y)
                        
                        self.imageView.frame = .init(x: sender.center.x, y: sender.center.y,
                                                     width: resize.width,
                                                     height: resize.height)
                        
                        self.adjustButtonsForResize()
                    }
                }
                
            }
            
        default: print("")
        }
    }
    
    public func adjustButtonsForResize() {
        buttonsArray[0].center = CGPoint(x: imageView.frame.minX, y: imageView.frame.minY)
        
        buttonsArray[1].center = CGPoint(x: imageView.frame.maxX, y: imageView.frame.minY)
        
        buttonsArray[2].center = CGPoint(x: imageView.frame.minX, y: imageView.frame.maxY)
        
        buttonsArray[3].center = CGPoint(x: imageView.frame.maxX, y: imageView.frame.maxY)
    }
    
    //MARK: - LAYOUTS
    private func setConstraints() {
        NSLayoutConstraint.activate([
            myLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}

//MARK: - UIImagePickerControllerDelegate
extension ImageResizeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
            imageView.isHidden = false
            containerView.isHidden = false
            myLabel.isHidden = true
            
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imageView.image = nil
        imageView.isHidden = true
        containerView.isHidden = true
        myLabel.isHidden = false
        dismiss(animated: true)
    }
}

enum ButtonPositionIdentifier: String {
    case leftTop
    case rightTop
    case leftDown
    case rightDown
}

class ButtonForDrag: UIButton {
    
    var buttonID: ButtonPositionIdentifier?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch = touches.first
        
        guard let location = touch?.location(in: self.superview) else {
            return
        }
        
        let newOrigin = CGPoint(x: location.x,
                                y: location.y)
        
        
        if newOrigin.x >= ((self.superview?.bounds.minX)! + self.frame.size.width / 2)
            && newOrigin.x <= ((self.superview?.bounds.maxX)! - self.frame.size.width / 2) {
            if newOrigin.y >= ((self.superview?.bounds.minY)! + self.frame.size.height / 2)
                && newOrigin.y <= ((self.superview?.bounds.maxY)! - self.frame.size.height / 2) {
                
                self.center.x = newOrigin.x
                self.center.y = newOrigin.y
            }
        }
        
    }
}

class ImageViewForPicture: UIImageView {
    
    var localTouchPosition : CGPoint?
    weak var imageResizeController: ImageResizeController?
    
     init(imageController: ImageResizeController) {
         self.imageResizeController = imageController
         super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let touch = touches.first
        
        guard let location = touch?.location(in: self.superview) else {
            return
        }
        
        let newOrigin = CGPoint(x: location.x,
                                y: location.y)
 
        if newOrigin.x >= ((self.superview?.bounds.minX)! + self.frame.size.width / 2) && newOrigin.x <= ((self.superview?.bounds.maxX)! - self.frame.size.width / 2) {
            if newOrigin.y >= ((self.superview?.bounds.minY)! + self.frame.size.height / 2) && newOrigin.y <= ((self.superview?.bounds.maxY)! - self.frame.size.height / 2) {
                self.center = newOrigin
                imageResizeController?.adjustButtonsForResize()
            }
        }
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        self.localTouchPosition = nil
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//        self.localTouchPosition = nil
//    }
}
