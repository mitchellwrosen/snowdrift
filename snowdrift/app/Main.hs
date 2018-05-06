{-# language TemplateHaskell #-}

module Main where

import SnowdriftPrelude

import Http
import Version

import Network.HTTP.Types.Status (status200, status404)
import Network.Wai
import Network.Wai.Handler.Warp (run)
import System.IO

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering

  run 8000 $ \request respond -> do
    print request
    case request of
      GET [] ->
        handleGetRoot request respond
      GET ["version"] ->
        handleGetVersion request respond
      _ ->
        respond (responseLBS status404 [] "404 Ned Flanders")

--------------------------------------------------------------------------------
-- /

handleGetRoot :: Application
handleGetRoot _request respond =
  respond (responseLBS status200 [] "Hello, world!")

--------------------------------------------------------------------------------
-- /version

handleGetVersion :: Application
handleGetVersion request respond =
  respond (responseLBS status200 [] $$(snowdriftVersion))
