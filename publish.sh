/home/friedger/_repos/github/friedger/pub-stacks-dump
cd ../../psq/stacks-dump
node report /tmp/stacks-testnet-895e46fd342bf290/ -a > ../../friedger/pub-stacks-dump/stacks-dump.txt
cd ../../friedger/pub-stacks-dump
timestamp=$(date +%c)
git add .
git commit -m "Published at: $timestamp"
git push origin main
