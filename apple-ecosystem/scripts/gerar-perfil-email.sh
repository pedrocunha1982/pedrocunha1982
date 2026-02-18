#!/bin/bash
# ============================================================================
# GERADOR DE PERFIL .mobileconfig PARA CONTAS DE EMAIL
# ============================================================================
# Gera um perfil Apple que configura todas as 10 contas de email
# de uma vez em qualquer device Apple (iPhone, iPad, Mac)
#
# Uso: bash gerar-perfil-email.sh
# Resultado: apple-ecosystem/profiles/emails-studio.mobileconfig
#
# Depois de gerar, envie o arquivo .mobileconfig por AirDrop ou email
# para cada device e instale.
# ============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE_DIR="$SCRIPT_DIR/../profiles"
OUTPUT="$PROFILE_DIR/emails-studio.mobileconfig"

mkdir -p "$PROFILE_DIR"

# ============================================================================
# CONFIGURE SUAS 10 CONTAS DE EMAIL AQUI
# ============================================================================
# Formato: "NOME_EXIBICAO|EMAIL|SERVIDOR_IMAP|PORTA_IMAP|SERVIDOR_SMTP|PORTA_SMTP|USUARIO|DESCRICAO"
#
# Exemplos comuns:
#   Gmail:     imap.gmail.com:993 / smtp.gmail.com:587
#   Outlook:   outlook.office365.com:993 / smtp.office365.com:587
#   iCloud:    imap.mail.me.com:993 / smtp.mail.me.com:587
#   Yahoo:     imap.mail.yahoo.com:993 / smtp.mail.yahoo.com:587
#   Custom:    mail.seudominio.com:993 / mail.seudominio.com:587
#
# IMPORTANTE: Para Gmail/Google Workspace, use "App Passwords" (nao senha normal)
#             Gere em: https://myaccount.google.com/apppasswords
# ============================================================================

CONTAS=(
    "Studio Principal|studio@seudominio.com|imap.gmail.com|993|smtp.gmail.com|587|studio@seudominio.com|Conta principal do studio"
    "Studio Comercial|comercial@seudominio.com|imap.gmail.com|993|smtp.gmail.com|587|comercial@seudominio.com|Email comercial"
    "Studio Suporte|suporte@seudominio.com|imap.gmail.com|993|smtp.gmail.com|587|suporte@seudominio.com|Email de suporte"
    "Gmail Pessoal|seunome@gmail.com|imap.gmail.com|993|smtp.gmail.com|587|seunome@gmail.com|Gmail pessoal"
    "Outlook Work|seunome@outlook.com|outlook.office365.com|993|smtp.office365.com|587|seunome@outlook.com|Outlook trabalho"
    "iCloud|seunome@icloud.com|imap.mail.me.com|993|smtp.mail.me.com|587|seunome@icloud.com|iCloud Mail"
    "Email 7|email7@dominio.com|imap.gmail.com|993|smtp.gmail.com|587|email7@dominio.com|Conta 7"
    "Email 8|email8@dominio.com|imap.gmail.com|993|smtp.gmail.com|587|email8@dominio.com|Conta 8"
    "Email 9|email9@dominio.com|imap.gmail.com|993|smtp.gmail.com|587|email9@dominio.com|Conta 9"
    "Email 10|email10@dominio.com|imap.gmail.com|993|smtp.gmail.com|587|email10@dominio.com|Conta 10"
)

# ============================================================================
# GERAR PERFIL .mobileconfig (XML plist)
# ============================================================================

# UUID unico para o perfil
PROFILE_UUID=$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")
ORG_NAME="Studio Pedro"

cat > "$OUTPUT" << 'HEADER'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PayloadContent</key>
    <array>
HEADER

# Gerar payload para cada conta de email
CONTA_NUM=0
for conta in "${CONTAS[@]}"; do
    IFS='|' read -r NOME EMAIL IMAP IMAP_PORT SMTP SMTP_PORT USER DESC <<< "$conta"
    PAYLOAD_UUID=$(uuidgen 2>/dev/null || python3 -c "import uuid; print(uuid.uuid4())")
    CONTA_NUM=$((CONTA_NUM + 1))

    cat >> "$OUTPUT" << EMAILPAYLOAD
        <dict>
            <key>PayloadType</key>
            <string>com.apple.mail.managed</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
            <key>PayloadIdentifier</key>
            <string>com.studio.email.conta${CONTA_NUM}</string>
            <key>PayloadUUID</key>
            <string>${PAYLOAD_UUID}</string>
            <key>PayloadDisplayName</key>
            <string>${NOME}</string>
            <key>PayloadDescription</key>
            <string>${DESC}</string>
            <key>PayloadOrganization</key>
            <string>${ORG_NAME}</string>
            <key>EmailAccountDescription</key>
            <string>${DESC}</string>
            <key>EmailAccountName</key>
            <string>${NOME}</string>
            <key>EmailAccountType</key>
            <string>EmailTypeIMAP</string>
            <key>EmailAddress</key>
            <string>${EMAIL}</string>
            <key>IncomingMailServerHostName</key>
            <string>${IMAP}</string>
            <key>IncomingMailServerPortNumber</key>
            <integer>${IMAP_PORT}</integer>
            <key>IncomingMailServerUseSSL</key>
            <true/>
            <key>IncomingMailServerAuthentication</key>
            <string>EmailAuthPassword</string>
            <key>IncomingMailServerUsername</key>
            <string>${USER}</string>
            <key>OutgoingMailServerHostName</key>
            <string>${SMTP}</string>
            <key>OutgoingMailServerPortNumber</key>
            <integer>${SMTP_PORT}</integer>
            <key>OutgoingMailServerUseSSL</key>
            <true/>
            <key>OutgoingMailServerAuthentication</key>
            <string>EmailAuthPassword</string>
            <key>OutgoingMailServerUsername</key>
            <string>${USER}</string>
            <key>OutgoingPasswordSameAsIncomingPassword</key>
            <true/>
            <key>PreventMove</key>
            <false/>
            <key>PreventAppSheet</key>
            <false/>
            <key>disableMailRecentsSyncing</key>
            <false/>
        </dict>
EMAILPAYLOAD

    echo "  [+] Conta $CONTA_NUM: $NOME ($EMAIL)"
done

# Fechar o perfil
cat >> "$OUTPUT" << FOOTER
    </array>
    <key>PayloadDisplayName</key>
    <string>Emails Studio - Configuracao Padrao</string>
    <key>PayloadDescription</key>
    <string>Configura todas as 10 contas de email do studio. Instale em cada device Apple.</string>
    <key>PayloadIdentifier</key>
    <string>com.studio.email.config</string>
    <key>PayloadOrganization</key>
    <string>${ORG_NAME}</string>
    <key>PayloadRemovalDisallowed</key>
    <false/>
    <key>PayloadType</key>
    <string>Configuration</string>
    <key>PayloadUUID</key>
    <string>${PROFILE_UUID}</string>
    <key>PayloadVersion</key>
    <integer>1</integer>
</dict>
</plist>
FOOTER

echo ""
echo "============================================"
echo "  PERFIL DE EMAIL GERADO!"
echo "============================================"
echo ""
echo "  Arquivo: $OUTPUT"
echo "  Contas:  $CONTA_NUM"
echo ""
echo "  Como instalar:"
echo "  --------------------------------"
echo "  iPhone/iPad: Envie por AirDrop ou email"
echo "               Abra > Settings > Profile Downloaded > Install"
echo ""
echo "  Mac:         Duplo-clique no .mobileconfig"
echo "               System Settings > Profiles > Install"
echo ""
echo "  IMPORTANTE: Edite o array CONTAS[] neste script"
echo "  com seus emails reais antes de gerar!"
echo ""
echo "============================================"
