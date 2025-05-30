import Foundation

enum ReviewHTTPRequestRouter {
    case getReview(token: String, reviewID: String)
    case modifyReview(token: String, reviewID: String, reviewBody: Data)
    case deleteReview(token: String, reviewID: String)
    case getQuestions(token: String)
}

extension ReviewHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .getReview, .getQuestions:
            return .get
        case .modifyReview:
            return .put
        case .deleteReview:
            return .delete
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getReview(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .modifyReview(let token, _, _):
            return ["Authorization": "Bearer \(token)"]
        case .deleteReview(let token, _):
            return ["Authorization": "Bearer \(token)"]
        case .getQuestions(let token):
            return ["Authorization": "Bearer \(token)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .getReview, .deleteReview, .getQuestions:
            return nil
        case .modifyReview(_, _, let reviewBody):
            return reviewBody
        }
    }
    
    var host: String {
        #if os(iOS)
        return AppEnvironment.serverAddress
        #elseif os(Android)
        return ServerConfig.getServerAddress()
        #endif
    }
    
    var port: Int? { return nil }
    
    var path: [String] {
        switch self {
        case .getReview(_, let reviewID):
            return ["v1", "reviews", "\(reviewID)"]
        case .modifyReview(_, _, let reviewID):
            return ["v1", "reviews", "\(reviewID)"]
        case .deleteReview(_, let reviewID):
            return ["v1", "reviews", "\(reviewID)"]
        case .getQuestions:
            return ["v1", "reviews", "questions"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getReview, .modifyReview, .deleteReview, .getQuestions:
            return nil
        }
    }
}
