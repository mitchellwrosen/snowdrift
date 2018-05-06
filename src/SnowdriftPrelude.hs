module SnowdriftPrelude
  ( LazyByteString
  , module X
  ) where

import Control.Monad.IO.Class as X (MonadIO, liftIO)
import Data.ByteString as X (ByteString)
import Data.HashMap.Strict as X (HashMap)
import Data.Text as X (Text)
import Prelude as X hiding (String)

import qualified Data.ByteString.Lazy

type LazyByteString =
  Data.ByteString.Lazy.ByteString
