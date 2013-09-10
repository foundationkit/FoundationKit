// Part of FoundationKit http://foundationk.it

typedef NS_ENUM(NSInteger, FKHTTPStatusCode) {
  FKHTTPStatusCodeContinue                            = 100,
  FKHTTPStatusCodeSwitchingProtocols                  = 101,
  FKHTTPStatusCodeProcessing                          = 102,
  
  FKHTTPStatusCodeOK                                  = 200,
  FKHTTPStatusCodeCreated                             = 201,
  FKHTTPStatusCodeAccepted                            = 202,
  FKHTTPStatusCodeNonAuthoritativeInformation         = 203,
  FKHTTPStatusCodeNoContent                           = 204,
  FKHTTPStatusCodeResetContent                        = 205,
  FKHTTPStatusCodePartialContent                      = 206,
  FKHTTPStatusCodeMultiStatus                         = 207,
  
  FKHTTPStatusCodeMultipleChoices                     = 300,
  FKHTTPStatusCodeMovedPermanently                    = 301,
  FKHTTPStatusCodeFound                               = 302,
  FKHTTPStatusCodeSeeOther                            = 303,
  FKHTTPStatusCodeNotModified                         = 304,
  FKHTTPStatusCodeUseProxy                            = 305,
  // 306 unused
  FKHTTPStatusCodeTemporaryRedirect                   = 307,
  
  FKHTTPStatusCodeBadRequest                          = 400,
  FKHTTPStatusCodeAuthorizationRequired               = 401,
  FKHTTPStatusCodePaymentRequired                     = 402,
  FKHTTPStatusCodeForbidden                           = 403,
  FKHTTPStatusCodeNotFound                            = 404,
  FKHTTPStatusCodeMethodNotAllowed                    = 405,
  FKHTTPStatusCodeNotAcceptable                       = 406,
  FKHTTPStatusCodeProxyAuthenticationRequired         = 407,
  FKHTTPStatusCodeRequestTimeOut                      = 408,
  FKHTTPStatusCodeConflict                            = 409,
  FKHTTPStatusCodeGone                                = 410,
  FKHTTPStatusCodeLengthRequired                      = 411,
  FKHTTPStatusCodePreconditionFailed                  = 412,
  FKHTTPStatusCodeRequestEntityTooLarge               = 413,
  FKHTTPStatusCodeRequestURITooLarge                  = 414,
  FKHTTPStatusCodeUnsupportedMediaType                = 415,
  FKHTTPStatusCodeRequestedRangeNotSatisfiable        = 416,
  FKHTTPStatusCodeExpectationFailed                   = 417,
  // 418 - 421 unused
  FKHTTPStatusCodeUnprocessableEntity                 = 422,
  FKHTTPStatusCodeLocked                              = 423,
  FKHTTPStatusCodeFailedDependency                    = 424,
  // 425 unused
  FKHTTPStatusCodeUpgradeRequired                     = 426,
  
  FKHTTPStatusCodeInternalServerError                 = 500,
  FKHTTPStatusCodeMethodNotImplemented                = 501,
  FKHTTPStatusCodeBadGateway                          = 502,
  FKHTTPStatusCodeServiceTemporaryUnavailable         = 503,
  FKHTTPStatusCodeGatewayTimeOut                      = 504,
  FKHTTPStatusCodeHTTPVersionNotSupported             = 505,
  FKHTTPStatusCodeVariantAlsoNegotiates               = 506,
  FKHTTPStatusCodeInsufficientStorage                 = 507,
  // 508 - 509 unused
  FKHTTPStatusCodeNotExtended                         = 510
};


NS_INLINE NSString* FKHTTPStatusCodeDescription(FKHTTPStatusCode statusCode) {
  return [NSHTTPURLResponse localizedStringForStatusCode:(NSInteger)statusCode];
}

NS_INLINE BOOL FKHTTPStatusCodeIsInformational(FKHTTPStatusCode statusCode) {
  if (statusCode >= 100 && statusCode < 200) {
    return YES;
  }
  
  return NO;
}

NS_INLINE BOOL FKHTTPStatusCodeIsSuccessful(FKHTTPStatusCode statusCode) {
  if (statusCode >= 200 && statusCode < 300) {
    return YES;
  }
  
  return NO;
}

NS_INLINE BOOL FKHTTPStatusCodeIsRedirect(FKHTTPStatusCode statusCode) {
  if (statusCode >= 300 && statusCode < 400) {
    return YES;
  }
  
  return NO;
}

NS_INLINE BOOL FKHTTPStatusCodeIsClientError(FKHTTPStatusCode statusCode) {
  if (statusCode >= 400 && statusCode < 500) {
    return YES;
  }
  
  return NO;
}

NS_INLINE BOOL FKHTTPStatusCodeIsServerError(FKHTTPStatusCode statusCode) {
  if (statusCode >= 500) {
    return YES;
  }
  
  return NO;
}

NS_INLINE BOOL FKHTTPStatusCodeIsError(FKHTTPStatusCode statusCode) {
  return FKHTTPStatusCodeIsClientError(statusCode) || FKHTTPStatusCodeIsServerError(statusCode);
}
