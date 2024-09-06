//
//  ApiResult.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation

enum ApiResult<T> {
    case initial
    case loading
    case success(_ body: T)
    case error(_ apiError: ApiError, _ message: String)
}

extension ApiResult {
    
    @discardableResult
    func onSuccess(
        _ block: @escaping (_ data: T) async -> ()
    ) async -> ApiResult<T> {
        if case let .success(body) = self {
            await block(body)
        }
        return self
    }
    
    @discardableResult
    func onError(
        _ block: @escaping (_ apiError: ApiError, _ message: String) async -> ()
    ) async -> ApiResult<T> {
        if case let .error(code, message) = self {
            await block(code, message)
        }
        return self
    }
    
    @discardableResult
    func onLoading(
        _ block: @escaping () async -> ()
    ) async -> ApiResult<T> {
        if case .loading = self {
            await block()
        }
        return self
    }
    
    @discardableResult
    func mapSuccess<X>(
        _ block: @escaping (_ data: T) async -> X
    ) async -> ApiResult<X> {
        return switch self {
        case .initial:
            .initial
        case .loading:
            .loading
        case let .success(body):
            await .success(block(body))
        case let .error(apiError, message):
            .error(apiError, message)
        }
    }
}
