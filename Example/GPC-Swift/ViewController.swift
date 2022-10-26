//
//  ViewController.swift
//  GPC-Swift
//
//  Created by Nikita on 10/24/2022.
//  Copyright (c) 2022 Nikita. All rights reserved.
//

import UIKit
import Combine
import GPC_Swift

class ViewController: UIViewController {
	
	var s = Set<AnyCancellable>()
	
	// MARK: - Internal methods
	
	override func loadView() {
		view = DrawingView()
		
		Timer.publish(every: 1 / 30, on: .main, in: RunLoop.Mode.defaultRunLoopMode)
			.autoconnect()
			.sink { _ in
				self.view.setNeedsDisplay()
			}
			.store(in: &s)
		
	}
	
}

// MARK: - DrawingView

private class DrawingView: UIView {
	
	// MARK: - Internal methods
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		guard let ctx = UIGraphicsGetCurrentContext() else {
			return
		}
		
		let processedPath = makePath(in: rect)
		let transformablePath = UIBezierPath(cgPath: processedPath)
		
		var transform: CGAffineTransform = .identity
		
		transform = CGAffineTransformTranslate(transform, 60, 100)
		transform = CGAffineTransformScale(transform, 2, 2)
		transform = CGAffineTransformRotate(transform, (-10 * .pi) / 360)
		
		transformablePath.apply(transform)
		
		UIColor.red.setStroke()
		ctx.addPath(transformablePath.cgPath)
		ctx.setLineJoin(.round)
		ctx.setLineWidth(10.0)
		ctx.strokePath()
	}
}

// MARK: - Factory

private extension DrawingView {
	
	func makePath(in rect: CGRect) -> CGPath {
		let path1 = CGMutablePath()
		let path = CGMutablePath()
		
		path.addEllipse(
			in: .init(
				x: 0,
				y: 0,
				width: 100,
				height: 100
			)
		)
		
		path.addEllipse(
			in: .init(
				x: 0,
				y: 160,
				width: 100,
				height: 100
			)
		)
		
		path1.addRect(
			.init(
				x: 10,
				y: 0,
				width: 40,
				height: 200
			)
		)
		
		return path1.union(path, quality: 0.5)
	}
}

