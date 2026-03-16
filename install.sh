#!/bin/bash
set -e

# Vitally MCP One-Line Installer for Claude Desktop
# Usage: Run this in Terminal (NOT in Claude Desktop)
#   curl -fsSL https://raw.githubusercontent.com/mattfdigio/vitally-mcp-distribution/master/install.sh | bash

echo "🚀 Vitally MCP Installer for Claude Desktop"
echo ""
echo "⚠️  Make sure Claude Desktop is CLOSED before continuing"
echo ""
echo "Press Enter to continue (or Ctrl+C to cancel)..."
read -r
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

# Ask if user wants to configure now or later
echo ""
echo "🔑 Vitally API Configuration"
echo ""

echo "You can either:"
echo "  1. Configure your Vitally credentials now"
echo "  2. Add placeholders and configure later"
echo ""
read -p "Configure now? (y/N): " CONFIGURE_NOW
CONFIGURE_NOW=${CONFIGURE_NOW:-n}

if [[ "$CONFIGURE_NOW" =~ ^[Yy]$ ]]; then
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
else
    # Use placeholders
    SUBDOMAIN_URL="https://YOUR_ORG.rest.vitally.io"
    API_KEY="your_vitally_api_key_here"
    DATA_CENTER="US"
    echo ""
    echo "📝 Using placeholders - you'll need to edit the config file later"
fi

# Create Claude Desktop config directory if it doesn't exist
CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
mkdir -p "$CLAUDE_CONFIG_DIR"

# Check if jq is available for JSON manipulation
if command -v jq &> /dev/null; then
    HAS_JQ=true
else
    HAS_JQ=false
fi

# Check if config file exists and has content
if [ -f "$CLAUDE_CONFIG_FILE" ] && [ -s "$CLAUDE_CONFIG_FILE" ]; then
    echo "📝 Updating existing Claude Desktop configuration..."

    if [ "$HAS_JQ" = true ]; then
        # Use jq to merge the configuration
        TEMP_FILE=$(mktemp)
        jq --arg cmd "$INSTALL_DIR/vitally-mcp" \
           --arg subdomain "$SUBDOMAIN_URL" \
           --arg apikey "$API_KEY" \
           --arg dc "$DATA_CENTER" \
           '.mcpServers.vitally = {
              "command": $cmd,
              "args": [],
              "env": {
                "VITALLY_API_SUBDOMAIN": $subdomain,
                "VITALLY_API_KEY": $apikey,
                "VITALLY_DATA_CENTER": $dc
              }
            }' "$CLAUDE_CONFIG_FILE" > "$TEMP_FILE"

        mv "$TEMP_FILE" "$CLAUDE_CONFIG_FILE"
        echo "✓ Configuration automatically merged"
    else
        # Fall back to manual instructions if jq not available
        echo ""
        echo "⚠️  Automatic merge requires 'jq' (not installed)."
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
    fi
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

if [[ ! "$CONFIGURE_NOW" =~ ^[Yy]$ ]]; then
    echo "⚠️  IMPORTANT: You need to add your API key!"
    echo ""
    echo "📝 Opening config file in TextEdit..."
    echo ""
    echo "Look for the 'vitally' section and replace:"
    echo "  1. YOUR_ORG.rest.vitally.io → your actual subdomain (e.g., medscout.rest.vitally.io)"
    echo "  2. your_vitally_api_key_here → your actual API key"
    echo ""
    echo "💡 To get your API key:"
    echo "  1. Go to https://your-org.vitally.io"
    echo "  2. Click Settings → Integrations"
    echo "  3. Find 'Vitally REST API' and enable it"
    echo "  4. Copy the Secret Token (starts with sk_live_)"
    echo ""
    sleep 2
    open -e "$CLAUDE_CONFIG_FILE"
    echo "✓ Config file opened in TextEdit"
    echo ""
    echo "After editing, save the file (Cmd+S) and continue below."
    echo ""
fi

echo "Next steps:"
echo "1. Quit Claude Desktop completely (Cmd + Q)"
echo "2. Reopen Claude Desktop"
echo "3. Test by asking: 'What Vitally tools are available?'"
echo ""
