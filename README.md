## Computador G9 - Home Assistant Server

Este repositório contém documentação e scripts para configuração do computador G9 com Home Assistant OS.

## Status: ✅ OPERACIONAL

O Home Assistant OS foi instalado com sucesso e está rodando no computador G9.

### Acesso ao Home Assistant

- **URL Local**: http://homeassistant.local:8123
- **URL IP**: http://192.168.0.84:8123
- **App Mobile**: Compatível com app oficial Home Assistant

### Especificações do G9

**Hardware:**
- **Disco Principal**: JUMPER 512G NVMe (nvme2n1)
- **Sistema**: Home Assistant OS 13.2
- **Espaço Total**: 512GB (6GB sistema + 506GB dados)
- **Disco Secundário**: eMMC 58GB (reserva)

**Rede:**
- **IP**: 192.168.0.84 (DHCP - recomendado configurar IP fixo)
- **Gateway**: 192.168.0.1 (TP-Link Archer BE700)
- **Interface**: enp3s0 (Ethernet 1Gbps)
- **MAC**: E0:51:08:1A:5A:31
- **DNS**: 192.168.0.1

**Roteador:**
- **Modelo**: TP-Link Archer BE700 BE15000 Wi-Fi 7 Tri-Band
- **MAC**: 88:7F:F0:07:AD:BB
- **Recursos**: IoT Network, WPA3, 10G WAN, VPN, HomeShield
- **Acesso**: http://192.168.0.1

**Switch 10 Gigabit** (em estoque - aguardando NAS):
- **Modelo**: TP-Link Omada SX3008F
- **Portas**: 8x 10G SFP+
- **Tipo**: L2+ Smart Managed Switch
- **Switching**: 160 Gbps / 119.04 Mpps
- **Recursos**: Static Routing, QoS, VLAN, Link Aggregation, Omada SDN
- **Consumo**: 15.46W (fanless)
- **Status**: Não conectado (será usado quando NAS chegar)

**Discos Removidos (serão usados no NAS futuro):**
- Samsung SSD 990 EVO Plus 4TB
- WD BLACK SN7100 4TB
- **Uso futuro**: NAS com conexão 10G ao switch SX3008F

---

## Instalação (Concluída)

### Método Utilizado
Instalação via Ubuntu Live USB gravando Home Assistant OS diretamente no SSD JUMPER 512G.

### Arquivos Disponíveis
- **Guia de Instalação**: [INSTALL_HOMEASSISTANT.md](INSTALL_HOMEASSISTANT.md)
- **Configuração do Roteador**: [CONFIGURACAO_ARCHER_BE700.md](CONFIGURACAO_ARCHER_BE700.md) ⭐
- **Arquitetura de Rede**: [ARQUITETURA_REDE.md](ARQUITETURA_REDE.md) 🌐
- **Próximos Passos**: [PROXIMOS_PASSOS.md](PROXIMOS_PASSOS.md)
- **Comandos Úteis**: [COMANDOS_UTEIS.md](COMANDOS_UTEIS.md)
- **Script Automatizado**: `install_homeassistant.sh`
- **Script de Verificação**: `verificar_discos_g9.sh`

### Para Reinstalar (se necessário)

1. Boote o Ubuntu Live USB no computador G9
2. Abra o terminal (Ctrl + Alt + T)
3. Clone este repositório:
```bash
git clone https://github.com/pedrocunha1982/pedrocunha1982.git
cd pedrocunha1982
```
4. Execute o script:
```bash
sudo ./install_homeassistant.sh
```

Para mais detalhes, consulte o [guia completo de instalação](INSTALL_HOMEASSISTANT.md).

---

## Configuração de Rede Recomendada

### 1. IP Fixo para o G9

O Home Assistant está atualmente com IP dinâmico (DHCP). **Recomenda-se configurar IP fixo** no roteador.

**Via App Tether (mais fácil)**:
1. Abra app Tether → **Tools** → **Advanced**
2. **Network** → **DHCP Server** → **Address Reservation**
3. Adicione:
   - MAC: E0:51:08:1A:5A:31
   - IP: 192.168.0.84
   - Nome: Home Assistant G9

**Guia completo**: [CONFIGURACAO_ARCHER_BE700.md](CONFIGURACAO_ARCHER_BE700.md)

### 2. IoT Network (Altamente Recomendado)

O Archer BE700 suporta **IoT Network** - uma rede Wi-Fi dedicada para dispositivos smart que:
- ✅ Isola dispositivos IoT por segurança
- ✅ Permite comunicação com Home Assistant
- ✅ Usa WPA3 + HomeShield para proteção

Configure em: **Wireless** → **IoT Network** (via app Tether ou web)

**Arquitetura recomendada**:
- **Rede Principal**: G9 (Home Assistant), PCs, celulares
- **IoT Network**: Lâmpadas, sensores, câmeras, interruptores

### 3. Recursos do Archer BE700

- Wi-Fi 7 Tri-Band (15Gbps)
- IoT Network dedicada
- VPN Client & Server
- QoS para priorizar tráfego
- HomeShield (proteção de rede)
- App Tether para gestão móvel

**Guia completo**: [CONFIGURACAO_ARCHER_BE700.md](CONFIGURACAO_ARCHER_BE700.md)

---

<!--
**pedrocunha1982/pedrocunha1982** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.
-->
