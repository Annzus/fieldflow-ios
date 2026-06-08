enum LoadingState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(AppError)
}

extension LoadingState: Equatable where Value: Equatable { }
