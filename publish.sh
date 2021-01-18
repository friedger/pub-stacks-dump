#!/bin/bash
timestamp=$(date -u)
cd /home/friedger/_repos/github/friedger/pub-stacks-dump
cd ../../psq/stacks-dump
node report /tmp/stacks-testnet-895e46fd342bf290/ -a > ../../friedger/pub-stacks-dump/stacks-dump.txt
cd ../../friedger/pub-stacks-dump
cat > header.html <<EOF
<html>
<head>
<title>Stacks Dump</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#5546FF" />
<meta name="description" content="A public view of statistics around the Stacks blockchain, published hourly using stacks-dump." />
<style>
body {background-color: #5546FF; color:#EEE; font-family: sans-serif;}
pre {background-color: #000; padding: 4px; overflow:auto;}
</style>
</head>
<body>
<h1>Stacks Dump</h1>
<p>A public view of statistics around the Stacks blockchain, published hourly using stacks-dump.</p>
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

git add .
git commit -m "Published at: $timestamp"
git push origin main
