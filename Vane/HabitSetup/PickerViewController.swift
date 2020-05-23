//
//  PickerViewController.swift
//  Vane
//
//  Created by Andrey Antosha on 21/05/2020.
//  Copyright © 2020 Andrey Antosha. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {

    private var pickerView: PickerView!
    private var fadeView: UIView!

    private var containerHeight = 300 + UIApplication.shared.windows.first!.safeAreaInsets.bottom
    private var timerValueCompletion: ((Double?) -> Void)?

    private var pickerFinalPosition: CGPoint!
    private var pickerStartPosition: CGPoint!
    
    private var fadeTapGesture: UITapGestureRecognizer!

    private init(title: String) {
        super.init(nibName: nil, bundle: nil)

        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext

        pickerView = PickerView(title: title)

        fadeView = UIView()
        fadeView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        fadeView.alpha = 0

        view.backgroundColor = .clear
        view.addSubview(fadeView)
        view.addSubview(pickerView)

        fadeView.edgesToSuperview()

        pickerView.leftToSuperview()
        pickerView.rightToSuperview()
        pickerView.bottomToSuperview()
    }

    convenience init(time: Double?, title: String, timerValueCompletion: @escaping (Double?) -> Void) {
        self.init(title: title)

        var presetTime = time

        if time == nil {
            let startOfDay = Calendar(identifier: .gregorian).startOfDay(for: Date())
            let currentTime = Int(Date().timeIntervalSince(startOfDay))
            let nextHour = currentTime + 3600 - currentTime % 3600
            presetTime = Double(nextHour)
        }
        self.pickerView.selectPickerValue(time: presetTime ?? 0)
        self.timerValueCompletion = timerValueCompletion
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if pickerFinalPosition == nil {
            pickerFinalPosition = pickerView.layer.position
            pickerStartPosition = CGPoint(x: pickerFinalPosition.x, y: pickerFinalPosition.y + pickerView.frame.height)
            pickerView.layer.position = pickerStartPosition
        }
    }

    override func viewDidLoad() {
        pickerView.cancelButton.addTarget(self, action: #selector(didPressCancel), for: .touchUpInside)
        pickerView.confirmButton.addTarget(self, action: #selector(didPressConfirm), for: .touchUpInside)
        
        fadeTapGesture = UITapGestureRecognizer(target: self, action: #selector(didPressFadeView(_:)))
        fadeView.addGestureRecognizer(fadeTapGesture)
    }
    
    @objc func didPressCancel() {
        self.timerValueCompletion?(nil)
        self.dismiss()
    }
    
    @objc func didPressConfirm() {
        self.timerValueCompletion?(self.pickerView.getSelectedTime())
        self.dismiss()
    }
    
    @objc func didPressFadeView(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            self.dismiss()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let ani = CASpringAnimation(keyPath: "position")
        ani.damping = 500
        ani.stiffness = 1000
        ani.mass = 3
        ani.duration = 0.5
        ani.fromValue = pickerStartPosition
        ani.toValue = pickerFinalPosition
        ani.isCumulative = true
        ani.isRemovedOnCompletion = false
        ani.fillMode = .forwards
        ani.delegate = self
        pickerView.layer.add(ani, forKey: "PickerViewPositionAnimation")

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.fadeView.alpha = 1
        }, completion: nil)
    }

    private func dismiss() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.pickerView.transform = .init(translationX: 0, y: self.pickerView.frame.height)
            self.fadeView.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }

}

extension PickerViewController: CAAnimationDelegate {

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        pickerView.layer.position = pickerFinalPosition
    }
}
