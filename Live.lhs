> {-# LANGUAGE ImplicitParams #-}

> module Main where

> import Language.Haskell.Interpreter
> import Control.Monad
> import System.Directory
> import System.IO
> import System.Environment
> import Control.Concurrent

Very quick and dirty live-coding for Haskell

Compile:

[cabal install hint]
ghc Live.hs -o Live

Example.
Create a module, e.g. Example.hs (called Example) with a function live_main :: IO ()
Then run

.\live LiveMod

Any changes to the LiveMod.hs file will be caught and live_main will be run.
If there is a parse/type error then the error will be shown on stderr

> main = do args <- getArgs
>           let mname = args!!0
>           exists <- doesFileExist (mname ++ ".hs")
>           when (not exists) (putStr $ "Warning: " ++ mname ++ " does not yet exist!")
>           let ?mname = mname in live Nothing ""
>           return ()

> live :: (?mname :: String) => Maybe ThreadId -> String -> IO String
> live threadId fileN = do -- Watch for existence of file and changes
>                       exists <- doesFileExist (?mname ++ ".hs")
>                       if (not exists)
>                       then live threadId fileN
>                       else do fileN' <- readFile (?mname ++ ".hs")
>                               if (fileN == fileN') then live threadId fileN
>                               -- Interupt current thread and reinterpret 
>                               else do case threadId of 
>                                         Nothing -> return ()
>                                         Just id -> killThread id 
>                                       value <- runInterpreter interpreter
>                                       case value of 
>                                            Left e -> do hPrint stderr (show e)
>                                                         live threadId fileN'
>                                            Right f -> do threadId' <- forkIO f
>                                                          live (Just threadId') fileN'

> interpreter :: (?mname :: String) => Interpreter (IO ())
> interpreter = do reset
>                  loadModules [?mname]
>                  setImports ["Prelude", ?mname]
>                  interpret ("live_main") (as :: IO ())

