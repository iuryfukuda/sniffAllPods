KSNIFF_VERSION=1.4.1
args ?= "-s256 tcp"

# Download binary static-tcpdump from ksniff releases
static-tcpdump:
	curl -LO https://github.com/eldadru/ksniff/releases/download/v${KSNIFF_VERSION}/ksniff.zip
	unzip -j ksniff.zip static-tcpdump -d .
	rm ksniff.zip

run: clean static-tcpdump
	./sniff.sh -f static-tcpdump -a "$(args)"

clean:
	rm -f *.log *.err *.pid
