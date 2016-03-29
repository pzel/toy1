module Toy (run) where

import Control.Concurrent (forkIO, threadDelay)
import Data.Set (toList)
import Network.Socket
import Toy.Cluster

run :: [String] -> IO ()
run = either error initLoop . ensureCluster

ensureCluster :: [String] -> Either String (Member, Cluster)
ensureCluster [] = Left "Empty cluster spec"
ensureCluster (me:others) = case (mkMember me, mkCluster others) of
  (Just self, Just c) -> Right (self,c)
  _                   -> Left "Unable to parse cluster spec"

initLoop :: (Member, Cluster) -> IO ()
initLoop (self, c) = do
  putStrLn ("running with cluster: " ++ show c)
  sock <- socket AF_INET Datagram 0
  bindSocket sock (toListenAddr self)
  _ <- forkIO (receiveLoop sock self)
  pingLoop sock self c

pingLoop :: Socket -> Member -> Cluster -> IO ()
pingLoop sock self cluster = do
  threadDelay (1000*1000)
  mapM_ (sendPing sock self) (Data.Set.toList cluster)
  pingLoop sock self cluster

receiveLoop :: Socket -> Member -> IO ()
receiveLoop sock self = do
  input <- recvFrom sock 100
  putStrLn (show self ++ " got " ++ show input)
  receiveLoop sock self

sendPing :: Socket -> Member -> Member -> IO ()
sendPing sock self target = do
  let myMsg = "ping from " ++ show self
  _ <- sendTo sock myMsg (toSockAddrInet target)
  return ()
