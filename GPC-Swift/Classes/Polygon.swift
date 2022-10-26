//
//  Polygon.swift
//  GPC-Swift
//
//  Created by Nikita on 24.10.2022.
//

import Foundation
import simd

// MARK: - Types

typealias Vertex = SIMD2<Double>

// MARK: - GPC wrapper

final class Polygon {
	
	// MARK: - Internla vars
	
	private(set) var gpcPolygon: gpc_polygon
	
	// MARK: - Private vars
	
	private var currentContour = [Vertex]()
	
	// MARK: - Initialization/Deinitialization
	
	init() {
		gpcPolygon = gpc_polygon(
			num_contours: 0,
			hole: nil,
			contour: nil
		)
	}
	
	deinit {
		gpc_free_polygon(&gpcPolygon)
	}
	
	
	// MARK: - Internal methods
	
	func add(point: CGPoint) {
		currentContour.append(point.simdVertex)
	}
	
	func addLineInterpolatedQuadCurve(
		to endPoint: CGPoint,
		controlPoint: CGPoint,
		step: Double
	) {
		
		guard let currentPoint = currentContour.last else {
			return
		}
		
		let currentVertex = currentPoint
		let controlVertex = controlPoint.simdVertex
		let endVertex = endPoint.simdVertex
		
		var t: Double = 0.0
		
		while t <= 1.0 {
			
			let a: Vertex.Scalar = pow(1 - t, 2)
			let b: Vertex.Scalar = 2 * (1 - t) * t
			let c: Vertex.Scalar = pow(t, 2)
			
			let bezieVertex = a * currentVertex + b * controlVertex + c * endVertex
			
			currentContour.append(bezieVertex)
			
			t += step
		}
	}
	
	func addLineInterpolatedCurve(
		to endPoint: CGPoint,
		controlPoint1: CGPoint,
		controlPoint2: CGPoint,
		step: Double
	) {
		
		guard let currentPoint = currentContour.last else {
			return
		}
		
		let currentVertex = currentPoint
		let controlVertex1 = controlPoint1.simdVertex
		let controlVertex2 = controlPoint2.simdVertex
		let endVertex = endPoint.simdVertex
		
		var t: Double = 0.0
		
		while t <= 1.0 {
			
			let a: Vertex.Scalar = (-pow(t, 3) + 3 * pow(t, 2) - 3 * t + 1)
			let b: Vertex.Scalar = (3 * pow(t, 3) - 6 * pow(t, 2) + 3 * t)
			let c: Vertex.Scalar = (-3 * pow(t, 3) + 3 * pow(t, 2))
			let d: Vertex.Scalar = pow(t, 3)
			
			let bezieVertex = currentVertex * a + controlVertex1 * b + controlVertex2 * c + endVertex * d
			currentContour.append(bezieVertex)
			
			t += step
		}
	}
	
	func union(_ other: Polygon) -> Polygon {
		return perform(operation: GPC_UNION, with: other)
	}
	
	func intersection(_ other: Polygon) -> Polygon {
		return perform(operation: GPC_INT, with: other)
	}
	
	func difference(_ other: Polygon) -> Polygon {
		return perform(operation: GPC_DIFF, with: other)
	}
	
	func xor(_ other: Polygon) -> Polygon {
		return perform(operation: GPC_XOR, with: other)
	}
	
	func closeCurrentContour() {
		
		guard currentContour.count > 0 else {
			return
		}
		
		let vertexList = currentContour.withUnsafeMutableBufferPointer { buffer -> gpc_vertex_list? in
			guard let baseAdress = buffer.baseAddress else {
				return nil
			}
			
			let reboundedAdress = baseAdress.withMemoryRebound(to: gpc_vertex.self, capacity: buffer.count) { $0 }
			
			return gpc_vertex_list(
				num_vertices: Int32(buffer.count),
				vertex: reboundedAdress
			)
		}
		
		guard var vertexList = vertexList else {
			return
		}
		
		gpc_add_contour(
			&gpcPolygon,
			&vertexList,
			0
		)
		
		currentContour.removeAll()
	}
	
	// MARK: - Private methods
	
	private func perform(operation: gpc_op, with other: Polygon) -> Polygon {
		let result = Polygon()
		
		gpc_polygon_clip(
			operation,
			&gpcPolygon,
			&other.gpcPolygon,
			&result.gpcPolygon
		)
		
		return result
	}
}

// MARK: - Private extensions

private extension CGPoint {
	
	var simdVertex: Vertex {
		Vertex(
			x: x.native,
			y: y.native
		)
	}
}
