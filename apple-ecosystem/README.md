# Apple Ecosystem - Mac Studio Servidor Central

Configuracao completa do ecossistema Apple com Mac Studio como servidor central.

## Arquitetura

```
                    ┌─────────────────────┐
                    │  Mac Studio Server  │
                    │  (MacStudio-Server) │
                    ├─────────────────────┤
                    │ Screen Sharing :5900│
                    │ SSH            :22  │
                    │ SMB            :445 │
                    │ Content Cache       │
                    │ Time Machine Server │
                    └────────┬────────────┘
                             │ LAN (192.168.0.x)
          ┌──────────────────┼──────────────────┐
          │                  │                  │
    ┌─────┴─────┐     ┌─────┴─────┐     ┌─────┴─────┐
    │  MacBook  │     │  iPhone   │     │   iPad    │
    │  (client) │     │  (client) │     │  (client) │
    └───────────┘     └───────────┘     └───────────┘

    Mac Studio ──Time Machine──> NAS (192.168.0.100)
```

## Estrutura

```
apple-ecosystem/
├── scripts/
│   ├── setup-mac-studio-server.sh    # Setup inicial do servidor
│   ├── setup-backup-studio-to-nas.sh # Backup Mac Studio → NAS
│   ├── gerar-perfil-email.sh         # Gera .mobileconfig com 10 emails
│   ├── manutencao-studio.sh          # Limpeza e manutencao semanal
│   └── verificar-backups-devices.sh  # Verifica backups de todos devices
├── profiles/
│   ├── cliente-padrao.mobileconfig   # Perfil padrao (Wi-Fi + seguranca)
│   └── emails-studio.mobileconfig    # Gerado pelo script de email
└── README.md
```

## Ordem de Execucao

### 1. Mac Studio (servidor)
```bash
sudo bash scripts/setup-mac-studio-server.sh
```

### 2. Configurar emails
```bash
# Edite o array CONTAS[] no script com seus emails reais
nano scripts/gerar-perfil-email.sh
bash scripts/gerar-perfil-email.sh
```

### 3. Configurar backup do Studio → NAS
```bash
# Edite NAS_IP, NAS_USER, NAS_SHARE no script
sudo bash scripts/setup-backup-studio-to-nas.sh
```

### 4. Instalar perfis nos devices clientes
- Edite `profiles/cliente-padrao.mobileconfig` (SSID Wi-Fi, senha)
- Envie por AirDrop para cada device
- iPhone/iPad: Settings > Profile Downloaded > Install
- Mac: Duplo-clique > System Settings > Profiles > Install
- Faca o mesmo com o `profiles/emails-studio.mobileconfig`

### 5. Manutencao (semanal)
```bash
sudo bash scripts/manutencao-studio.sh
bash scripts/verificar-backups-devices.sh
```

## O que cada script configura

| Script | Servicos |
|--------|----------|
| `setup-mac-studio-server.sh` | Screen Sharing, SSH, SMB, Content Cache, TM Server, Firewall, Wake-on-LAN, Bonjour |
| `setup-backup-studio-to-nas.sh` | Time Machine → NAS via SMB, exclusoes otimizadas |
| `gerar-perfil-email.sh` | 10 contas IMAP/SMTP em um unico .mobileconfig |
| `manutencao-studio.sh` | Limpa caches, verifica disco, updates, servicos |
| `verificar-backups-devices.sh` | Status TM, NAS, iCloud, espaco em disco |

## Antes de executar

1. **Edite** `gerar-perfil-email.sh` com seus 10 emails reais
2. **Edite** `cliente-padrao.mobileconfig` com SSID e senha do Wi-Fi
3. **Edite** `setup-backup-studio-to-nas.sh` com IP e credenciais do NAS
4. Para Gmail, gere App Passwords em https://myaccount.google.com/apppasswords
