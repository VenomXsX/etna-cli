# ETNA CLI

I wanted to see informations from my school's intranet right on the terminal.

Currently making the auto setup script, for now see [manual setup](#manual-set-up-to-path)

Tools needed

- curl
- jq 
- bc 

Install those with your package manager

## Manual set up to PATH

### 1. Add execution permission for the main file

- `chmod +x main.sh`

### 2. Add these lines to your `~/.bashrc`

- `export ETNA_CLI="$HOME/<path_to_this_repo>"`

Example: if you've cloned this repo in your home directory, it would look like:
`export ETNA_CLI="$HOME/etna-cli"`

- `export PATH=$ETNA_CLI:$PATH`
- `alias etna='bash main.sh'`

### 3. Load your the changes

- `source ~/.bashrc`

### 4. Test the CLI

- `etna help`
