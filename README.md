## Computador G9 - Home Assistant Server

Este repositório contém documentação e scripts para configuração do computador G9 com Home Assistant OS.

## Status: ✅ OPERACIONAL

O Home Assistant OS foi instalado com sucesso e está rodando no computador G9.

### Acesso ao Home Assistant

- **URL Local**: http://homeassistant.local:8123
- **URL IP**: http://192.168.0.84:8123
- **App Mobile**: Compatível com app oficial Home Assistant

### Especificações do G9

**Modelo**: GMKtec NucBox G9 Mini PC

**Hardware:**
- **CPU**: Intel N150 (4 cores, até 3.6GHz, 6W TDP)
- **RAM**: 12GB LPDDR5-4800 (soldada)
- **Disco Principal**: JUMPER 512G NVMe (slot M.2 #1)
- **Slots M.2 Livres**: 3x (capacidade total: até 16TB)
- **Sistema**: Home Assistant OS 13.2
- **Espaço Usado**: 6GB sistema + dados
- **Espaço Disponível**: ~506GB
- **Cooling**: Triple fan (2x SSD/RAM + 1x CPU grande)

**Rede (Dual 2.5 Gigabit Ethernet):**
- **Porta 1 (enp3s0)**: 2.5G (atualmente em porta 1G do roteador)
  - IP: 192.168.0.84 (DHCP com reserva)
  - MAC: E0:51:08:1A:5A:31
  - Status: ✅ Ativa
- **Porta 2**: 2.5G (não conectada - disponível para link aggregation/rede dedicada)
- **Controlador**: 2x Intel I226-V
- **Gateway**: 192.168.0.1 (TP-Link Archer BE700)
- **DNS**: 192.168.0.1
- **Wi-Fi**: Wi-Fi 6 (disponível mas não em uso)
- **Bluetooth**: 5.2

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
- **Especificações do G9**: [GMKTEC_G9_SPECS.md](GMKTEC_G9_SPECS.md) 🖥️
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

### 3. Aproveitar Dual 2.5G Ethernet do G9 ⚡

O GMKtec G9 tem **duas portas 2.5 Gigabit**, mas atualmente está conectado em porta **1G** (desperdiçando 60% da velocidade!).

**Status Atual**:
- ⚠️ Porta 1: Conectada em porta 1G do roteador (limitada a 1 Gbps)
- ⚠️ Porta 2: Desconectada

**Upgrade Recomendado - Mover para Porta 2.5G** (FÁCIL):

1. **Identifique a porta 2.5G LAN** do Archer BE700
2. **Mova o cabo** da porta 1G para a porta 2.5G
3. **Teste velocidade**: 1 Gbps → 2.5 Gbps (2.5x mais rápido!)

**Benefícios**:
- ✅ Backups 2.5x mais rápidos
- ✅ Streaming local sem buffering
- ✅ Gravações de câmeras mais responsivas
- ✅ Custo: R$ 0 (só trocar porta!)

**Futuro - Quando NAS Chegar** (Link Aggregation):
- Porta 1: Conectada ao roteador (2.5G)
- Porta 2: Conectada ao switch 10G (dedicada para storage)
- Ou: Agregadas (LACP) = 5 Gbps total

**Guia completo**: [GMKTEC_G9_SPECS.md](GMKTEC_G9_SPECS.md)

### 4. Recursos do Archer BE700

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
