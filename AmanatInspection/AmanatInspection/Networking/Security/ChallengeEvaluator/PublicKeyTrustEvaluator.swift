//
//  PublicKeyTrustEvaluator.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 16/01/2026.
//

import Foundation

final class PublicKeyTrustEvaluator: ServerTrustEvaluating {
    let pinnedKeyHashes: Set<String>

    init(hashes: [String]) {
        self.pinnedKeyHashes = Set(hashes)
    }

    func evaluate(
        challenge: URLAuthenticationChallenge
    ) -> URLSession.AuthChallengeDisposition {

        guard
            let trust = challenge.protectionSpace.serverTrust,
            SecTrustEvaluateWithError(trust, nil),
            let serverKey = SecTrustCopyKey(trust),
            let serverKeyData = SecKeyCopyExternalRepresentation(serverKey, nil) as Data? else {
            return .cancelAuthenticationChallenge
        }
        
        let hash = serverKeyData.sha256Base64()
        return pinnedKeyHashes.contains(hash)
            ? .useCredential
            : .cancelAuthenticationChallenge
    }
}
