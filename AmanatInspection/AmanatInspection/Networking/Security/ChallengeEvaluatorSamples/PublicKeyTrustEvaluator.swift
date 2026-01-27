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
#if DEV || STAGE
        let trustedHostArray = ["api-test.tahakom.com",
                                "api-stg.tahakom.com"]
        
        if trustedHostArray.contains(challenge.protectionSpace.host) && challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            return .useCredential
        }
        return .cancelAuthenticationChallenge
#else
        let trustedHostArray = ["tahakom-app.tahakom.com"]
        
        guard trustedHostArray.contains(challenge.protectionSpace.host),
              challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust,
              SecTrustEvaluateWithError(serverTrust, nil) else {
            return .cancelAuthenticationChallenge
        }
        
        let serverCertificates: [SecCertificate]? = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate]
        
        guard let serverCertificate = serverCertificates?.first,
              let serverPublicKey = SecCertificateCopyKey(serverCertificate),
              let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) as Data? else {
            return .cancelAuthenticationChallenge
        }
        
        // TODO: what about pinning the root certificate
        //        guard let pinnedCertificate: SecCertificate = loadCertificate(named: "1", withExtension: "pem") ,
        //              let pinnedPublicKey = SecCertificateCopyKey(pinnedCertificate),
        //              let pinnedPublicKeyData = SecKeyCopyExternalRepresentation(pinnedPublicKey, nil) as Data? else {
        //            completionHandler(.cancelAuthenticationChallenge, nil)
        //            return
        //        }
        
        // Hash the public key with SHA256
        let serverPublicKeyHash = serverPublicKeyData.sha256Base64()
        
        //        let pinnedPublicKeyHash = pinnedPublicKeyData.swiftyRSASHA256().base64EncodedString()
        
        // Compare certificates
        //        let serverCertificateData = SecCertificateCopyData(serverCertificate) as Data
        //        let pinnedCertificateData = SecCertificateCopyData(pinnedCertificate) as Data
        //
        //        let serverKey = SecCertificateCopyKey(serverCertificate)!
        //        let pinnedKey = SecCertificateCopyKey(pinnedCertificate)!
        
        if pinnedKeyHashes.contains(serverPublicKeyHash) {
            // Success – use system trust
            return .useCredential
        } else {
            // Fail – mismatch
          return .cancelAuthenticationChallenge
        }
#endif
    }
    
}
