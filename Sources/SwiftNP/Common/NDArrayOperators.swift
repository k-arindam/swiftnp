//
//  NDArrayOperators.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 18/10/24.
//

import Foundation

/// Compares two NDArray instances for equality.
///
/// - Parameters:
///   - lhs: The left-hand side NDArray to compare.
///   - rhs: The right-hand side NDArray to compare.
/// - Returns: A boolean indicating whether the two NDArray instances are equal.
///   - Two NDArray instances are considered equal if they have the same shape,
///     the same data type, and their flattened data arrays are equal.
public func ===(lhs: any NDArray, rhs: any NDArray) -> Bool { lhs.isEqual(to: rhs) }

/// Adds two NDArrays element-wise
/// - Parameters:
///   - lhs: The left-hand side NDArray in the addition.
///   - rhs: The right-hand side NDArray in the addition.
/// - Returns: A new NDArray representing the result of element-wise addition.
/// - Throws: SNPError if the shapes of the NDArrays are incompatible.
public func +(lhs: any NDArray, rhs: any NDArray) throws(SNPError) -> any NDArray { try lhs.add(rhs) }

/// Subtracts two NDArrays element-wise
/// - Parameters:
///   - lhs: The left-hand side NDArray in the subtraction.
///   - rhs: The right-hand side NDArray in the subtraction.
/// - Returns: A new NDArray representing the result of element-wise subtraction.
/// - Throws: SNPError if the shapes of the NDArrays are incompatible.
public func -(lhs: any NDArray, rhs: any NDArray) throws(SNPError) -> any NDArray { try lhs.subtract(rhs) }

/// Multiplies two NDArrays element-wise
/// - Parameters:
///   - lhs: The left-hand side NDArray in the multiplication.
///   - rhs: The right-hand side NDArray in the multiplication.
/// - Returns: A new NDArray representing the result of element-wise multiplication.
/// - Throws: SNPError if the shapes of the NDArrays are incompatible.
public func *(lhs: any NDArray, rhs: any NDArray) throws(SNPError) -> any NDArray { try lhs.multiply(rhs) }

/// Multiplies an NDArray by a scalar
/// - Parameters:
///   - lhs: The NDArray to be multiplied.
///   - scalar: The scalar value to multiply each element by.
/// - Returns: A new NDArray with each element multiplied by the scalar.
/// - Throws: SNPError in case of computation errors.
public func *(lhs: any NDArray, scalar: Double) throws(SNPError) -> any NDArray { try lhs.multiply(by: scalar) }
    
/// Multiplies an NDArray by a scalar
/// - Parameters:
///   - scalar: The scalar value to multiply each element by.
///   - rhs: The NDArray to be multiplied.
/// - Returns: A new NDArray with each element multiplied by the scalar.
/// - Throws: SNPError in case of computation errors.
public func *(scalar: Double, rhs: any NDArray) throws(SNPError) -> any NDArray { try rhs.multiply(by: scalar) }

/// Divides two NDArrays element-wise
/// - Parameters:
///   - lhs: The left-hand side NDArray in the division.
///   - rhs: The right-hand side NDArray in the division.
/// - Returns: A new NDArray representing the result of element-wise division.
/// - Throws: SNPError if the shapes of the NDArrays are incompatible.
public func /(lhs: any NDArray, rhs: any NDArray) throws(SNPError) -> any NDArray { try lhs.divide(rhs) }

/// Divides an NDArray by a scalar
/// - Parameters:
///   - lhs: The NDArray to be divided.
///   - scalar: The scalar value to divide each element by.
/// - Returns: A new NDArray with each element divided by the scalar.
/// - Throws: SNPError in case of computation errors.
public func /(lhs: any NDArray, scalar: Double) throws(SNPError) -> any NDArray { try lhs.divide(by: scalar) }
