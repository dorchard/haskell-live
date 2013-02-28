haskell-live
============

Very quick and dirty live coding for Haskell

Compile:

[cabal install hint]
ghc Live.hs -o Live

Example.
Create a module, e.g. Example.hs (called Example) with a function live_main :: IO ()
Then run

.\live LiveMod

Any changes to the LiveMod.hs file will be caught and live_main will be run.
If there is a parse/type error then the error will be shown on stderr
