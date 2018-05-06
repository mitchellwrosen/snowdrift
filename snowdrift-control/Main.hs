{-# language OverloadedStrings   #-}
{-# language ScopedTypeVariables #-}

module Main where

import Data.Aeson
import Network.HTTP.Types.Status (status200, status404)
import Network.HTTP.Types.URI (urlDecode)
import Network.Wai
import Network.Wai.Handler.Warp (run)

import qualified Data.ByteString.Lazy as LazyByteString
import qualified Data.ByteString.Lazy.Char8 as LazyChar8

type LazyByteString
  = LazyByteString.ByteString

main :: IO ()
main =
  run 8001 $ \request respond -> do
    case (requestMethod request, pathInfo request) of
      ("POST", []) ->
        handlePostRoot request respond
      _ ->
        respond (responseLBS status404 [] "")

handlePostRoot :: Application
handlePostRoot request respond = do
  body :: LazyByteString <-
    strictRequestBody request
  case parseWebhook body of
    Just value ->
      print value
    Nothing ->
      fail
        ("could not parse travis-ci.org webhook: " ++ LazyChar8.unpack body)
  respond (responseLBS status200 [] "")

parseWebhook :: LazyByteString -> Maybe Value
parseWebhook bytes = do
  bytes' :: LazyByteString <-
    LazyByteString.stripPrefix "payload=" bytes
  decodeStrict (urlDecode False (LazyByteString.toStrict bytes'))
