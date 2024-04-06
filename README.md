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

### 2. Add these 3 lines to your `~/.bashrc`

1.  `export ETNA_CLI="$HOME/<path_to_this_repo>"`
2.  `export PATH=$ETNA_CLI:$PATH`
3.  `alias etna='bash main.sh'`

### 3. Load the changes

- `source ~/.bashrc`

### 4. Test the CLI

- `etna help`

## Roadmap

- Visualize activity subject
- Take 'soutenances' directly from the CLI

