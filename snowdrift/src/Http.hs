module Http
  ( pattern GET
  , pattern POST
  ) where

import SnowdriftPrelude

import Network.Wai

pattern GET :: [Text] -> Request
pattern GET path <- (isGetRequest -> Just path)

pattern POST :: [Text] -> Request
pattern POST path <- (isPostRequest -> Just path)

-- Is the given request a GET? If so, return the path segments.
isGetRequest :: Request -> Maybe [Text]
isGetRequest request = do
  "GET" <- pure (requestMethod request)
  pure (pathInfo request)

-- Is the given request a POST? If so, return the path segments.
isPostRequest :: Request -> Maybe [Text]
isPostRequest request = do
  "POST" <- pure (requestMethod request)
  pure (pathInfo request)
