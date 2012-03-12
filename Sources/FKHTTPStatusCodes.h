// Part of FoundationKit http://foundationk.it

typedef enum {
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
} FKHTTPStatusCode;


NS_INLINE NSString* FKHTTPStatusCodeDescription(FKHTTPStatusCode statusCode) {
  switch (statusCode) {
    case FKHTTPStatusCodeContinue:
      return _(@"Continue");
    case FKHTTPStatusCodeSwitchingProtocols:
      return _(@"Switching Protocols");
    case FKHTTPStatusCodeProcessing:
      return _(@"Processing");
      
    case FKHTTPStatusCodeOK:
      return _(@"OK");
    case FKHTTPStatusCodeCreated:
      return _(@"Created");
    case FKHTTPStatusCodeAccepted:
      return _(@"Accepted");
    case FKHTTPStatusCodeNonAuthoritativeInformation:
      return _(@"Non-Authoritative Information");
    case FKHTTPStatusCodeNoContent:
      return _(@"No Content");
    case FKHTTPStatusCodeResetContent:
      return _(@"Reset Content");
    case FKHTTPStatusCodePartialContent:
      return _(@"Partial Content");
    case FKHTTPStatusCodeMultiStatus:
      return _(@"Multi-Status");
      
    case FKHTTPStatusCodeMultipleChoices:
      return _(@"Multiple Choices");
    case FKHTTPStatusCodeMovedPermanently:
      return _(@"Moved Permanently");
    case FKHTTPStatusCodeFound:
      return _(@"Found");
    case FKHTTPStatusCodeSeeOther:
      return _(@"See Other");
    case FKHTTPStatusCodeNotModified:
      return _(@"Not Modified");
    case FKHTTPStatusCodeUseProxy:
      return _(@"Use Proxy");
    case FKHTTPStatusCodeTemporaryRedirect:
      return _(@"Temporary Redirect");
      
    case FKHTTPStatusCodeBadRequest:
      return _(@"Bad Request");
    case FKHTTPStatusCodeAuthorizationRequired:
      return _(@"Authorization Required");
    case FKHTTPStatusCodePaymentRequired:
      return _(@"Payment Required");
    case FKHTTPStatusCodeForbidden:
      return _(@"Forbidden");
    case FKHTTPStatusCodeNotFound:
      return _(@"Not Found");
    case FKHTTPStatusCodeMethodNotAllowed:
      return _(@"Method Not Allowed");
    case FKHTTPStatusCodeNotAcceptable:
      return _(@"Not Acceptable");
    case FKHTTPStatusCodeProxyAuthenticationRequired:
      return _(@"Proxy Authentication Required");
    case FKHTTPStatusCodeRequestTimeOut:
      return _(@"Request Time-out");
    case FKHTTPStatusCodeConflict:
      return _(@"Conflict");
    case FKHTTPStatusCodeGone:
      return _(@"Gone");
    case FKHTTPStatusCodeLengthRequired:
      return _(@"Length Required");
    case FKHTTPStatusCodePreconditionFailed:
      return _(@"Precondition Failed");
    case FKHTTPStatusCodeRequestEntityTooLarge:
      return _(@"Request Entity Too Large");
    case FKHTTPStatusCodeRequestURITooLarge:
      return _(@"Request-URI Too Large");
    case FKHTTPStatusCodeUnsupportedMediaType:
      return _(@"Unsupported Media Type");
    case FKHTTPStatusCodeRequestedRangeNotSatisfiable:
      return _(@"Requested Range Not Satisfiable");
    case FKHTTPStatusCodeExpectationFailed:
      return _(@"Expectation Failed");
    case FKHTTPStatusCodeUnprocessableEntity:
      return _(@"Unprocessable Entity");
    case FKHTTPStatusCodeLocked:
      return _(@"Locked");
    case FKHTTPStatusCodeFailedDependency:
      return _(@"Failed Dependency");
    case FKHTTPStatusCodeUpgradeRequired:
      return _(@"Upgrade Required");
      
    case FKHTTPStatusCodeInternalServerError:
      return _(@"Internal Server Error");
    case FKHTTPStatusCodeMethodNotImplemented:
      return _(@"Method Not Implemented");
    case FKHTTPStatusCodeBadGateway:
      return _(@"Bad Gateway");
    case FKHTTPStatusCodeServiceTemporaryUnavailable:
      return _(@"Service Temporarily Unavailable");
    case FKHTTPStatusCodeGatewayTimeOut:
      return _(@"Gateway Time-out");
    case FKHTTPStatusCodeHTTPVersionNotSupported:
      return _(@"HTTP Version Not Supported");
    case FKHTTPStatusCodeVariantAlsoNegotiates:
      return _(@"Variant Also Negotiates");
    case FKHTTPStatusCodeInsufficientStorage:
      return _(@"Insufficient Storage");
    case FKHTTPStatusCodeNotExtended:
      return _(@"Not Extended");
      
    default:
      return [NSString stringWithFormat:@"%@: %d",_(@"Undefined Status Code"), statusCode];
  }
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
  if (statusCode >= 500 && statusCode < 600) {
    return YES;
  }
  
  return NO;
}

NS_INLINE BOOL FKHTTPStatusCodeIsError(FKHTTPStatusCode statusCode) {
  return FKHTTPStatusCodeIsClientError(statusCode) || FKHTTPStatusCodeIsServerError(statusCode);
}