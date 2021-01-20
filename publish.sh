#!/usr/bin/env bash

# This script will run stacks-dump against
# an active stacks-node miner's data and
# output the results to a web page that
# is uploaded to GitHub and published via
# GitHub Pages.

########
# INIT #
########

set -o errexit
set -o pipefail
set -o nounset

# timestamp in UTC
timestamp=$(date -u)

## UPDATE VARIABLES BELOW FOR YOUR SYSTEM

# directory for working_dir data from stacks-node
dir_stacksnode="/tmp/stacks-testnet-bb8423eafa69dc8f/"
# directory for running stacks-dump
dir_stacksdump="/home/friedger/_repos/github/psq/stacks-dump"
# directory for repo to publish results
dir_publish="/home/friedger/_repos/github/friedger/pub-stacks-dump"
# file name for saving stacks-node data
file_output="stacks-dump.txt"

##########
# SCRIPT #
##########

# Verify all directories exist before starting
if [ ! -d "$dir_stacksnode" ]; then
  printf "stacks-node working directory not found, please check the variable in the script."
  exit
elif [ ! -d "$dir_stacksdump" ]; then
  printf "stacks-dump directory not found, please check the variable in the script or download from GitHub.\n\nhttps://github.com/psq/stacks-dump"
  exit
elif [ ! -d "$dir_publish" ]; then
  printf "publishing directory not found, please check the variable in the script."
  exit
fi

# Run stacks-dump and save output to file
cd "$dir_stacksdump" || exit
node report "$dir_stacksnode" -a > "$dir_publish"/"$file_output"

# Build web page with stacks-dump data
cd "$dir_publish" || exit
cat > header.html <<EOF
<html>
<head>
<title>Stacks Dump</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#5546FF" />
<meta name="description" content="A public view of statistics around the Stacks blockchain, published hourly using stacks-dump." />
<!-- OG:DATA -->
<meta property="og:title" content="Stacks Dump" />
<meta property="og:description" content="A public view of statistics around the Stacks blockchain, published hourly using stacks-dump." />
<meta property="og:image" content="https://friedger.github.io/pub-stacks-dump/stacks-dump-truck.png" />
<meta property="og:image:secure_url" content="https://friedger.github.io/pub-stacks-dump/stacks-dump-truck.png" />
<meta property="og:image:type" content="image/png" />
<meta property="og:image:width" content="512" />
<meta property="og:image:height" content="340" />
<meta property="og:image:alt" content="The stacks dump truck." />
<meta property="og:site_name" content="Stacks Dump" />
<meta property="og:type" content="website" />
<meta property="og:locale" content="ALL_ALL" />
<!-- TWITTER CARD -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@fmdroid">
<meta name="twitter:description" content="A public view of statistics around the Stacks blockchain, published hourly using stacks-dump.">
<meta name="twitter:title" content="Stacks Dump">
<meta name="twitter:image" content="https://friedger.github.io/pub-stacks-dump/stacks-dump-truck.png">
<meta name="twitter:image:alt" content="The stacks dump truck.">
<style>
body {
  background-color: black;
  color:black;
  font-family: sans-serif;
  padding: 0;
  margin: 0;
}
.header {
  background-color: #5546FF;
  color: #EEE;
  width: 100%;
  padding-left: 5px;
  padding-bottom: 10px;
  padding-top: 10px;
  font-size: 20px;
}
.header a {
  color: white;
  text-decoration: none;
}
.header a:hover {
  color: #EEE;
  text-decoration: underline;
}
.stacks-dump {
  background-color: black;
  color: #EEE;
  width: 100%;
  padding: 5px;
  overflow-x: scroll;
  overflow-y: hidden;
}
</style>
</head>
<body>
<div class="header">
  <h1>Stacks Dump</h1>
  <p>A public view of statistics around the Stacks blockchain, published hourly using stacks-dump.</p>
  <p>Taken at: $timestamp</p>
  <p>Read more at <a href="https://github.com/psq/stacks-dump">git repo for stacks-dump</a> and at <a href="https://github.com/friedger/pub-stacks-dump">git repo for pub-stacks-dump</a>.</p>
</div>
<pre class="stacks-dump">
EOF
cat header.html stacks-dump.txt > index.html
cat >> index.html <<EOF
</pre>
</body>
</html>
EOF
rm header.html

# upload and publish via git
git add .
git commit -m "Published at: $timestamp"
git push origin main
