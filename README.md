# pub-stacks-dump

This script is used to provide an hourly update of stacks-dump from an independent miner on the [Stacks 2.0 Mainnet](https://www.stacks.co/).

The information is published via GitHub pages and available at the link below:

[https://friedger.github.io/pub-stacks-dump/](https://friedger.github.io/pub-stacks-dump/)

## Requirements

This script *should* run on any system that supports Bash. Please file an issue if you get an error.

This script expects that you have `git` installed and configured on your system.

This script relies on [stacks-dump by psq](https://github.com/psq/stacks-dump) to review the stacks-node storage and output statistics based on the miner's data. The `stacks-dump` repository must be downloaded separately.

This script has a set of variables that need to be updated to match your system configuration:

- directory for working_dir data from stacks-node
`__stacksnode="/tmp/stacks-testnet-bb8423eafa69dc8f/"`
- directory for running stacks-dump
`__stacksdump="/home/friedger/_repos/github/psq/stacks-dump"`
- directory for repo to publish results
`__publishdir="/home/friedger/_repos/github/friedger/pub-stacks-dump"`
- file name for saving stacks-node data
`__outputfile="stacks-dump.txt"`
- website to access data after published
`__website="https://friedger.github.io/pub-stacks-dump/"`
- twitter account used for twitter card in SEO
`__twitter="@fmdroid"`

GitHub Pages is used for publishing, however instructions to set that up are outside the scope of this readme. Feel free to [review the GitHub documentation](https://docs.github.com/en/github/working-with-github-pages) or use the publishing platform of your choice.

## Usage

By default, the script will run one time and exit.

```bash
bash publish.sh
```

If you would like to run the script in a loop, it accepts a value after the file name that is passed to `sleep` as a parameter. From the [sleep man page](https://linux.die.net/man/1/sleep):

> Pause for NUMBER seconds. SUFFIX may be 's' for seconds (the default), 'm' for minutes, 'h' for hours or 'd' for days.

For example, to publish every hour:

```bash
bash publish.sh 1h
```
