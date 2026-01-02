# Configuração do TP-Link Archer BE700 para Home Assistant

Guia completo de configuração do roteador **TP-Link Archer BE700 BE15000 Tri-Band Wi-Fi 7** para uso otimizado com Home Assistant.

## Especificações do Roteador

- **Modelo**: Archer BE700
- **MAC**: 88:7F:F0:07:AD:BB
- **Acesso Web**: http://tplinkwifi.net
- **SSIDs Padrão**:
  - TP-Link_ADBB (2.4GHz/5GHz)
  - TP-Link_ADBB_6G (6GHz - duas redes)

## Recursos Principais

✅ **Wi-Fi 7 Tri-Band** - 15Gbps total
✅ **IoT Network** - Rede dedicada para dispositivos IoT
✅ **10G WAN** + **2.5G LAN** + **2x 1G LAN**
✅ **WPA3 Encryption** - Segurança avançada
✅ **HomeShield** - Proteção de rede
✅ **VPN Client & Server**
✅ **EasyMesh** - Mesh Wi-Fi

---

## 1. IP Fixo para o Home Assistant (G9)

### OPÇÃO A: Via App Tether (RECOMENDADO - Mais Fácil)

1. **Abra o app Tether** no celular
2. Conecte ao roteador Archer BE700
3. Vá em: **Tools** → **Advanced**
4. Navegue até: **Network** → **DHCP Server**
5. Role até: **Address Reservation**
6. Toque em **Add** (+)
7. Configure:
   - **MAC Address**: E0:51:08:1A:5A:31
   - **Reserved IP**: 192.168.0.84
   - **Comment**: Home Assistant G9
8. Salve

### OPÇÃO B: Via Interface Web

1. Acesse: **http://tplinkwifi.net**
2. Faça login (senha padrão na etiqueta do roteador)
3. Vá em: **Advanced** → **Network** → **DHCP Server**
4. Role até: **Address Reservation**
5. Clique em **Add**
6. Configure:
   - **MAC Address**: E0:51:08:1A:5A:31
   - **Reserved IP Address**: 192.168.0.84
   - **Status**: Enabled
   - **Comment**: Home Assistant G9
7. Clique em **Save**

**Resultado**: O G9 sempre terá o IP **192.168.0.84** mesmo após reiniciar!

---

## 2. Rede IoT Dedicada (ALTAMENTE RECOMENDADO)

O Archer BE700 tem uma funcionalidade **IoT Network** perfeita para Home Assistant!

### Por que usar IoT Network?

✅ **Isolamento de segurança** - Separa dispositivos IoT da rede principal
✅ **Comunicação entre dispositivos** - Diferente de Guest Network
✅ **Acesso ao Home Assistant** - IoT pode acessar o G9 na rede principal
✅ **WPA3 + HomeShield** - Segurança reforçada

### Como Configurar IoT Network

#### Via App Tether:

1. Abra **Tether**
2. Vá em: **Tools** → **Advanced**
3. Navegue: **Wireless** → **IoT Network**
4. **Enable IoT Network**: ON
5. Configure:
   - **Network Name (SSID)**: HomeAssistant_IoT
   - **Password**: [senha forte]
   - **Band**: 2.4GHz ou 5GHz (veja recomendações abaixo)
   - **Security**: WPA3-Personal ou WPA2/WPA3
6. Salve

**Escolha da Banda**:
- **2.4GHz**: Maior alcance, melhor compatibilidade com dispositivos antigos
- **5GHz**: Mais rápido, menos interferência, ideal para câmeras e dispositivos modernos
- **Recomendado**: 5GHz se todos dispositivos suportarem

#### Via Interface Web:

1. Acesse: **http://tplinkwifi.net** (ou http://192.168.0.1)
2. Vá em: **Advanced** → **Wireless** → **IoT Network**
3. **Enable IoT Network**: Checked
4. Configure:
   - **Network Name**: HomeAssistant_IoT
   - **Password**: [senha forte]
   - **Wireless Band**: 2.4GHz ou 5GHz (escolha conforme dispositivos)
   - **Security**: WPA3-Personal (ou WPA2/WPA3 para compatibilidade)
5. **Allow IoT devices to communicate with devices on the main network**: Enabled
6. Clique em **Save**

### Dispositivos para conectar na IoT Network:

- Lâmpadas inteligentes (Philips Hue, Yeelight, etc)
- Interruptores Wi-Fi (Shelly, Sonoff, Tuya)
- Sensores (temperatura, porta, movimento)
- Câmeras IP
- Assistentes de voz (Alexa, Google Home)
- Plugues inteligentes
- Termostatos

**IMPORTANTE**: O **G9 (Home Assistant)** fica na **rede principal** com IP fixo. Os dispositivos IoT ficam na **IoT Network** mas podem se comunicar com o G9!

---

## 3. Arquitetura de Rede Recomendada

```
┌─────────────────────────────────────────────────┐
│       TP-Link Archer BE700 (192.168.0.1)        │
└────────────┬────────────────────┬────────────────┘
             │                    │
   ┌─────────┴─────────┐    ┌────┴──────────────┐
   │  REDE PRINCIPAL   │    │   IOT NETWORK     │
   │  (192.168.0.x)    │    │ (HomeAssistant_IoT)│
   └─────────┬─────────┘    └────┬──────────────┘
             │                    │
     ┌───────┴────────┐      ┌────┴───────────────┐
     │ G9 - Home      │      │ Dispositivos IoT:  │
     │ Assistant      │◄─────│ - Lâmpadas         │
     │ 192.168.0.84   │      │ - Sensores         │
     │ (IP FIXO)      │      │ - Câmeras          │
     │                │      │ - Interruptores    │
     └────────────────┘      └────────────────────┘
             │
     ┌───────┴────────┐
     │ Dispositivos   │
     │ Principais:    │
     │ - PCs          │
     │ - Celulares    │
     │ - TVs          │
     │ - NAS          │
     └────────────────┘
```

---

## 4. Outras Configurações Úteis

### A. QoS (Quality of Service) - Priorizar Home Assistant

1. **Advanced** → **NAT Forwarding** → **QoS**
2. **Enable QoS**: ON
3. Adicione regra para o G9:
   - **Device**: 192.168.0.84 (Home Assistant)
   - **Priority**: High
4. Salve

### B. Port Forwarding (se precisar acesso externo via VPN)

**NÃO exponha o Home Assistant direto na internet!**
Use VPN (WireGuard, Tailscale) ou Nabu Casa Cloud.

Se usar VPN:
1. **Advanced** → **NAT Forwarding** → **Virtual Servers**
2. Configure porta da VPN apenas

### C. DNS Customizado

Para melhor privacidade:

1. **Advanced** → **Network** → **DHCP Server**
2. **Primary DNS**: 1.1.1.1 (Cloudflare)
3. **Secondary DNS**: 8.8.8.8 (Google)
4. Ou use AdGuard: 94.140.14.14

### D. Firewall e Segurança

1. **Advanced** → **Security** → **Firewall**
2. **SPI Firewall**: Enabled
3. **DoS Protection**: Enabled
4. **IP/MAC Binding**: Opcional (mais segurança)

### E. Logs e Monitoramento

1. **Advanced** → **System** → **System Log**
2. Veja logs de conexões
3. Monitore dispositivos conectados

---

## 5. Integração TP-Link + Home Assistant

### Integração Oficial (Dispositivos Kasa/Tapo)

Se você tem dispositivos TP-Link Kasa ou Tapo:

1. No Home Assistant: **Configurações** → **Integrações**
2. Adicionar: **TP-Link Kasa Smart**
3. Detecta automaticamente lâmpadas, plugues, etc

### Integração do Roteador (HACS - Custom Component)

Para monitorar e controlar o roteador pelo HA:

**Recursos**:
- Ver dispositivos conectados
- Reiniciar roteador
- Controlar IoT Network
- Device tracking (presença)
- Sensores de uso de banda

**Instalação via HACS**:
1. Instale HACS no Home Assistant
2. HACS → Integrations → **TP-Link Router**
3. Configure credenciais do roteador
4. Acesso: http://tplinkwifi.net

**GitHub**: [home-assistant-tplink-router](https://github.com/AlexandrErohin/home-assistant-tplink-router)

---

## 6. Configurações Avançadas para Experts

### A. VLANs (Archer BE700 suporta via firmware avançado)

Para isolamento total:
- VLAN 1: Rede principal
- VLAN 10: IoT (com firewall rules)
- VLAN 20: Guest

### B. MLO (Multi-Link Operation) - Wi-Fi 7

Combine múltiplas bandas simultaneamente para latência ultra-baixa.

### C. EasyMesh

Expanda cobertura com outros roteadores TP-Link compatíveis.

---

## 7. App Tether - Recursos Disponíveis

O **app Tether** permite:

✅ **Gerenciar rede remotamente**
✅ **Ver dispositivos conectados** (tempo real)
✅ **Bloquear dispositivos**
✅ **Configurar Guest Network**
✅ **Configurar IoT Network**
✅ **Address Reservation** (IP fixo)
✅ **Parental Controls**
✅ **QoS Settings**
✅ **Reiniciar roteador**
✅ **Verificar atualizações firmware**
✅ **Speed Test**

**Download**:
- iOS: App Store
- Android: Google Play

---

## 8. Checklist de Configuração Recomendada

### Para Home Assistant + IoT

- [ ] Configurar **IP fixo** para G9 (192.168.0.84)
- [ ] Criar **IoT Network** para dispositivos smart
- [ ] Habilitar **WPA3** na IoT Network
- [ ] Configurar **QoS** priorizando G9
- [ ] Habilitar **HomeShield** (proteção de rede)
- [ ] Configurar **DNS** customizado (privacidade)
- [ ] Habilitar **DoS Protection**
- [ ] Atualizar **firmware** do roteador
- [ ] Instalar **app Tether** para gestão móvel
- [ ] Documentar **senhas e configurações**
- [ ] Fazer **backup da configuração** do roteador

---

## 9. Backup da Configuração do Roteador

### Via Interface Web:

1. **Advanced** → **System** → **Backup & Restore**
2. **Backup**: Clique em **Backup**
3. Salve o arquivo `.bin` em local seguro

### Restaurar:

1. Mesma tela
2. **Restore**: Selecione arquivo `.bin`
3. Aguarde reinicialização

---

## 10. Troubleshooting

### Dispositivos IoT não aparecem no Home Assistant

1. Verifique se **IoT Network pode comunicar com rede principal**
2. Veja logs do roteador: **System Log**
3. Confirme que dispositivos estão na IoT Network
4. Reinicie o Home Assistant

### IP do G9 mudou mesmo com reserva

1. Verifique se MAC está correto: **E0:51:08:1A:5A:31**
2. Confirme que reserva está **Enabled**
3. Reinicie DHCP: **DHCP Server** → desabilitar/habilitar

### Performance lenta

1. Atualize firmware: **System** → **Firmware Upgrade**
2. Verifique dispositivos conectados (limite de ~250)
3. Ajuste canais Wi-Fi (evite interferência)
4. Habilite QoS

---

## Recursos e Documentação

### Manuais Oficiais
- [Archer BE700 User Manual](https://www.manualslib.com/manual/3497996/Tp-Link-Archer-Be700.html)
- [TP-Link Official Page](https://www.tp-link.com/us/home-networking/wifi-router/archer-be700/)
- [Download Center](https://www.tp-link.com/us/support/download/archer-be700/)

### Tutoriais TP-Link
- [Como configurar Address Reservation](https://www.tp-link.com/us/support/faq/1554/)
- [Como configurar IoT Network](https://www.tp-link.com/us/support/faq/3775/)
- [Configurar roteador via Tether](https://www.tp-link.com/us/support/faq/2564/)

### Integração Home Assistant
- [TP-Link Router Integration](https://github.com/AlexandrErohin/home-assistant-tplink-router)
- [TP-Link Kasa Integration](https://www.home-assistant.io/integrations/tplink/)
- [Home Assistant Community](https://community.home-assistant.io/t/custom-component-tp-link-router-integration-supports-also-mercusys-router/638647)

---

## Especificações do G9

- **IP Fixo**: 192.168.0.84
- **MAC**: E0:51:08:1A:5A:31
- **Interface**: enp3s0 (Ethernet - 1Gbps)
- **Gateway**: 192.168.0.1 (Archer BE700)

## Recomendação Final

**Configuração Ideal**:
1. ✅ G9 (Home Assistant) → Rede Principal (IP fixo 192.168.0.84)
2. ✅ Dispositivos IoT → IoT Network (HomeAssistant_IoT)
3. ✅ Celulares/PCs → Rede Principal
4. ✅ Visitas → Guest Network (se necessário)

Esta configuração oferece:
- **Máxima segurança** (isolamento IoT)
- **Performance otimizada** (QoS)
- **Facilidade de uso** (app Tether)
- **Escalabilidade** (até 250+ dispositivos)

---

**Seu Archer BE700 + Home Assistant formam um sistema de automação residencial de nível profissional!** 🏠✨

---

## Próximos Passos

1. Configure IP fixo para o G9 via **Address Reservation**
2. Crie a **IoT Network** para seus dispositivos smart
3. Instale o **app Tether** para gestão fácil
4. Comece a migrar dispositivos para a IoT Network
5. Explore integrações no Home Assistant

Precisa de ajuda com alguma configuração específica? Posso te guiar passo a passo!
