module Toy.Cluster (Cluster
                   , Member(..)
                   , mkCluster
                   , mkMember
                   , toListenAddr
                   , toSockAddrInet) where

import Data.IP
import Data.Maybe (isJust, fromJust)
import Data.Set (Set)
import qualified Data.Set as Set
import Network.Socket (SockAddr(..), PortNumber, iNADDR_ANY)

type Cluster = Set Member
data Member = Member IPv4 PortNumber deriving (Eq, Ord, Show)

mkCluster :: [String] -> Maybe Cluster
mkCluster ipsPorts =
  let parsed = map mkMember ipsPorts
  in if all isJust parsed then return (Set.fromList (map fromJust parsed))
     else Nothing

mkMember :: String -> Maybe Member
mkMember s = case reads s of
   [(ip, rest)] -> return ip >>= maybePort rest
   _ -> Nothing

maybePort :: String -> IPv4 -> Maybe Member
maybePort (':':s) ip = case (reads s :: [(Int, String)]) of
  [(port, _)] -> if port <= 65535
                 then return (Member ip (fromIntegral port))
                 else Nothing
  _ ->  Nothing
maybePort _ _ = Nothing

toSockAddrInet :: Member -> SockAddr
toSockAddrInet (Member ip port) = SockAddrInet port (toHostAddress ip)

toListenAddr :: Member -> SockAddr
toListenAddr (Member _ port) = SockAddrInet port iNADDR_ANY
