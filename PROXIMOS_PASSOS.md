# Próximos Passos - Home Assistant no G9

Parabéns! Seu Home Assistant está instalado e operacional no G9.

## Acesso

- **Web**: http://192.168.0.84:8123
- **Local**: http://homeassistant.local:8123
- **App Mobile**: Disponível na App Store / Google Play

---

## 1. Primeiros Passos

### Configuração Inicial
- ✅ Conta criada
- ✅ Nome da casa definido
- ✅ Localização configurada

### Recomendações Imediatas

1. **Configurar Backup Automático**
   - Vá em: **Configurações → Sistema → Backups**
   - Configure backups automáticos diários
   - Você tem 506GB de espaço!

2. **Habilitar Acesso SSH** (opcional)
   - Vá em: **Configurações → Add-ons**
   - Procure "Terminal & SSH"
   - Instale e configure

3. **Atualizar o Sistema**
   - Vá em: **Configurações → Sistema → Atualizações**
   - Verifique se há atualizações disponíveis

---

## 2. Add-ons Úteis Para Instalar

Acesse: **Configurações → Add-ons → Loja de Add-ons**

### Essenciais
- **File Editor** - Editar arquivos de configuração pela web
- **Terminal & SSH** - Acesso terminal ao sistema
- **Samba share** - Compartilhar arquivos na rede

### Avançados
- **Node-RED** - Automações visuais avançadas
- **InfluxDB + Grafana** - Gráficos e dashboards personalizados
- **ESPHome** - Integração com dispositivos ESP32/ESP8266
- **Frigate** - Detecção de objetos em câmeras (IA)
- **AdGuard Home** - Bloqueador de ads na rede
- **Mosquitto broker** - Servidor MQTT

### Backup e Manutenção
- **Google Drive Backup** - Backup na nuvem
- **Portainer** - Gerenciar containers Docker

---

## 3. Integrações Populares

Acesse: **Configurações → Dispositivos e Serviços → Adicionar Integração**

### Dispositivos Locais
- **HACS** - Community Store (add-ons e integrações extras)
- **Tuya** - Dispositivos Wi-Fi Tuya/Smart Life
- **Shelly** - Interruptores e relés Shelly
- **Philips Hue** - Lâmpadas Hue
- **Xiaomi Gateway** - Sensores Xiaomi/Aqara
- **TP-Link** - Dispositivos TP-Link/Kasa
- **Sonoff** - Dispositivos Sonoff (via Tasmota/ESPHome)

### Serviços Online
- **Google Calendar** - Automações baseadas em calendário
- **IFTTT** - Conectar outros serviços
- **Spotify** - Controle de música
- **Telegram** - Notificações e controle via bot

### Mídia
- **Plex / Jellyfin** - Servidores de mídia
- **YouTube Music** - Controle de música
- **Universal Media Player** - Controle TV/receivers

### Clima e Energia
- **OpenWeatherMap** - Previsão do tempo
- **Met.no** - Previsão meteorológica (gratuito)
- **Electricity Maps** - Dados de energia

---

## 4. Primeiras Automações

### Exemplos Simples

**Notificação de Boas-Vindas:**
```yaml
alias: Boas-vindas quando chegar em casa
trigger:
  - platform: state
    entity_id: person.seu_nome
    to: "home"
action:
  - service: notify.mobile_app
    data:
      message: "Bem-vindo em casa!"
```

**Ligar luzes ao anoitecer:**
```yaml
alias: Luzes ao anoitecer
trigger:
  - platform: sun
    event: sunset
action:
  - service: light.turn_on
    target:
      entity_id: light.sala
```

---

## 5. Recursos do G9 - 512GB de Espaço!

Com tanto espaço disponível, você pode:

### Câmeras de Segurança
- **Frigate NVR** - Gravação 24/7 com detecção de objetos
- Armazene **semanas** de gravação em alta qualidade
- Detecção de pessoas, carros, animais com IA

### Banco de Dados Histórico
- **InfluxDB** - Armazene anos de dados de sensores
- **Grafana** - Visualize tendências e padrões
- Análise de consumo de energia, temperatura, etc

### Backups Robustos
- Mantenha **meses** de backups locais
- Configure backups automáticos diários
- Snapshots antes de cada atualização

### Mídia Local
- Armazene imagens de câmeras
- TTS (Text-to-Speech) cache
- Thumbnails de dispositivos

---

## 6. Manutenção e Monitoramento

### Verificar Saúde do Sistema

**Via Web UI:**
- **Configurações → Sistema → Informações**
- Veja uso de CPU, RAM, disco

**Via SSH (se habilitado):**
```bash
ha core info
ha supervisor info
ha host info
ha os info
```

### Backups Regulares

**Criar backup manual:**
- **Configurações → Sistema → Backups → Criar Backup**

**Via SSH:**
```bash
ha backups new --name "backup-manual"
ha backups list
```

### Atualizações

- Home Assistant libera atualizações **mensalmente**
- Sempre faça **backup antes de atualizar**
- Leia as **release notes** antes de atualizar

---

## 7. Segurança

### Recomendações

1. **Não exponha diretamente na internet**
   - Use VPN (WireGuard, Tailscale)
   - Ou Nabu Casa Cloud (oficial, pago)

2. **Senhas fortes**
   - Use senhas únicas
   - Habilite 2FA quando disponível

3. **Backups offsite**
   - Configure backup para Google Drive
   - Ou NAS externo

4. **Atualizações**
   - Mantenha o sistema atualizado
   - Assine notificações de segurança

---

## 8. Recursos e Comunidade

### Documentação
- **Oficial**: https://www.home-assistant.io/docs/
- **Fórum**: https://community.home-assistant.io/
- **Reddit**: r/homeassistant

### YouTube (Português)
- **Manual do Maker** - Tutoriais HA em PT-BR
- **Gabriel Costa** - Projetos de automação
- **Home Assistant Brasil** - Comunidade brasileira

### Grupos Brasil
- **Telegram**: Home Assistant Brasil
- **Facebook**: Home Assistant Brasil

---

## 9. Monitoramento do Hardware G9

### Adicionar Monitoramento

Instale a integração **System Monitor**:

**Configurações → Dispositivos e Serviços → Adicionar Integração → System Monitor**

Monitore:
- Uso de CPU
- Uso de RAM
- Espaço em disco (512GB total)
- Temperatura do sistema
- Tráfego de rede

### Criar Dashboard de Sistema

Crie cards para visualizar:
- Temperatura do G9
- Uso de disco (você tem 506GB livres!)
- Uptime do sistema
- Velocidade da rede

---

## 10. Ideias de Projetos

### Iniciante
- Controlar luzes remotamente
- Automação de boa noite (desligar tudo)
- Notificações de eventos (porta aberta, etc)

### Intermediário
- Presença inteligente (detectar quem está em casa)
- Controle de temperatura/AC
- Dashboard de clima e consumo

### Avançado
- Sistema de segurança com câmeras + IA
- Controle de energia solar/bateria
- Integração com assistentes de voz
- Dashboards personalizados para tablets

---

## Especificações do Seu G9

- **IP**: 192.168.0.84
- **Disco**: JUMPER 512G NVMe
- **Sistema**: Home Assistant OS 13.2
- **Espaço Disponível**: 506GB para dados
- **Rede**: Ethernet (E0:51:08:1A:5A:31)

**Seu G9 está pronto para ser um poderoso hub de automação residencial!** 🏠✨

---

Precisa de ajuda? Consulte os outros arquivos:
- [INSTALL_HOMEASSISTANT.md](INSTALL_HOMEASSISTANT.md) - Guia de instalação
- [COMANDOS_UTEIS.md](COMANDOS_UTEIS.md) - Comandos úteis e troubleshooting
