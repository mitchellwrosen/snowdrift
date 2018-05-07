{-# language OverloadedStrings   #-}
{-# language ScopedTypeVariables #-}

module Main where

import Control.Exception
import Crypto.Hash.Algorithms (SHA1(SHA1))
import Data.Aeson
import Data.ASN1.BinaryEncoding (DER(DER))
import Data.ASN1.Encoding (decodeASN1)
import Data.ASN1.Error (ASN1Error)
import Data.ASN1.Types (ASN1, fromASN1)
import Data.ByteString (ByteString)
import Data.Function ((&))
import Data.PEM
import Data.X509
import Network.HTTP.Types.Status (status200, status400, status404)
import Network.HTTP.Types.URI (urlDecode)
import Network.Wai
import Network.Wai.Handler.Warp (run)
import System.IO (BufferMode(LineBuffering), hSetBuffering, stdout)
import System.IO.Error (isUserError)
import System.Process (callCommand)

import qualified Crypto.PubKey.RSA.PKCS15 as RSA
import qualified Data.ByteString as ByteString
import qualified Data.ByteString.Base64 as Base64
import qualified Data.ByteString.Lazy as LazyByteString
import qualified Data.ByteString.Lazy.Char8 as LazyChar8

type LazyByteString
  = LazyByteString.ByteString

main :: IO ()
main = do
  hSetBuffering stdout LineBuffering
  run 8001 (exceptions app)

exceptions :: Application -> Application
exceptions inner request respond =
  inner request respond
    `catch` \e -> do
      if isUserError e
        then
          respond (responseLBS status400 [] "")
        else
          throwIO e

app :: Application
app request respond =
  case (requestMethod request, pathInfo request) of
    ("POST", []) ->
      handlePostRoot request respond
    _ ->
      respond (responseLBS status404 [] "")

handlePostRoot :: Application
handlePostRoot request respond = do
  -- base64-decode the "Signature" header.
  Just (Right sig) :: Maybe (Either String ByteString) <-
    pure (Base64.decode <$> lookup "Signature" (requestHeaders request))

  -- Strip the "payload=" prefix from the request body, and url-decode the rest
  -- to JSON (converting '+' to ' '). We now need to verify the authenticity of
  -- the JSON.
  Just payload :: Maybe ByteString <- do
    bytes :: LazyByteString <-
      strictRequestBody request
    bytes
      & LazyByteString.stripPrefix "payload="
      & fmap LazyByteString.toStrict
      & fmap (urlDecode True)
      & pure

  -- Parse the PEM (should be fetched from https://api.travis-ci.org/config)
  Right [pem] :: Either String [PEM] <-
    pure (pemParseBS travisOrgPem)

  -- Decode the PEM as an ASN.1 stream
  Right asn1 :: Either ASN1Error [ASN1] <-
    pure (decodeASN1 DER (LazyByteString.fromStrict (pemContent pem)))

  -- Decode the ASN.1 stream as a public RSA key
  Right (PubKeyRSA key, []) :: Either String (PubKey, [ASN1]) <-
    pure (fromASN1 asn1)

  -- Verify the integrity of the payload
  True <-
    pure (RSA.verify (Just SHA1) key payload sig)

  -- Restart the 'snowdrift' service
  callCommand "sv restart snowdrift"

  respond (responseLBS status200 [] "")

-- TODO: Fetch from https://api.travis-ci.org/config
travisOrgPem :: ByteString
travisOrgPem =
  "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvtjdLkS+FP+0fPC09j25\ny/PiuYDDivIT86COVedvlElk99BBYTrqNaJybxjXbIZ1Q6xFNhOY+iTcBr4E1zJu\ntizF3Xi0V9tOuP/M8Wn4Y/1lCWbQKlWrNQuqNBmhovF4K3mDCYswVbpgTmp+JQYu\nBm9QMdieZMNry5s6aiMA9aSjDlNyedvSENYo18F+NYg1J0C0JiPYTxheCb4optr1\n5xNzFKhAkuGs4XTOA5C7Q06GCKtDNf44s/CVE30KODUxBi0MCKaxiXw/yy55zxX2\n/YdGphIyQiA5iO1986ZmZCLLW8udz9uhW5jUr3Jlp9LbmphAC61bVSf4ou2YsJaN\n0QIDAQAB\n-----END PUBLIC KEY-----"
