//
//  SliderControl.swift
//  FindMe
//
//  Created by Алексей on 01.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

open class SliderControl: UIView {

    public var delegate: SliderControlDelegate?

    private var _current: Int = 0
    private var _slides: [UIView] = []
    private var _max: Int {
        return _slides.count
    }
    private var presentPosition: CGRect {
        return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }


    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }
    private func initialize() {

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
    }

    //MARK: Public methods
    public var current: Int {
        return _current
    }
    public func setup(slides: [UIView]) {

        for slide in _slides {
            slide.removeFromSuperview()
        }
        _slides.removeAll()

        _slides = slides
        _slides.each({ self.addSubview($0) })
        
        _current = -1

        focusOn(slide: 0)
    }
    public func focusOn(slide newIndex: Int) {

        let newIndex = prepare(index: newIndex)
        if (_current == newIndex) {
            return
        }

        for slide in _slides {
            slide.frame = presentPosition
            move(slide: slide, to: .left)
        }

        _current = newIndex
        slide(number: newIndex)?.frame = presentPosition

        delegate?.move(slider: self, focusOn: newIndex)
    }

    //MARK: Handlers
    @objc private func swipeLeft(){
        handleSwipe(direction: .left)
    }
    @objc private func swipeRight() {
        handleSwipe(direction: .right)
    }
    private func handleSwipe(direction: UISwipeGestureRecognizerDirection) {

        if (_slides.count < 2) {
            return
        }

        let nextIndex = nextPosition(direction: direction)
        let prev = slide(number: _current)!
        let next = slide(number: nextIndex)!


        next.frame = presentPosition
        if (direction == .left){
            move(slide: next, to: .right)
        }
        else {
            move(slide: next, to: .left)
        }

        _current = nextIndex
        delegate?.move(slider: self, focusOn: _current)

        UIView.animate(withDuration: 0.3, animations: {

            self.move(slide: prev, to: direction)
            self.move(slide: next, to: direction)
        })
    }
    private func nextPosition(direction: UISwipeGestureRecognizerDirection ) -> Int {

        if (_slides.isEmpty){
            return _current
        }

        var result = _current
        if (direction == .left){
            result = result + 1
        }
        else if (direction == .right) {
            result = result - 1
        }

        return prepare(index: result)
    }
    private func slide(number: Int) -> UIView? {

        if (_slides.isEmpty) {
            return nil
        }

        return _slides[prepare(index: number)]
    }
    private func prepare(index: Int) -> Int {
        return (index + _max)  % _max
    }
    private func move(slide: UIView, to direction: UISwipeGestureRecognizerDirection) {

        let base = slide.frame
        let width = frame.width

        var newX = CGFloat(0)

        if (direction == .left) {

            newX = base.origin.x - width
        }
        else if (direction == .right) {

            newX = base.origin.x + width
        }

        slide.frame = CGRect(x: newX,
                             y: 0,
                             width: frame.width,
                             height: frame.height)
    }
}
