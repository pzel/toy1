module Main (main) where
import System.Environment (getArgs)
import Toy (run)

main :: IO ()
main = getArgs >>= run
