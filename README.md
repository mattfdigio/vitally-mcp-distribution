# Vitally MCP - Pre-Built Binaries for Claude Desktop

Easy installation of Vitally MCP for Claude Desktop without requiring Node.js or npm.

## Quick Start

### 🚀 One-Line Installer (Recommended)

**Run this in Terminal:**

1. Open **Terminal** (press `Cmd + Space`, type "Terminal", press Enter)
2. Paste this command and press Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/mattfdigio/vitally-mcp-distribution/master/install.sh | bash
```

3. When prompted, enter your Vitally API credentials (or press Enter to use placeholders)
4. Follow the instructions to open and edit the config file with your API key
5. Restart Claude Desktop (Cmd+Q, then reopen)

**What this does:**
- Auto-detects your Mac type (Apple Silicon or Intel)
- Downloads the correct binary to `~/.local/bin/vitally-mcp`
- Adds the Vitally MCP to your Claude Desktop config
- Provides instructions for adding your API key

**Where to get your API key:**
1. Log in to Vitally
2. Settings → Integrations → Vitally REST API → Enable
3. Copy the Secret Token (starts with `sk_live_`)

### 📦 Manual Installation

Choose your installation method:

#### Option 1: Pre-Built Binaries

**Mac with Apple Silicon (M1/M2/M3/M4):**
```bash
# Download the binary
curl -L -o vitally-mcp https://github.com/mattfdigio/vitally-mcp-distribution/releases/latest/download/vitally-mcp-arm64

# Make it executable
chmod +x vitally-mcp

# Move to a permanent location
mkdir -p ~/bin
mv vitally-mcp ~/bin/
```

**Mac with Intel or Linux:**
```bash
# Download the binary
curl -L -o vitally-mcp https://github.com/mattfdigio/vitally-mcp-distribution/releases/latest/download/vitally-mcp-x64

# Make it executable
chmod +x vitally-mcp

# Move to a permanent location
mkdir -p ~/bin
mv vitally-mcp ~/bin/
```

#### Option 2: Docker

```bash
docker pull mattfdigio/vitally-mcp-enhanced:latest
```

## Configuration

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json`):

**Using Binary:**
```json
{
  "mcpServers": {
    "vitally": {
      "command": "/Users/yourname/bin/vitally-mcp",
      "args": [],
      "env": {
        "VITALLY_API_SUBDOMAIN": "https://your-org.rest.vitally.io",
        "VITALLY_API_KEY": "your_api_key_here",
        "VITALLY_DATA_CENTER": "US"
      }
    }
  }
}
```

**Using Docker:**
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
        "VITALLY_API_SUBDOMAIN": "https://your-org.rest.vitally.io",
        "VITALLY_API_KEY": "your_api_key_here",
        "VITALLY_DATA_CENTER": "US"
      }
    }
  }
}
```

Replace:
- `your-org` with your Vitally subdomain
- `your_api_key_here` with your actual Vitally API key

## Getting Your API Key

1. Log in to Vitally
2. Go to Settings → Integrations
3. Enable "Vitally REST API"
4. Copy the Secret Token

## Full Documentation

See [INSTALL.md](INSTALL.md) for complete installation instructions, troubleshooting, and advanced configuration.

## Features

- 🔍 Search and retrieve Vitally account data
- 📊 Access account health scores and metrics
- 👥 Search users and manage custom traits
- 💬 View conversations and notes
- 🎯 Filter accounts by custom trait values
- 🚀 No npm/Node.js required with pre-built binaries

## Support

For issues or questions, please open an issue on this repository.

## License

MIT
