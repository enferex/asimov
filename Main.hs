import Data.Char(toLower)
import Database.SQLite
import Control.Exception
import Network.Curl
import System.Environment
import Text.Regex.Posix

-- Database information
dbName = "site.sqlite3"
dbTableName = "sites"

dbTable :: SQLTable
dbTable = Table dbTableName [ Column "url"  (SQLVarChar 32) []
                            , Column "page" (SQLVarChar 32) [] ] []

-- Site object (contains all of our lovely data)
data Site = Site {url::URLString, sites::[String]}

instance Show Site where
    show (Site u b) = u 
        ++ "(" ++ ((show . length) b) ++ "): " ++ botz
        where
            botz = foldr (++) " " (map (\(x,y) -> (show y) ++ ") " 
                   ++ x ++ "\n") (zip b (enumFrom 0)))

-- Append "robots.txt" to the given URL            
fixURL :: URLString -> URLString
fixURL url = case (last url) of
    '/' -> url ++ "robots.txt"
    _  -> url ++ "/robots.txt"

-- Return lines containing "disallow:"
filterCrap :: [String] -> [String]
filterCrap s = filter (\x -> (map toLower x) =~ "disallow:") s

-- Scan a URL's /robots.txt and retun a Site object
scan :: URLString -> IO Site
scan url = do
    res <- (curlGetString . fixURL) url []
    let results = filterCrap $ (lines . snd) res
    return $ Site url results

-- Given a list of sites, store them into our database
store :: [Site] -> IO ()
store sites = do
    con <- openConnection dbName
    defineTable con dbTable
    mapM_ (\s -> insert s con) sites
    where 
        insert (Site a b) c = 
            mapM_ (\s -> insertRow c dbTableName [("url", a), ("page", s)]) b

main :: IO ()
main = do
    args <- getArgs
    sites <- mapM scan args
    store sites
    mapM_ (putStrLn . show) sites
