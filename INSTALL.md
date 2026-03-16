# Claude Desktop Installation Guide - No npm Required!

This guide is specifically for **Claude Desktop users** who don't have npm/Node.js set up. If you're a developer with npm already, see [INSTALLATION.md](INSTALLATION.md) instead.

---

## ⚠️ Prerequisites

**You need:**
1. Claude Desktop installed
2. A Vitally API key ([How to get one](#getting-your-vitally-api-key))
3. That's it! No npm, no Node.js, no command line needed.

---

## 📦 Installation Methods

Choose **ONE** of these methods:

### Method 1: Docker (Recommended - Works Everywhere)

**Best for:** Non-technical users, no npm needed

#### Step 1: Install Docker Desktop
- **Mac:** Download from https://www.docker.com/products/docker-desktop
- **Windows:** Download from https://www.docker.com/products/docker-desktop
- Install and start Docker Desktop

#### Step 2: Get the Docker Image
Open Terminal (Mac) or Command Prompt (Windows) and run:
```bash
docker pull mattfdigio/vitally-mcp-enhanced:latest
```

#### Step 3: Configure Claude Desktop

**Mac:** Edit this file:
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Windows:** Edit this file:
```
%APPDATA%\Claude\claude_desktop_config.json
```

**Add this configuration:**
```json
{
  "mcpServers": {
    "vitally": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "-e", "VITALLY_API_SUBDOMAIN",
        "-e", "VITALLY_API_KEY",
        "-e", "VITALLY_DATA_CENTER",
        "mattfdigio/vitally-mcp-enhanced:latest"
      ],
      "env": {
        "VITALLY_API_SUBDOMAIN": "https://medscout.rest.vitally.io",
        "VITALLY_API_KEY": "your_api_key_here",
        "VITALLY_DATA_CENTER": "US"
      }
    }
  }
}
```

**Replace `your_api_key_here` with your actual Vitally API key!**

#### Step 4: Restart Claude Desktop

Quit Claude Desktop completely and reopen it.

#### Step 5: Test

In Claude Desktop, ask:
```
"What Vitally tools are available?"
```

You should see 6+ Vitally tools listed!

---

### Method 2: Pre-Built Package (Mac/Linux)

**Best for:** Users comfortable with Terminal, no Docker needed

#### Step 1: Download the Pre-Built Binary

**Download the appropriate binary for your system:**

**Mac with Apple Silicon (M1/M2/M3/M4):**
- Download: [vitally-mcp-arm64](https://github.com/mattfdigio/vitally-mcp-distribution/releases/download/v2.0.0/vitally-mcp-arm64)

**Mac with Intel or Linux:**
- Download: [vitally-mcp-x64](https://github.com/mattfdigio/vitally-mcp-distribution/releases/download/v2.0.0/vitally-mcp-x64)

**After downloading:**
```bash
# Move to a permanent location
mkdir -p ~/bin
mv ~/Downloads/vitally-mcp-arm64 ~/bin/  # or vitally-mcp-x64

# Make it executable
chmod +x ~/bin/vitally-mcp-arm64  # or vitally-mcp-x64
```

**Alternative - Build from Source:**
If you prefer to build from source (requires Node.js/npm):
```bash
# Contact the repository maintainer for source code access
# Source code is maintained separately for security
```

#### Step 2: Configure Claude Desktop

**Mac:** Edit `~/Library/Application Support/Claude/claude_desktop_config.json`

**Add this configuration:**

**Using the pre-built binary:**
```json
{
  "mcpServers": {
    "vitally": {
      "command": "/Users/yourname/bin/vitally-mcp-arm64",
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

**OR if you built from source:**
```json
{
  "mcpServers": {
    "vitally": {
      "command": "node",
      "args": [
        "/Users/yourname/vitally-mcp-enhanced/build/index.js"
      ],
      "env": {
        "VITALLY_API_SUBDOMAIN": "https://medscout.rest.vitally.io",
        "VITALLY_API_KEY": "your_api_key_here",
        "VITALLY_DATA_CENTER": "US"
      }
    }
  }
}
```

**Important:**
- Replace `/Users/yourname/bin/vitally-mcp-arm64` with YOUR actual binary path
- Use `vitally-mcp-x64` if you downloaded the Intel/Linux version
- Replace `your_api_key_here` with your actual Vitally API key

#### Step 3: Restart Claude Desktop

Quit Claude Desktop completely and reopen it.

---

### Method 3: Request Pre-Built Package from IT

**Best for:** Enterprise users with IT support

Ask your IT team to:
1. Build the package once on a machine with Node.js
2. Share the `build/` folder and `node_modules/` folder
3. You just need to point Claude Desktop to the build/index.js file

---

## 🔑 Getting Your Vitally API Key

Before configuring, you need a Vitally API key:

1. **Log in to Vitally** (https://medscout.vitally.io or your org's URL)
2. Click **Settings** (⚙️) in the sidebar
3. Go to **Integrations**
4. Find **"Vitally REST API"**
5. Toggle it **ON** (may require admin permissions)
6. Copy the **Secret Token** - starts with `sk_live_` followed by a long string
7. Use this in your configuration where it says `your_api_key_here`

---

## 📝 How to Edit the Config File

### Mac:

**Option 1 - TextEdit:**
1. Open Finder
2. Press `Cmd + Shift + G`
3. Paste: `~/Library/Application Support/Claude/`
4. Open `claude_desktop_config.json` in TextEdit

**Option 2 - Terminal:**
```bash
open -e ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Windows:

**Option 1 - Notepad:**
1. Press `Win + R`
2. Type: `%APPDATA%\Claude`
3. Open `claude_desktop_config.json` in Notepad

**Option 2 - Command Prompt:**
```cmd
notepad %APPDATA%\Claude\claude_desktop_config.json
```

---

## ✅ Verification

After installation and restart, test it:

1. Open Claude Desktop
2. Start a new conversation
3. Ask: **"What Vitally tools are available?"**
4. You should see these tools listed:
   - `search_accounts`
   - `get_account_details`
   - `get_account_key_metrics`
   - `list_custom_traits`
   - `update_account_traits`
   - `search_accounts_by_trait`
   - And more!

5. Try a real query: **"Search for SI-BONE in Vitally"**

---

## 🚨 Troubleshooting

### Error: "command not found: docker"
**Problem:** Docker is not installed or not running

**Solution:**
- Install Docker Desktop from https://www.docker.com/products/docker-desktop
- Make sure Docker Desktop is running (you'll see a whale icon in your menu bar/system tray)

---

### Error: "command not found: node"
**Problem:** Method 2 requires Node.js but you don't have it

**Solution:**
- Use Method 1 (Docker) instead - it doesn't require Node.js
- Or install Node.js from https://nodejs.org (choose LTS version)

---

### Error: "Invalid API Token"
**Problem:** Your API key is wrong or not enabled in Vitally

**Solution:**
1. Go back to Vitally → Settings → Integrations → REST API
2. Make sure it's **enabled** (toggled ON)
3. Copy the Secret Token again (don't use the API key shown elsewhere)
4. Make sure you copied the ENTIRE key (no spaces at start/end)
5. Replace `your_api_key_here` in the config with your actual key

---

### Error: "Cannot find module"
**Problem:** Using Method 2 but the path is wrong

**Solution:**
- Make sure you're using the ABSOLUTE path (starts with `/Users/` on Mac or `C:\` on Windows)
- Check that `build/index.js` actually exists in that folder
- If using Mac, the path should look like: `/Users/yourname/vitally-mcp-enhanced/build/index.js`

---

### MCP Not Showing Up in Claude Desktop
**Problem:** Config might have syntax errors

**Solution:**
1. Check your JSON syntax - must have correct commas, quotes, brackets
2. Use a JSON validator: https://jsonlint.com
3. Make sure you didn't accidentally delete any brackets when pasting
4. Completely quit Claude Desktop (not just close the window) and reopen

**Example of CORRECT JSON:**
```json
{
  "mcpServers": {
    "vitally": {
      "command": "docker",
      "args": ["run", "--rm", "-i"],
      "env": {
        "VITALLY_API_KEY": "your_vitally_api_key_here"
      }
    }
  }
}
```

---

### Still Having Issues?

**Check the Claude Desktop logs:**

**Mac:**
```bash
tail -f ~/Library/Logs/Claude/mcp*.log
```

**Windows:**
```cmd
type %APPDATA%\Claude\logs\mcp*.log
```

Look for error messages about the Vitally MCP.

---

## 🎉 Success!

Once it's working, you can ask Claude Desktop things like:

- "What's SI-BONE's last CSM pulse status?"
- "Show me all key metrics for [account name]"
- "Find all accounts with Healthy CSM pulse"
- "List all custom traits available in Vitally"
- "Search for accounts in the Strategic segment"

---

## 📚 More Help

- **Full Documentation:** See [MEDSCOUT_ENHANCEMENTS.md](MEDSCOUT_ENHANCEMENTS.md)
- **Quick Reference:** See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Developer Install:** See [INSTALLATION.md](INSTALLATION.md)

---

## Summary: Which Method Should I Use?

| Your Situation | Best Method |
|----------------|-------------|
| I don't have npm/Node.js | **Method 1: Docker** |
| I don't want to install anything | **Method 1: Docker** |
| I have npm but want simple install | **Method 1: Docker** |
| I don't want Docker | **Method 2: Pre-Built Package** (requires Node.js) |
| I'm in an enterprise with IT support | **Method 3: Request from IT** |

**TL;DR: Use Docker (Method 1) - it's the easiest!**
