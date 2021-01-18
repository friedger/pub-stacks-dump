#!/bin/bash
timestamp=$(date -u)
cd /home/friedger/_repos/github/friedger/pub-stacks-dump
cd ../../psq/stacks-dump
node report /tmp/stacks-testnet-895e46fd342bf290/ -a > ../../friedger/pub-stacks-dump/stacks-dump.txt
cd ../../friedger/pub-stacks-dump
cat > header.html <<EOF
<html>
<title>Stacks Dump</title>
<body>
<h1>Stacks Dump</h1>
taken at $timestamp
<br/>
Read more at <a href="https://github.com/psq/stacks-dump">git repo for stacks-dump</a> and 
at <a href="https://github.com/friedger/pub-stacks-dump">git repo for pub-stacks-dump</a>. 
<pre>
EOF
cat header.html stacks-dump.txt > index.html
cat >> index.html <<EOF
</pre>
</body>
</html>
EOF
rm header.html

eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_rsa
git add .
git commit -m "Published at: $timestamp"
git push origin main
