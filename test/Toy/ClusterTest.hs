module Toy.ClusterTest (tests) where

import Data.Maybe (fromJust)
import Data.IP
import qualified Data.Set as S
import Data.Word (byteSwap32)
import Network.Socket (SockAddr(..), PortNumber(..), inet_addr)
import Test.HUnit
import Toy.Cluster

tests = mconcat [ membersAreParsedFromStrings
                , clusterIsParsedFromArgs
                , membersConvertToSockAddrInet]


membersAreParsedFromStrings = [
    mkMember "10.1.1.0:23" ~?= Just (Member (read "10.1.1.0" :: IPv4) 23)
  , mkMember "2.3.200.1:254" ~?= Just (Member (read "2.3.200.1" :: IPv4) 254)
  , mkMember "2.3.200.1:9999999" ~?= Nothing
  , mkMember "2.3.3.300:99" ~?= Nothing
    -- LOOK OUT, 'localhost' is not a valid IP
  , mkMember "localhost:80" ~?= Nothing
  ]

clusterIsParsedFromArgs =
  [
    S.size (fromJust (mkCluster ["127.0.0.1:28"])) ~?= 1
  , S.size (fromJust (mkCluster ["127.0.0.1:28", "67.68.69.70:71"])) ~?= 2
  ]

membersConvertToSockAddrInet =
  [
    toSockAddrInet (fromJust (mkMember "10.1.1.1:23")) ~?=
      SockAddrInet 23 (byteSwap32 167837953)
  , toListenAddr (fromJust (mkMember "10.1.1.1:23")) ~?=
      SockAddrInet 23 0
  ]
