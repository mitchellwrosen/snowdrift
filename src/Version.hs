module Version where

import SnowdriftPrelude

import Instances.TH.Lift () -- instance Lift LazyByteString
import Language.Haskell.TH
import Language.Haskell.TH.Syntax
import System.Environment (lookupEnv)

import qualified Data.ByteString.Lazy.Char8 as LazyChar8

-- | Grab the @SNOWDRIFT_VERSION@ environment variable during compilation. We
-- don't grab the git revision because:
--
-- * This affords us more flexibility with specifying the version
--
-- * We may be building the website in a container that doesn't have the entire
--   git repo
snowdriftVersion :: Q (TExp LazyByteString)
snowdriftVersion = do
  runIO (lookupEnv "SNOWDRIFT_VERSION") >>= \case
    Nothing ->
      unsafeTExpCoerce (lift ("<unknown>" :: LazyByteString))
    Just version ->
      unsafeTExpCoerce (lift (LazyChar8.pack version))
