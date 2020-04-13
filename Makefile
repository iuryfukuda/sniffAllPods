KSNIFF_VERSION=1.4.1
args ?= "-s256 tcp"

# Download binary static-tcpdump from ksniff releases
static-tcpdump:
	curl -LO https://github.com/eldadru/ksniff/releases/download/v${KSNIFF_VERSION}/ksniff.zip
	unzip -j ksniff.zip static-tcpdump -d .
	rm ksniff.zip

run: static-tcpdump
	./main.sh -f static-tcpdump -a "$(args)"
