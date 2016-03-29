module Main where
import qualified Toy.ToyTest
import qualified Toy.ClusterTest
import Test.HUnit (runTestTT, test)

main = runTestTT $ test $ mconcat
  [ Toy.ClusterTest.tests
  , Toy.ToyTest.tests
  ]
