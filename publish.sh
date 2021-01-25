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
__timestamp=$(date -u +"%Y%m%d-%H%M%S")

# read input for loop (optional)
__sleeptime="${1:-}"

## UPDATE VARIABLES BELOW FOR YOUR SYSTEM

# directory for working_dir data from stacks-node
__stacksnode="/tmp/stacks-testnet-7617d9e6195032fd/"

# directory for running stacks-dump
__stacksdump="/home/friedger/_repos/github/psq/stacks-dump"
# directory for repo to publish results
__publishdir="/home/friedger/_repos/github/friedger/pub-stacks-dump"
# file name for saving stacks-node data
__outputfile="stacks-dump.txt"
# file name for saving stacks-node data as json
__outputjsonfile="stacks-dump.json"
# website to access data after published
__website="https://friedger.github.io/pub-stacks-dump/"
# twitter account used for twitter card in SEO
__twitter="@fmdroid"

##########
# SCRIPT #
##########

# Verify all directories exist before starting
if [ ! -d "$__stacksnode" ]; then
  printf "stacks-node working directory not found, please check the variable in the script."
  exit
elif [ ! -d "$__stacksdump" ]; then
  printf "stacks-dump directory not found, please check the variable in the script or download from GitHub.\n\nhttps://github.com/psq/stacks-dump"
  exit
elif [ ! -d "$__publishdir" ]; then
  printf "publishing directory not found, please check the variable in the script."
  exit
fi

function publish() {

# Run stacks-dump and save output to file
cd "$__stacksdump" || exit
git pull
node report "$__stacksnode" -a > "$__publishdir"/"$__outputfile"
node report "$__stacksnode" -j -l > "$__publishdir"/"$__outputjsonfile"

# Build web page with stacks-dump data
cd "$__publishdir" || exit
cat > header.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
<title>Stacks Dump</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#5546FF" />
<meta name="description" content="A public view of statistics around the Stacks blockchain, published hourly using stacks-dump." />
<!-- OG:DATA -->
<meta property="og:title" content="Stacks Dump" />
<meta property="og:description" content="A public view of statistics around the Stacks blockchain, published hourly using stacks-dump." />
<meta property="og:image" content="$__website/logo/stacks-dump-truck-trans.png" />
<meta property="og:image:secure_url" content="$__website/logo/stacks-dump-truck-trans.png" />
<meta property="og:image:type" content="image/png" />
<meta property="og:image:width" content="250" />
<meta property="og:image:height" content="166" />
<meta property="og:image:alt" content="The stacks dump truck." />
<meta property="og:site_name" content="Stacks Dump" />
<meta property="og:type" content="__website" />
<meta property="og:locale" content="ALL_ALL" />
<!-- TWITTER CARD -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="$__twitter">
<meta name="twitter:description" content="A public view of statistics around the Stacks blockchain, published hourly using stacks-dump.">
<meta name="twitter:title" content="Stacks Dump">
<meta name="twitter:image" content="$__website/logo/stacks-dump-truck-trans.png">
<meta name="twitter:image:alt" content="The stacks dump truck.">
<style>
body {
  background-color: black;
  color: black;
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
  <p>Taken at: $__timestamp</p>
  <p>Read more at <a href="https://github.com/psq/stacks-dump">git repo for stacks-dump</a> and at <a href="https://github.com/friedger/pub-stacks-dump">git repo for pub-stacks-dump</a>.</p>
</div>
<pre class="stacks-dump">
EOF
cat header.html "$__outputfile" > index.html
cat >> index.html <<EOF
</pre>
</body>
</html>
EOF
rm header.html

# upload and publish via git
git add .
git commit -m "Published at: $__timestamp"
git push origin main

}


if [ "$__sleeptime" == "" ]; then
  publish
  exit
else
  while true
  do
    __timestamp=$(date -u +"%Y%m%d-%H%M%S")
    publish
    sleep "$__sleeptime"
    printf "Published at: %s", "$__timestamp"
  done
fi
