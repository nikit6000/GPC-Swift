//
//  CGPath+algebra.swift
//  GPC-Swift
//
//  Created by Nikita on 24.10.2022.
//

import Foundation
import CoreGraphics

public extension CGPath {

	func union(_ other: CGPath, quality: Double = 1.0) -> CGPath {
		let currentPolygon = polygon(with: quality)
		let otherPolygon = other.polygon(with: quality)
		
		return currentPolygon.union(otherPolygon).cgPath
	}
	
	func intersection(_ other: CGPath, quality: Double = 1.0) -> CGPath {
		let currentPolygon = polygon(with: quality)
		let otherPolygon = other.polygon(with: quality)
		
		return currentPolygon.intersection(otherPolygon).cgPath
	}

	func difference(_ other: CGPath, quality: Double = 1.0) -> CGPath {
		let currentPolygon = polygon(with: quality)
		let otherPolygon = other.polygon(with: quality)
		
		return currentPolygon.difference(otherPolygon).cgPath
	}

	func xor(_ other: CGPath, quality: Double = 1.0) -> CGPath {
		let currentPolygon = polygon(with: quality)
		let otherPolygon = other.polygon(with: quality)
		
		return currentPolygon.xor(otherPolygon).cgPath
	}
}

// MARK: - Private extensions

private extension Polygon {
	
	var cgPath: CGPath {
		let mutablePath = CGMutablePath()
		
		let numberOfContours = Int(gpcPolygon.num_contours)
		
		for i in 0..<numberOfContours {
			let contour = gpcPolygon.contour[i]
			let numberOfVertexes = Int(contour.num_vertices)
			
			for j in 0..<numberOfVertexes {
				let vertex = contour.vertex[j]
				
				if j == 0 {
					mutablePath.move(to: vertex.cgPoint)
				} else {
					mutablePath.addLine(to: vertex.cgPoint)
				}
			}
			
			mutablePath.closeSubpath()
		}
		
		return mutablePath
	}
}

private extension gpc_vertex {
	
	var cgPoint: CGPoint {
		CGPoint(x: x, y: y)
	}
}
