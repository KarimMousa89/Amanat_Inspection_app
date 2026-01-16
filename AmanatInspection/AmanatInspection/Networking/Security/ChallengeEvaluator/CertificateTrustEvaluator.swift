//
//  CertificateTrustEvaluator.swift
//  AmanatInspection
//
//  Created by Karim Mousa on 16/01/2026.
//

import Foundation
import Security

final class CertificateTrustEvaluator: ServerTrustEvaluating {

    private let pinnedCertificates: [Data]

    /// - Parameter certs: DER encoded certificates (.cer)
    init(certs: [Data]) {
        self.pinnedCertificates = certs
    }

    func evaluate(
        challenge: URLAuthenticationChallenge
    ) -> URLSession.AuthChallengeDisposition {

        guard let serverTrust = challenge.protectionSpace.serverTrust,
              SecTrustEvaluateWithError(serverTrust, nil) else {
            return .cancelAuthenticationChallenge
        }
        
        let serverCertCount = SecTrustGetCertificateCount(serverTrust)

        for index in 0..<serverCertCount {
            guard let serverCert = SecTrustGetCertificateAtIndex(serverTrust, index) else {
                continue
            }

            let serverCertData = SecCertificateCopyData(serverCert) as Data
            if pinnedCertificates.contains(serverCertData) {
                return .useCredential
            }
        }

        return .cancelAuthenticationChallenge
    }
}

