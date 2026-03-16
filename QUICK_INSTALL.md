# Installing the Vitally MCP for Claude Desktop (Mac)

No Node.js, no Docker, no command line experience required.

---

## What You'll Need

- A Mac (Apple Silicon or Intel)
- Claude Desktop installed
- A Vitally API key ([How to get one](#getting-your-vitally-api-key))

---

## Step 1 — Figure Out Which Mac You Have

1. Click the  menu (top-left corner of your screen)
2. Click **About This Mac**
3. Look at the **Chip** or **Processor** line:
   - Says **Apple M1, M2, M3, or M4** → you have **Apple Silicon**
   - Says **Intel** → you have **Intel**

---

## Step 2 — Download the Right Binary

Go to the [Releases page](https://github.com/mattfdigio/vitally-mcp-distribution/releases/latest) and download:

- **Apple Silicon Mac** → `vitally-mcp-arm64`
- **Intel Mac** → `vitally-mcp-x64`

Move the downloaded file somewhere permanent — it needs to stay there for Claude Desktop to use it. A good place is your home folder:

```
/Users/yourname/vitally-mcp-arm64
```

(or `vitally-mcp-x64` if you have an Intel Mac)

---

## Step 3 — Allow Mac to Run the File

Because this file was downloaded from the internet, macOS will block it by default. You only need to do this once.

1. Open **Terminal** (press `Cmd + Space`, type "Terminal", press Enter)
2. Run this command — replace `yourname` with your actual Mac username:

**For Apple Silicon:**
```bash
xattr -d com.apple.quarantine /Users/yourname/vitally-mcp-arm64
chmod +x /Users/yourname/vitally-mcp-arm64
```

**For Intel:**
```bash
xattr -d com.apple.quarantine /Users/yourname/vitally-mcp-x64
chmod +x /Users/yourname/vitally-mcp-x64
```

> **Tip:** Not sure what your username is? In Terminal, type `whoami` and press Enter.

---

## Step 4 — Get Your Vitally API Key

1. Log in to Vitally at `https://medscout.vitally.io`
2. Click **Settings** (⚙️) in the left sidebar
3. Click **Integrations**
4. Find **"Vitally REST API"** and toggle it **ON** (requires admin access)
5. Copy the **Secret Token** — it starts with `sk_live_` followed by a long string

Keep this somewhere safe — you'll need it in the next step.

---

## Step 5 — Configure Claude Desktop

Claude Desktop reads a config file to know which MCP tools to load. You need to add the Vitally MCP to it.

### Open the config file

1. Open **Terminal**
2. Run:

```bash
open -e ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

This opens the file in TextEdit.

> **If the file doesn't exist yet:** Claude Desktop may not have created it. Run this instead to create and open it:
> ```bash
> mkdir -p ~/Library/Application\ Support/Claude && touch ~/Library/Application\ Support/Claude/claude_desktop_config.json && open -e ~/Library/Application\ Support/Claude/claude_desktop_config.json
> ```

### What to look for

The file will either be empty, or contain something like:
```json
{
  "mcpServers": {
    ...existing tools...
  }
}
```

### Add the Vitally MCP

**If the file is empty**, paste this entire block (replace `yourname` and `your_api_key_here`):

**For Apple Silicon:**
```json
{
  "mcpServers": {
    "vitally": {
      "command": "/Users/yourname/vitally-mcp-arm64",
      "args": [],
      "env": {
        "VITALLY_API_SUBDOMAIN": "https://medscout.rest.vitally.io",
        "VITALLY_API_KEY": "your_api_key_here",
        "VITALLY_DATA_CENTER": "US"
      }
    }
  }
}
```

**For Intel:**
```json
{
  "mcpServers": {
    "vitally": {
      "command": "/Users/yourname/vitally-mcp-x64",
      "args": [],
      "env": {
        "VITALLY_API_SUBDOMAIN": "https://medscout.rest.vitally.io",
        "VITALLY_API_KEY": "your_api_key_here",
        "VITALLY_DATA_CENTER": "US"
      }
    }
  }
}
```

**If the file already has other MCP tools**, add just the vitally block inside the existing `"mcpServers"` section:

```json
{
  "mcpServers": {
    "some-other-tool": { ... },
    "vitally": {
      "command": "/Users/yourname/vitally-mcp-arm64",
      "args": [],
      "env": {
        "VITALLY_API_SUBDOMAIN": "https://medscout.rest.vitally.io",
        "VITALLY_API_KEY": "your_api_key_here",
        "VITALLY_DATA_CENTER": "US"
      }
    }
  }
}
```

**Make sure to:**
- Replace `/Users/yourname/vitally-mcp-arm64` (or `x64`) with the actual path where you put the file
- Replace `your_api_key_here` with the token you copied from Vitally

Save the file (`Cmd + S`).

> **TextEdit warning:** TextEdit sometimes saves as Rich Text format, which breaks JSON. Before saving, go to **Format → Make Plain Text** to be sure.

---

## Step 6 — Restart Claude Desktop

Quit Claude Desktop completely (`Cmd + Q`) and reopen it. Just closing the window isn't enough.

---

## Step 7 — Verify It's Working

In Claude Desktop, start a new conversation and ask:

```
What Vitally tools are available?
```

You should see a list of tools including `search_accounts`, `get_account_details`, `get_account_key_metrics`, and others.

Try a real query:

```
Search for SI-BONE in Vitally
```

---

## Troubleshooting

### "vitally-mcp cannot be opened because it is from an unidentified developer"
You need to run the `xattr` command from Step 3. If you already did and still see this:
1. Go to **System Settings → Privacy & Security**
2. Scroll down — you should see a message about vitally-mcp being blocked
3. Click **Allow Anyway**
4. Try opening Claude Desktop again

### Vitally tools don't appear after restarting
The most common cause is a JSON syntax error in the config file. Check:
- Every opening `{` has a matching closing `}`
- Commas after each section except the last one
- The file was saved as **plain text** (not Rich Text)

You can validate your JSON at [jsonlint.com](https://jsonlint.com) — paste the file contents and it will show you exactly where any errors are.

### "Invalid API Token" error
- Go back to Vitally → Settings → Integrations → REST API
- Confirm it's toggled **ON**
- Copy the token again — make sure there are no spaces at the start or end
- Make sure you're using the Secret Token, not any other key shown in Vitally

### Check Claude Desktop logs
If something is wrong but you're not sure what, open Terminal and run:

```bash
tail -f ~/Library/Logs/Claude/mcp*.log
```

Then restart Claude Desktop and watch for error messages.

---

## Once It's Working

You can ask Claude things like:

- *"What's SI-BONE's last CSM pulse status?"*
- *"Show me all key metrics for [account name]"*
- *"Find all accounts with a Healthy CSM pulse"*
- *"List all custom traits available in Vitally"*
- *"Search for accounts in the Strategic segment"*

---

## Updating

When a new version is released:
1. Download the new binary from the [Releases page](https://github.com/mattfdigio/vitally-mcp-distribution/releases/latest)
2. Replace the existing file at `/Users/yourname/vitally-mcp-arm64` (or `x64`)
3. Run the `xattr` and `chmod` commands from Step 3 again on the new file
4. Restart Claude Desktop
