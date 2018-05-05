{-# language OverloadedStrings #-}

import Network.HTTP.Types.Status (status200)
import Network.Wai
import Network.Wai.Handler.Warp (run)

main :: IO ()
main =
  run 8000 $ \req resp ->
    resp (responseLBS status200 [] "Hello, world!")
