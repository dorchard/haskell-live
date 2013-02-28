module Example where

g = let f 0 = return ()
        f n = do { f (n-1); putStrLn (show n); }
    in f 200000

live_main = do putStrLn "Yola gola\n"; 

               
              
   