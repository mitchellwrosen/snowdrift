{-# language TemplateHaskell #-}

module Main where

import SnowdriftPrelude

import Version

import Network.HTTP.Types.Status (status200)
import Network.Wai
import Network.Wai.Handler.Warp (run)
import System.IO
import Web.FormUrlEncoded (urlDecodeAsForm)

import qualified Data.Text.IO as Text

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering

  run 8000 $ \request respond -> do
    print request
    case request of
      POST ["travis-ci"] -> do
        body :: LazyByteString <-
          strictRequestBody request
        case urlDecodeAsForm body of
          Left err ->
            Text.putStrLn err
          Right payload ->
            print (payload :: HashMap Text [Text])
        respond (responseLBS status200 [] "")
      GET ["version"] ->
        respond (responseLBS status200 [] $$(snowdriftVersion))
      _ ->
        respond (responseLBS status200 [] "Hello, world!")

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
