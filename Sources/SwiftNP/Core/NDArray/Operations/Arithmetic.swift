//
//  Arithmetic.swift
//  SwiftNP
//
//  Created by Arindam Karmakar on 13/10/24.
//

import Foundation

extension NDArray {
    /// Adds two NDArrays element-wise
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray in the addition.
    ///   - rhs: The right-hand side NDArray in the addition.
    /// - Returns: A new NDArray representing the result of element-wise addition.
    /// - Throws: SNPError if the shapes of the NDArrays are incompatible.
    public static func +(lhs: NDArray, rhs: NDArray) throws(SNPError) -> NDArray { try lhs.arithmeticOperation(rhs, ops: .addition) }
    
    /// Subtracts two NDArrays element-wise
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray in the subtraction.
    ///   - rhs: The right-hand side NDArray in the subtraction.
    /// - Returns: A new NDArray representing the result of element-wise subtraction.
    /// - Throws: SNPError if the shapes of the NDArrays are incompatible.
    public static func -(lhs: NDArray, rhs: NDArray) throws(SNPError) -> NDArray { try lhs.arithmeticOperation(rhs, ops: .subtraction) }
    
    /// Multiplies two NDArrays element-wise
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray in the multiplication.
    ///   - rhs: The right-hand side NDArray in the multiplication.
    /// - Returns: A new NDArray representing the result of element-wise multiplication.
    /// - Throws: SNPError if the shapes of the NDArrays are incompatible.
    public static func *(lhs: NDArray, rhs: NDArray) throws(SNPError) -> NDArray { try lhs.multiply(rhs) }
    
    /// Multiplies an NDArray by a scalar
    /// - Parameters:
    ///   - lhs: The NDArray to be multiplied.
    ///   - scalar: The scalar value to multiply each element by.
    /// - Returns: A new NDArray with each element multiplied by the scalar.
    /// - Throws: SNPError in case of computation errors.
    public static func *(lhs: NDArray, scalar: Double) throws(SNPError) -> NDArray { try lhs.multiply(scalar) }
    
    /// Multiplies an NDArray by a scalar
    /// - Parameters:
    ///   - scalar: The scalar value to multiply each element by.
    ///   - rhs: The NDArray to be multiplied.
    /// - Returns: A new NDArray with each element multiplied by the scalar.
    /// - Throws: SNPError in case of computation errors.
    public static func *(scalar: Double, rhs: NDArray) throws(SNPError) -> NDArray { try rhs.multiply(scalar) }
    
    /// Divides two NDArrays element-wise
    /// - Parameters:
    ///   - lhs: The left-hand side NDArray in the division.
    ///   - rhs: The right-hand side NDArray in the division.
    /// - Returns: A new NDArray representing the result of element-wise division.
    /// - Throws: SNPError if the shapes of the NDArrays are incompatible.
    public static func /(lhs: NDArray, rhs: NDArray) throws(SNPError) -> NDArray { try lhs.divide(rhs) }
    
    /// Divides an NDArray by a scalar
    /// - Parameters:
    ///   - lhs: The NDArray to be divided.
    ///   - scalar: The scalar value to divide each element by.
    /// - Returns: A new NDArray with each element divided by the scalar.
    /// - Throws: SNPError in case of computation errors.
    public static func /(lhs: NDArray, scalar: Double) throws(SNPError) -> NDArray { try lhs.divide(scalar) }
    
    /// Performs an arithmetic operation (addition or subtraction) between the current NDArray instance and another NDArray.
    ///
    /// - Parameters:
    ///   - other: The NDArray to perform the operation with.
    ///   - ops: The arithmetic operation to perform (addition or subtraction).
    /// - Throws:
    ///   - `SNPError.indexError` if the shapes of the two NDArray instances do not match.
    ///   - `SNPError.typeError` if the data type cannot be determined or if an unknown data type is encountered.
    /// - Returns: A new NDArray resulting from the specified arithmetic operation between the two NDArray instances.
    private func arithmeticOperation(_ other: NDArray, ops: ArithmeticOperation) throws(SNPError) -> NDArray {
        // Ensure both NDArray instances have the same shape.
        guard self.shape == other.shape else { throw SNPError.indexError(.custom(key: "SameShapeRequired")) }
        
        // Determine the appropriate data type for the result.
        var dtype: DType = .float64
        if self.dtype == other.dtype {
            dtype = self.dtype
        }
        
        // Flatten the data from both NDArray instances for element-wise operations.
        var flatArrayLHS = try self.flattenedData()
        let flatArrayRHS = try other.flattenedData()
        
        // Iterate over the flattened arrays to perform the specified operation.
        for (index, element) in flatArrayLHS.enumerated() {
            let lhs = element
            let rhs = flatArrayRHS[index]
            
            // Initialize a variable to hold the result of the operation.
            var result: NSNumber = 0
            
            // Perform addition or subtraction based on the specified operation.
            if ops == .addition {
                result = NSNumber(value: lhs.nsnumber.doubleValue + rhs.nsnumber.doubleValue)
            } else if ops == .subtraction {
                result = NSNumber(value: lhs.nsnumber.doubleValue - rhs.nsnumber.doubleValue)
            }
            
            // Cast the result to the appropriate data type and update the flattened array.
            if let casted = dtype.cast(result) {
                flatArrayLHS[index] = casted
            } else {
                throw SNPError.typeError(.custom(key: "UnknownDTypeOf", args: ["\(element)"]))
            }
        }
        
        // Create a new NDArray from the flattened results and reshape it to the original shape.
        return try NDArray(shape: self.shape, dtype: dtype, data: flatArrayLHS).reshape(to: self.shape)
    }
    
    private func multiply(_ other: NDArray) throws(SNPError) -> NDArray { other }
    
    /// Multiplies the NDArray by a scalar value element-wise.
    ///
    /// - Parameter scalar: The scalar value to multiply each element in the NDArray by.
    /// - Returns: A new NDArray with each element multiplied by the scalar.
    /// - Throws: SNPError in case of invalid types or if the operation fails.
    private func multiply(_ scalar: Double) throws(SNPError) -> NDArray {
        
        /// A recursive helper function that multiplies each element of the input (which could be a scalar or a nested array)
        /// by the specified scalar.
        ///
        /// - Parameters:
        ///   - input: The input which could be an NSNumber, NDArray, or an array of elements.
        ///   - scalar: The scalar value to multiply each element by.
        /// - Returns: The result of element-wise multiplication as a new array or scalar.
        /// - Throws: SNPError if the input type is unsupported or if an element cannot be processed.
        func multiplyByScalar(_ input: Any, scalar: Double) throws(SNPError) -> Any {
            // Check if the input is an NSNumber (a numeric type)
            if let numeric = input as? NSNumber {
                let doubleValue = Double(truncating: numeric) // Convert to Double
                return doubleValue * scalar // Multiply by scalar
            }
            // Check if the input is an array (could be multi-dimensional)
            else if let array = input as? [Any] {
                do {
                    // Recursively apply multiplication to each element in the array
                    return try array.map { element in
                        if let ndarray = element as? NDArray {
                            // If the element is an NDArray, apply scalar multiplication recursively to its data
                            return try multiplyByScalar(ndarray.data, scalar: scalar)
                        } else {
                            // If it's not an NDArray, treat it as an individual element
                            return try multiplyByScalar(element, scalar: scalar)
                        }
                    }
                } catch {
                    throw SNPError.typeError(.custom(key: "UnknownDType"))
                }
            } else {
                // If the input type is unsupported, throw an error
                throw SNPError.typeError(.custom(key: "UnknownDType"))
            }
        }
        
        // Perform element-wise scalar multiplication on the NDArray's data
        guard let result = try multiplyByScalar(self.data, scalar: scalar) as? [Any] else {
            // Ensure that the result is of the expected array type, else throw an error
            throw SNPError.assertionError(.custom(key: "CreateUnsuccessful"))
        }
        
        // Return a new NDArray with the multiplied data, retaining the original shape and dtype
        return try NDArray(array: result)
    }
    
    private func divide(_ other: NDArray) throws(SNPError) -> NDArray { other }
    
    private func divide(_ scalar: Double) throws(SNPError) -> NDArray { self }
}