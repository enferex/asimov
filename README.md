# asimov: Scanning the robots of the universe #
asimov is a utility which scans a given URL and places all Disallow
locations (from the robots.txt at the URL) into a database named 'sites.sql3'

## Setup ##
Running the setup and install procedures below will create a sandbox environment
fulfilling all of the dependencies necessary to build and run asimov.  I have
wrapped all of the utility functions to setup/install/build into a Makefile.
Initially run the following before trying to build anything:

* make setup
* make install

The setup target will create a sandbox, and install will download all of the
dependencies required to build asimov.  

## Usage ##
Run asimov with a single url as the only argument.  Since we are rocking a
sandbox, the execution can occur from that environment: for example

```./cabal-sandbox/bin/asimov www.google.com```

Alternatively, you can use cabal to execute:

```cabal run www.google.com```

## Notes ##
   * Main.hs contains all of the source for asimov.  
   * It might be easier to just build Main.hs via ghc instead of
   running `make build`

## Contact ##
enferex: https://github.com/enferex

