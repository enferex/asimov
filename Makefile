CAB=cabal
APP=asimov

$(APP): Main.hs
	$(CAB) build

install:
	$(CAB) install

setup:
	$(CAB) sandbox init

clean:
	$(CAB) clean
