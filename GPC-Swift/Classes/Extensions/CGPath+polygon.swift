//
//  CGPath+polygon.swift
//  Pods
//
//  Created by Nikita on 27.10.2022.
//

import Foundation
import CoreGraphics

extension CGPath {
	
	func polygon(with quality: Double = 1.0) -> Polygon {
		let clampedQuality = quality.clamped(to: Constants.minQuality...Constants.maxQuality)
		let polygon = Polygon()
		let step: Double = 1.0 / (Double(Constants.maxQuantizationSteps) * clampedQuality)
		
		self.forEach { element in
			
			switch element.type {
				
			case .moveToPoint:
				polygon.add(point: element.points[0])
			case .addLineToPoint:
				polygon.add(point: element.points[0])
			case .addQuadCurveToPoint:
				polygon.addLineInterpolatedQuadCurve(
					to: element.points[1],
					controlPoint: element.points[0],
					step: step
				)
			case .addCurveToPoint:
				polygon.addLineInterpolatedCurve(
					to: element.points[2],
					controlPoint1: element.points[0],
					controlPoint2: element.points[1],
					step: step
				)
			case .closeSubpath:
				polygon.closeCurrentContour()
			}
		}
		
		return polygon
	}
}

// MARK: - Constants

// MARK: - Constants

private extension CGPath {
	
	enum Constants {
		
		static let maxQuantizationSteps: Int = 100
		static let minQuality: Double = 0.01
		static let maxQuality: Double = 1.0
	}
}

