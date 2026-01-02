# Guia Completo: Home Assistant OS no GMKtec NucBox G9

## Índice
1. [Preparação](#preparação)
2. [Download do Home Assistant OS](#download-do-home-assistant-os)
3. [Criar Pendrive Bootável](#criar-pendrive-bootável)
4. [Instalação no NucBox G9](#instalação-no-nucbox-g9)
5. [Configuração Inicial](#configuração-inicial)
6. [Configurar Dual NIC](#configurar-dual-nic)
7. [Add-ons Essenciais](#add-ons-essenciais)
8. [Monitoramento de Temperatura](#monitoramento-de-temperatura)
9. [Backup e Manutenção](#backup-e-manutenção)

---

## Preparação

### O que você vai precisar:

- ✓ NucBox G9 (com 3 ventoinhas funcionando)
- ✓ Pendrive 8GB+ (será formatado)
- ✓ Teclado e monitor (para instalação inicial)
- ✓ Cabo de rede ethernet
- ✓ Outro computador (para criar o pendrive)

### Especificações do NucBox G9:

```
Processador: Intel N150 (4 cores, 3.6GHz)
RAM: 12GB LPDDR5-4800
Storage: 4x NVMe M.2 slots
Rede: Dual 2.5GbE
Consumo: ~10-15W
```

**Perfeito para Home Assistant 24/7!**

---

## Download do Home Assistant OS

### 1. Baixar a imagem correta:

**Site oficial:** https://www.home-assistant.io/installation/

**Para Intel N150 (x86-64):**

```
Home Assistant OS
→ Generic x86-64
→ Download .img.xz file
```

**Versão:** Escolha a mais recente (ex: `haos_generic-x86-64-11.5.img.xz`)

**Tamanho:** ~500MB compactado

### 2. Verificar o download (opcional mas recomendado):

No Linux:
```bash
sha256sum haos_generic-x86-64-*.img.xz
```

No Windows (PowerShell):
```powershell
Get-FileHash haos_generic-x86-64-*.img.xz -Algorithm SHA256
```

Compare com o hash no site oficial.

---

## Criar Pendrive Bootável

### Opção 1: Windows (Balena Etcher - Mais Fácil!)

**Download Etcher:** https://etcher.balena.io/

**Passos:**
1. Instale e abra o Balena Etcher
2. **Flash from file** → Selecione o arquivo `.img.xz`
3. **Select target** → Selecione o pendrive
4. **Flash!** → Aguarde (5-10 minutos)
5. **Pronto!** Etcher descompacta e grava automaticamente

### Opção 2: Windows (Rufus)

**NÃO use Rufus para Home Assistant!** Balena Etcher é melhor para arquivos `.img`.

### Opção 3: Linux (dd)

```bash
# 1. Descompactar (se necessário)
unxz haos_generic-x86-64-11.5.img.xz

# 2. Identificar o pendrive
lsblk
# Exemplo: /dev/sdb

# 3. Gravar a imagem (CUIDADO: substitua /dev/sdX!)
sudo dd if=haos_generic-x86-64-11.5.img of=/dev/sdX bs=4M status=progress conv=fsync

# 4. Aguardar conclusão
sync
```

**ATENÇÃO:** `dd` apaga TUDO do pendrive! Confira o dispositivo correto com `lsblk`.

### Opção 4: macOS

```bash
# 1. Identificar pendrive
diskutil list
# Exemplo: /dev/disk2

# 2. Desmontar
diskutil unmountDisk /dev/disk2

# 3. Gravar
sudo dd if=haos_generic-x86-64-11.5.img of=/dev/rdisk2 bs=4m

# 4. Ejetar
diskutil eject /dev/disk2
```

---

## Instalação no NucBox G9

### Passo 1: Preparar o NucBox G9

**Escolha onde instalar:**

**Opção A: Usar 1 NVMe pequeno (Recomendado)**
```
Slot 1: 256GB NVMe → Home Assistant OS
Slot 2-4: Livres para storage/VMs futuras
```

**Opção B: Particionar NVMe grande**
```
1x NVMe grande:
├─ 32GB: Home Assistant OS
└─ Resto: Storage (configurar depois)
```

**Minha recomendação:** Use 1 NVMe pequeno dedicado (64-256GB).

### Passo 2: Configurar BIOS

**Entre na BIOS (F2 ao ligar):**

1. **Aba Boot:**
   ```
   Boot Option #1: USB Device
   Boot Option #2: [Seu NVMe]
   ```

2. **Quiet Boot:** Disabled (para ver instalação)

3. **Salvar:** F10 → Yes

### Passo 3: Boot do Pendrive

1. **Desligue** o NucBox G9
2. **Insira** o pendrive bootável
3. **Conecte** cabo ethernet (importante!)
4. **Conecte** monitor e teclado
5. **Ligue** o NucBox G9

**Deve aparecer:**
```
Home Assistant OS
Booting...
```

### Passo 4: Instalação Automática

Home Assistant OS instala **automaticamente**!

**O que acontece:**
```
1. Boot do pendrive
2. Detecta o NVMe
3. Instala automaticamente no NVMe
4. Reinicia automaticamente
5. Remove o pendrive quando pedir
```

**Processo:**
- ⏱️ Tempo: 5-10 minutos
- 🖥️ Você verá texto correndo na tela
- ⚠️ NÃO desligue durante instalação!

**Quando terminar:**
```
[  OK  ] Started Home Assistant OS

Home Assistant
homeassistant login: _
```

**Pronto!** Home Assistant está instalado.

### Passo 5: Primeira inicialização

Após instalação, o sistema reinicia e você verá:

```
[  OK  ] Started Home Assistant.
[  OK  ] Reached target Multi-User System.

homeassistant login: _
```

**NÃO precisa fazer login aqui!** Tudo é feito pela interface web.

**Aguarde 5-10 minutos** para primeira inicialização completa.

---

## Configuração Inicial

### Passo 1: Descobrir o IP do Home Assistant

**Opção A: Olhar no roteador**
- Entre no roteador (geralmente 192.168.1.1)
- Procure dispositivo "homeassistant"
- Anote o IP (ex: 192.168.1.50)

**Opção B: Usar mDNS (mais fácil!)**
- No navegador: `http://homeassistant.local:8123`
- Funciona automaticamente na maioria das redes

**Opção C: Verificar no console**
```bash
# Login no console (opcional)
# Use: root (sem senha)
nmcli device show
```

### Passo 2: Acessar Interface Web

**No navegador (do seu computador ou celular):**

```
http://homeassistant.local:8123
ou
http://192.168.1.50:8123
```

**Primeira vez demora!** Aguarde até aparecer:

```
┌────────────────────────────────────┐
│   Bem-vindo ao Home Assistant      │
│                                    │
│   Preparando sua casa...           │
│   [Barra de progresso]             │
└────────────────────────────────────┘
```

**Tempo:** 5-20 minutos (dependendo do hardware).

### Passo 3: Criar Conta

Quando carregar, verá:

```
┌────────────────────────────────────┐
│   Criar sua conta                  │
├────────────────────────────────────┤
│ Nome: [Seu Nome]                   │
│ Usuário: [seu_usuario]             │
│ Senha: [********]                  │
│ Confirmar senha: [********]        │
│                                    │
│         [Criar Conta]              │
└────────────────────────────────────┘
```

**Preencha:**
- Nome: Seu nome completo
- Usuário: Login (ex: `admin`)
- Senha: **FORTE!** (será exposto na rede)

**Clique:** Criar Conta

### Passo 4: Configurar Casa

```
┌────────────────────────────────────┐
│   Configure sua casa               │
├────────────────────────────────────┤
│ Nome da casa: [Minha Casa]         │
│                                    │
│ Localização: [Auto-detectada]      │
│ ├─ Latitude: -23.5505              │
│ └─ Longitude: -46.6333             │
│                                    │
│ Fuso horário: [America/Sao_Paulo]  │
│                                    │
│ Sistema métrico: [✓]               │
│                                    │
│         [Próximo]                  │
└────────────────────────────────────┘
```

**Ajuste conforme necessário.**

### Passo 5: Compartilhar Dados (opcional)

```
Ajudar a melhorar o Home Assistant?
[✓] Enviar estatísticas anônimas
[ ] Enviar relatórios de erro
```

**Escolha o que preferir** → Próximo

### Passo 6: Descoberta Automática

Home Assistant procura dispositivos na rede:

```
Encontramos estes dispositivos:
├─ Google Cast (Chromecast)
├─ Impressora HP
├─ Smart TV Samsung
└─ Roteador

[Configurar] [Ignorar]
```

**Pode configurar depois!** → Finalizar

### Passo 7: Dashboard Inicial

Pronto! Você verá a interface:

```
┌─────────────────────────────────────────┐
│ ☰ Home Assistant        🔔 👤 ⚙️        │
├─────────────────────────────────────────┤
│                                         │
│  Visão Geral                            │
│                                         │
│  ┌─────────────┐  ┌─────────────┐      │
│  │   Weather   │  │   Climate   │      │
│  │   ☀️ 25°C   │  │   22°C      │      │
│  └─────────────┘  └─────────────┘      │
│                                         │
│  ┌──────────────────────────────┐      │
│  │   System                     │      │
│  │   CPU: 5%   RAM: 2.1GB      │      │
│  └──────────────────────────────┘      │
│                                         │
└─────────────────────────────────────────┘
```

**Parabéns! Home Assistant está funcionando!** 🎉

---

## Configurar Dual NIC

Seu NucBox G9 tem **2 portas ethernet 2.5GbE**. Vamos configurar!

### Caso de Uso 1: Link Aggregation (mais velocidade)

**Combina 2 NICs = 5Gbps teórico**

**Requer:** Roteador/switch com suporte a LACP

**Configuração:**
1. No HA, vá em **Settings** → **System** → **Network**
2. Clique no **⚙️** da interface
3. **Method:** LACP (802.3ad)
4. Selecione ambas interfaces
5. **Save**

### Caso de Uso 2: Rede Separada IoT (recomendado!)

**NIC 1:** Rede principal (192.168.1.x)
**NIC 2:** Rede IoT isolada (192.168.2.x)

**Por quê?**
- Segurança: dispositivos IoT isolados
- Performance: tráfego separado
- VLAN: Home Assistant pode rotear

**Configuração manual (via console):**

```bash
# Login no console (conecte monitor/teclado)
# Login: root (sem senha)

# Editar configuração de rede
nmcli connection show

# Configurar segunda interface
nmcli con add type ethernet ifname end1 con-name IoT \
  ipv4.method manual \
  ipv4.addresses 192.168.2.1/24 \
  ipv4.gateway 192.168.2.1

nmcli con up IoT
```

**No roteador:**
- Crie VLAN 2 para IoT
- Conecte NIC 2 na porta com VLAN 2

### Caso de Uso 3: Failover (redundância)

Uma NIC falha, outra assume automaticamente.

**Já funciona por padrão!** Home Assistant detecta automaticamente.

---

## Add-ons Essenciais

Add-ons expandem funcionalidades do Home Assistant.

**Como instalar:**
1. **Settings** → **Add-ons** → **Add-on Store**
2. Procure o add-on
3. **Install**
4. **Start**
5. **Enable** "Start on boot"

### Add-ons Recomendados:

#### 1. **File Editor** (ESSENCIAL!)
```
Função: Editar arquivos de configuração
Por quê: Facilita muito customização
Uso: Editar configuration.yaml, automations.yaml
```

#### 2. **Samba Share**
```
Função: Compartilhamento de arquivos (SMB)
Por quê: Acessar arquivos do HA via rede
Uso: Backups, configs, logs
Config: Settings → Add-ons → Samba → Configuration
  username: seu_usuario
  password: sua_senha
```

#### 3. **Terminal & SSH**
```
Função: Acesso SSH ao sistema
Por quê: Comandos avançados, troubleshooting
Uso: ssh root@homeassistant.local
Config: Definir senha de SSH
```

#### 4. **AdGuard Home**
```
Função: Bloqueio de ads em toda rede
Por quê: Pi-hole integrado ao HA
Uso: DNS 192.168.1.50
```

#### 5. **Mosquitto broker**
```
Função: MQTT broker para IoT
Por quê: Comunicação com dispositivos Zigbee/Tasmota
Uso: Essencial para automação
```

#### 6. **Zigbee2MQTT** (se tiver dispositivos Zigbee)
```
Função: Integração Zigbee sem hub proprietário
Requer: Dongle Zigbee USB (ex: Sonoff 3.0)
```

#### 7. **Frigate** (se tiver câmeras IP)
```
Função: NVR com detecção AI
Atenção: Usa MUITA CPU/RAM!
Config: Google Coral TPU recomendado
```

#### 8. **Studio Code Server**
```
Função: Editor de código completo (VSCode)
Melhor que: File Editor
Uso: Desenvolvimento avançado
```

#### 9. **InfluxDB + Grafana**
```
Função: Monitoramento histórico + dashboards
Uso: Temperatura, uso de recursos, sensores
```

#### 10. **ESPHome**
```
Função: Programar dispositivos ESP32/ESP8266
Uso: DIY sensors, switches, automação custom
```

---

## Monitoramento de Temperatura

**CRUCIAL** para NucBox G9 (histórico de superaquecimento).

### 1. Via Add-on: Glances

**Instalar:**
```
Settings → Add-ons → Add-on Store
Procure: "Glances"
Install → Start → Enable "Start on boot"
```

**Acessar:**
```
http://homeassistant.local:61208
```

**Mostra:**
- Temperatura CPU
- Uso CPU/RAM/Disk
- Rede em tempo real
- Processos

### 2. Integração nativa: System Monitor

**Ativar:**
```
Settings → Devices & Services → Add Integration
Procure: "System Monitor"
Selecione métricas:
  ✓ Processor temperature
  ✓ Processor use
  ✓ Memory use percentage
  ✓ Disk use percentage
  ✓ Network throughput
```

**Resultado:** Sensores aparecem no HA!

**Criar dashboard:**

```yaml
# No Lovelace Dashboard
type: entities
title: System Monitor
entities:
  - sensor.processor_temperature
  - sensor.processor_use_percent
  - sensor.memory_use_percent
  - sensor.disk_use_percent
```

### 3. Automação: Alerta de Temperatura

**Criar automação para avisar se aquecer:**

```yaml
# Settings → Automations → Create Automation → Blank

alias: Alerta Temperatura Alta
trigger:
  - platform: numeric_state
    entity_id: sensor.processor_temperature
    above: 75  # Celsius
    for:
      minutes: 5
action:
  - service: notify.notify
    data:
      title: "⚠️ Temperatura Alta!"
      message: "CPU está em {{ states('sensor.processor_temperature') }}°C"
```

**Clique:** Save

**Temperatura segura N150:**
- Normal: 40-60°C
- Aceitável: 60-75°C
- ⚠️ Alto: 75-85°C
- 🔥 Perigo: >85°C

### 4. Monitoramento Avançado: Netdata

**Instalar via Docker (depois de habilitar Advanced Mode):**

```bash
# Via Terminal & SSH addon
docker run -d \
  --name=netdata \
  --restart=unless-stopped \
  -p 19999:19999 \
  -v /etc/os-release:/host/etc/os-release:ro \
  --cap-add SYS_PTRACE \
  netdata/netdata
```

**Acessar:**
```
http://homeassistant.local:19999
```

**Melhor dashboard de monitoramento!**

---

## Backup e Manutenção

### Backup Automático

**Configurar:**
```
Settings → System → Backups
→ Create backup
→ Configure automatic backups
  Frequency: Daily
  Time: 03:00
  Keep: 7 days
```

**Salvar em:**
1. **USB externo** (conectar no NucBox)
2. **NAS** via Samba
3. **Google Drive** (add-on "Google Drive Backup")

### Add-on: Google Drive Backup

```
Add-on Store → Google Drive Backup
Install → Start
Configure → Authenticate with Google
```

**Backup automático na nuvem!**

### Updates

**Home Assistant atualiza sozinho!**

**Verificar:**
```
Settings → System → Updates
```

**Update manual:**
```
Click em "Update" quando disponível
Aguarde reinicialização (~5 min)
```

**Snapshot antes de update:** Sempre recomendado!

---

## Próximos Passos

### Agora que está instalado:

#### 1. **Integrar dispositivos:**
```
Settings → Devices & Services → Add Integration
Exemplos:
  - Google Cast (Chromecast)
  - Spotify
  - MQTT
  - Philips Hue
  - Tuya Smart Life
```

#### 2. **Criar automações:**
```
Settings → Automations & Scenes
Exemplos:
  - Acender luz ao pôr do sol
  - Notificação de porta aberta
  - Economia de energia
```

#### 3. **Personalizar dashboard:**
```
Overview → ⋮ → Edit Dashboard
Adicione cards:
  - Weather
  - Media players
  - Cameras
  - Custom cards (HACS)
```

#### 4. **Instalar HACS** (Home Assistant Community Store):
```
Terminal & SSH addon:
wget -O - https://get.hacs.xyz | bash -
Restart Home Assistant
Settings → Devices & Services → Add Integration → HACS
```

**HACS = Milhares de integrações custom!**

#### 5. **Comprar dispositivos:**
```
Recomendados:
  - Dongle Zigbee: Sonoff 3.0 (~$15)
  - Smart plugs: Tasmota/Zigbee
  - Sensores: Aqara (temp/porta/movimento)
  - Lâmpadas: Philips Hue ou Zigbee genéricas
```

---

## Solução de Problemas

### "Não consigo acessar http://homeassistant.local:8123"

**Solução 1:** Use IP direto
```bash
# Descobrir IP no console
ip addr show
# Acesse: http://[IP]:8123
```

**Solução 2:** mDNS não funciona no Windows
```
Instale: Bonjour Print Services (Apple)
Ou use IP direto
```

**Solução 3:** Firewall bloqueando
```
Desabilite firewall temporariamente
Ou libere porta 8123
```

### "Home Assistant não inicia após update"

**Restaurar backup:**
```
Boot em Safe Mode:
  - Reboot HA
  - Acesse: http://homeassistant.local:4357
  - Restore backup anterior
```

### "NVMe não detectado na instalação"

**Verifique BIOS:**
```
SATA Mode: AHCI (não IDE)
NVMe deve aparecer em Boot Priority
```

**Teste outro slot M.2**

### "Sistema lento/travando"

**Verificar:**
```
System Monitor:
  - RAM >90%? (desabilite add-ons pesados)
  - Disk >90%? (limpe backups antigos)
  - CPU 100%? (remova Frigate ou similar)
```

**Limpar logs:**
```bash
# Terminal & SSH
ha core logs --clear
```

---

## Recursos e Links Úteis

### Documentação:
- **Oficial:** https://www.home-assistant.io/docs/
- **Community:** https://community.home-assistant.io/
- **YouTube:** https://www.youtube.com/@HomeAssistant

### Integrações Populares:
- **Alexa:** Controle por voz Amazon
- **Google Assistant:** Controle por voz Google
- **Spotify:** Controle música
- **Node-RED:** Automações visuais avançadas
- **Telegram:** Notificações e controle

### Hardware Recomendado:
- **Zigbee USB:** Sonoff ZBDongle-E (~$15)
- **Z-Wave USB:** Aeotec Z-Stick 7 (~$50)
- **Google Coral TPU:** Para Frigate (~$60)

### Apps Mobile:
- **iOS:** Home Assistant (App Store)
- **Android:** Home Assistant (Play Store)

---

## Checklist Final

Após instalação, verifique:

- [ ] Home Assistant acessível via navegador
- [ ] Conta criada e login funcionando
- [ ] Localização/fuso configurado corretamente
- [ ] Add-ons básicos instalados (File Editor, SSH, Samba)
- [ ] Monitoramento de temperatura configurado
- [ ] Backup automático ativado
- [ ] Sistema atualizado (última versão)
- [ ] Dual NIC configurado (se necessário)
- [ ] Temperatura CPU <70°C em idle
- [ ] App mobile instalado e sincronizado

---

## Conclusão

**Parabéns!** Seu NucBox G9 agora é um poderoso servidor Home Assistant!

**Vantagens do seu setup:**
- ✓ Hardware potente (Intel N150)
- ✓ 12GB RAM (muitas automações/add-ons)
- ✓ Dual 2.5GbE (rede rápida)
- ✓ All-flash (silencioso, confiável)
- ✓ Baixo consumo (24/7 econômico)

**Próximos passos:**
1. Explorar add-ons
2. Integrar dispositivos existentes
3. Criar primeiras automações
4. Comprar hardware IoT (Zigbee)
5. Personalizar dashboards

**Divirta-se automatizando sua casa!** 🏠🤖

---

**Criado:** Janeiro 2026
**Hardware:** GMKtec NucBox G9 (Intel N150)
**Software:** Home Assistant OS
**Versão:** 2025.1+
