#!/bin/bash
set -e

# Vitally MCP One-Line Installer for Claude Desktop
# Usage: curl -fsSL https://raw.githubusercontent.com/mattfdigio/vitally-mcp-distribution/master/install.sh | bash

echo "🚀 Vitally MCP Installer for Claude Desktop"
echo ""

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    BINARY_NAME="vitally-mcp-arm64"
    echo "✓ Detected Apple Silicon Mac"
elif [ "$ARCH" = "x86_64" ]; then
    BINARY_NAME="vitally-mcp-x64"
    echo "✓ Detected Intel Mac"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

# Create installation directory
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Download binary
echo ""
echo "📦 Downloading $BINARY_NAME..."
DOWNLOAD_URL="https://github.com/mattfdigio/vitally-mcp-distribution/releases/latest/download/$BINARY_NAME"
curl -L -o "$INSTALL_DIR/vitally-mcp" "$DOWNLOAD_URL"

# Make executable and remove quarantine
echo "🔧 Setting permissions..."
chmod +x "$INSTALL_DIR/vitally-mcp"
xattr -d com.apple.quarantine "$INSTALL_DIR/vitally-mcp" 2>/dev/null || true

# Get API credentials
echo ""
echo "🔑 Vitally API Configuration"
echo ""
read -p "Enter your Vitally API subdomain (e.g., medscout): " SUBDOMAIN
read -p "Enter your Vitally API key: " API_KEY
read -p "Enter your Vitally data center (US or EU, default US): " DATA_CENTER
DATA_CENTER=${DATA_CENTER:-US}

# Construct full subdomain URL
if [[ "$SUBDOMAIN" == https://* ]]; then
    SUBDOMAIN_URL="$SUBDOMAIN"
else
    SUBDOMAIN_URL="https://${SUBDOMAIN}.rest.vitally.io"
fi

# Create Claude Desktop config directory if it doesn't exist
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
mkdir -p "$CLAUDE_CONFIG_DIR"

# Check if config file exists and has content
if [ -f "$CLAUDE_CONFIG_FILE" ] && [ -s "$CLAUDE_CONFIG_FILE" ]; then
    echo ""
    echo "⚠️  Claude Desktop config file already exists."
    echo "You'll need to manually add the Vitally MCP configuration."
    echo ""
    echo "Add this to your mcpServers section in:"
    echo "$CLAUDE_CONFIG_FILE"
    echo ""
    echo '"vitally": {'
    echo "  \"command\": \"$INSTALL_DIR/vitally-mcp\","
    echo '  "args": [],'
    echo '  "env": {'
    echo "    \"VITALLY_API_SUBDOMAIN\": \"$SUBDOMAIN_URL\","
    echo "    \"VITALLY_API_KEY\": \"$API_KEY\","
    echo "    \"VITALLY_DATA_CENTER\": \"$DATA_CENTER\""
    echo '  }'
    echo '}'
    echo ""
    read -p "Press Enter to open the config file in TextEdit..."
    open -e "$CLAUDE_CONFIG_FILE"
else
    # Create new config file
    echo "📝 Creating Claude Desktop configuration..."
    cat > "$CLAUDE_CONFIG_FILE" <<EOF
{
  "mcpServers": {
    "vitally": {
      "command": "$INSTALL_DIR/vitally-mcp",
      "args": [],
      "env": {
        "VITALLY_API_SUBDOMAIN": "$SUBDOMAIN_URL",
        "VITALLY_API_KEY": "$API_KEY",
        "VITALLY_DATA_CENTER": "$DATA_CENTER"
      }
    }
  }
}
EOF
    echo "✓ Configuration file created"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "📍 Binary installed at: $INSTALL_DIR/vitally-mcp"
echo "📍 Config file at: $CLAUDE_CONFIG_FILE"
echo ""
echo "Next steps:"
echo "1. Quit Claude Desktop completely (Cmd + Q)"
echo "2. Reopen Claude Desktop"
echo "3. Test by asking: 'What Vitally tools are available?'"
echo ""
