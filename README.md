# Vitally MCP - Pre-Built Binaries for Claude Desktop

Easy installation of Vitally MCP for Claude Desktop without requiring Node.js or npm.

## Quick Start

### 🚀 One-Line Installer (Easiest)

**Run this in Terminal (NOT Claude Desktop):**

1. Open **Terminal** (press `Cmd + Space`, type "Terminal", press Enter)
2. Paste this command and press Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/mattfdigio/vitally-mcp-distribution/master/install.sh | bash
```

This will:
- Auto-detect your Mac type (Apple Silicon or Intel)
- Download the correct binary
- Add placeholder credentials to Claude Desktop config
- Handle all permissions

**Note:** When run via curl pipe, the installer automatically uses placeholders. You'll need to edit the config file afterward to add your actual Vitally API key. See the instructions printed at the end of installation.

**Alternative - Interactive Install:**
If you want to enter your credentials during installation, download and run the script directly:

```bash
curl -O https://raw.githubusercontent.com/mattfdigio/vitally-mcp-distribution/master/install.sh
bash install.sh
```

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
