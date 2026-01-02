# Arquitetura de Rede Completa - Home Assistant + NAS + Switch 10G

Documentação da infraestrutura de rede de alto desempenho com Home Assistant, NAS e Switch 10 Gigabit.

## Equipamentos de Rede

### Roteador Principal
**TP-Link Archer BE700**
- Modelo: BE15000 Tri-Band Wi-Fi 7 Router
- MAC: 88:7F:F0:07:AD:BB
- Acesso: http://192.168.0.1
- Portas WAN: 1x 10G + 1x 2.5G
- Portas LAN: 1x 2.5G + 2x 1G + USB 3.0
- Wi-Fi: Tri-band (2.4GHz, 5GHz, 6GHz)
- Recursos: IoT Network, WPA3, VPN, HomeShield, EasyMesh

### Switch 10 Gigabit (Em Estoque - Aguardando NAS)
**TP-Link Omada SX3008F**
- Modelo: JetStream 8-Port 10GE SFP+ L2+ Managed Switch
- Portas: 8x 10G SFP+
- Switching Capacity: 160 Gbps
- Forwarding Rate: 119.04 Mpps
- Tipo: L2+ Smart Managed
- Recursos: Static Routing, QoS, VLAN, Link Aggregation
- Gerenciamento: Omada SDN, Web, CLI, SNMP
- Consumo: 15.46W
- Design: Fanless (silencioso), 1U rack-mount
- Segurança: ACL, Port Security, DoS Defend, 802.1X
- Acesso: Via Omada Controller ou Web UI standalone

**Status**: Não conectado (aguardando NAS)

### Servidor Home Assistant
**GMKtec NucBox G9 Mini PC**
- Modelo: NucBox G9
- CPU: Intel N150 (4 cores, 3.6GHz, 6W TDP)
- RAM: 12GB LPDDR5-4800 (soldada)
- Storage: JUMPER 512G NVMe (slot M.2 #1) + 3 slots livres
- Ethernet: **2x Intel I226-V 2.5 Gigabit** ⚡
  - Porta 1 (enp3s0): Ativa em porta 1G do roteador
  - Porta 2: Desconectada (disponível)
- Cooling: Triple fan (silencioso)
- Consumo: ~15-30W
- IP: 192.168.0.84 (DHCP com reserva)
- MAC: E0:51:08:1A:5A:31

**Link Oficial**: [GMKtec G9](https://www.gmktec.com/products/intel-twin-lake-n150-dual-system-4-bay-nas-mini-pc-nucbox-g9)

---

## Arquitetura Atual (Sem NAS)

```
Internet
   │
   ▼
┌────────────────────────────────────────┐
│  TP-Link Archer BE700                  │
│  192.168.0.1                           │
│  - 10G WAN: Internet                   │
│  - 2.5G LAN: ⚠️ DISPONÍVEL (usar!)     │
│  - 1G LAN 1: G9 Porta 1 ⚠️ Limitando  │
│  - 1G LAN 2: Disponível                │
└──────────┬───────────────────────────┘
           │
           │ ⚠️ 1 Gbps (deveria ser 2.5G!)
           │
     ┌─────┴─────────────────┐
     │                       │
     ▼                       ▼
  GMKtec G9              Dispositivos Wi-Fi
  NucBox G9              - IoT Network
  192.168.0.84           - Rede Principal
  Dual 2.5G Ethernet     - Guest Network
  ├─ Porta 1: Ativa (1G) ⚠️
  └─ Porta 2: Livre 🆓
```

**⚠️ IMPORTANTE**: G9 tem 2.5G mas está limitado a 1G!

**Upgrade Recomendado**: Mover cabo do G9 da porta 1G para porta 2.5G do roteador.

**Switch SX3008F**: Em estoque, será conectado quando NAS chegar

---

## Arquitetura Futura (Com NAS e Switch 10G)

### Topologia Planejada

```
                    Internet
                       │
                       ▼
        ┌──────────────────────────────┐
        │  TP-Link Archer BE700        │
        │  192.168.0.1                 │
        │  Router Principal            │
        └────────┬──────────┬──────────┘
                 │          │
        10G      │          │ 1G        Wi-Fi (15Gbps total)
        SFP+     │          │           │
                 │          │           ├─ IoT Network (2.4GHz)
                 ▼          ▼           ├─ Rede Principal (5GHz/6GHz)
        ┌────────────────┐  │           └─ Guest Network
        │  TP-Link       │  │
        │  Omada         │  │
        │  SX3008F       │  │
        │  Switch 10G    │  ▼
        │  8x SFP+       │  G9 - Home Assistant
        └────┬───────────┘  192.168.0.84 (IP Fixo)
             │              JUMPER 512G NVMe
             │              enp3s0 (1Gbps - Suficiente)
             │
      ┌──────┼──────┐
      │      │      │
   10G│   10G│   10G│
      ▼      ▼      ▼
    NAS   Futuro  Futuro
  (4TB x2) Device Device
  Storage
```

### Conexões de Alto Desempenho (10G)

**Porta 1 - NAS**
- NAS com SSDs Samsung 4TB + WD 4TB
- Conexão: 10G SFP+ ou DAC
- Uso: Storage principal, backups, mídia

**Porta 2 - Archer BE700**
- Uplink do switch para roteador
- Conexão: 10G SFP+ ou DAC
- Usa porta 2.5G ou 10G WAN (modo bridge/LAN)

**Portas 3-8 - Disponíveis**
- Servidores futuros
- Workstations de alto desempenho
- Expansão de storage
- Link aggregation

---

## Configuração de Rede Recomendada

### VLANs (Opcional - Segurança Avançada)

**VLAN 1 - Management** (192.168.0.0/24)
- Roteador: 192.168.0.1
- Switch: 192.168.0.2
- G9 (Home Assistant): 192.168.0.84

**VLAN 10 - Principal** (192.168.10.0/24)
- PCs, laptops, celulares
- Acesso total à rede

**VLAN 20 - IoT** (192.168.20.0/24)
- Dispositivos smart homes
- Isolado mas com acesso ao G9
- Mapeia para IoT Network do Archer BE700

**VLAN 30 - Storage** (192.168.30.0/24)
- NAS
- Backups
- Alto tráfego isolado

**VLAN 99 - Guest** (192.168.99.0/24)
- Visitantes
- Sem acesso a outras VLANs

### Link Aggregation (LAG)

Para redundância e velocidade:
- **G9**: 2x 2.5G agregadas (LACP) = 5Gbps total + failover
- **Roteador ↔ Switch**: 2x 10G = 20Gbps agregado
- **NAS ↔ Switch**: 2x 10G = 20Gbps (se NAS suportar)

**Nota**: G9 dual 2.5G permite link aggregation nativo!

---

## Equipamentos de Servidor

### G9 - GMKtec NucBox G9 (Home Assistant Server)
- **Modelo**: GMKtec NucBox G9 Mini PC
- **CPU**: Intel N150 (4 cores, 3.6GHz, 6W TDP)
- **RAM**: 12GB LPDDR5-4800
- **Storage**: JUMPER 512G NVMe (slot #1) + 3 slots M.2 livres
- **Rede**: Dual 2.5G Ethernet (Intel I226-V)
  - Porta 1 (enp3s0): Ativa - MAC E0:51:08:1A:5A:31
  - Porta 2: Disponível
- **IP**: 192.168.0.84 (DHCP com reserva)
- **Sistema**: Home Assistant OS 13.2
- **Cooling**: Triple fan (silencioso)
- **Consumo**: ~15-30W
- **Função**: Hub de automação residencial
- **Specs Completas**: [GMKTEC_G9_SPECS.md](GMKTEC_G9_SPECS.md)

### NAS Futuro (Aguardando Hardware)
- **Discos**: Samsung 990 EVO Plus 4TB + WD BLACK SN7100 4TB
- **Total**: 8TB (configuração RAID a definir)
- **Conexão**: 10G SFP+ via SX3008F
- **Função**: Storage principal, backups, mídia, VMs

**Configurações RAID Possíveis**:
- **RAID 0**: 8TB total, sem redundância (máxima performance)
- **RAID 1**: 4TB total, espelhamento (máxima segurança) ⭐ RECOMENDADO
- **JBOD**: 8TB total, discos independentes

---

## Requisitos de Hardware para Switch

### Módulos/Cabos SFP+ Necessários

**Para conectar dispositivos ao SX3008F:**

1. **DAC (Direct Attach Copper)** - Distâncias curtas (<7m)
   - TP-Link TL-SM5220-3M (3 metros)
   - TP-Link TL-SM5220-5M (5 metros)
   - Custo: ~$30-50 por cabo
   - **RECOMENDADO** para NAS e roteador

2. **Módulos SFP+ com fibra** - Distâncias longas (até 10km)
   - TP-Link TL-SM5110-SR (multimodo, até 300m)
   - TP-Link TL-SM5110-LR (monomodo, até 10km)
   - Custo: ~$50-100 por módulo + fibra

3. **Adaptadores RJ45 10GBASE-T** - Usar cabos Ethernet
   - TP-Link TL-SM410U (10G RJ45 module)
   - Permite usar Cat6a/Cat7
   - Custo: ~$80 por módulo
   - Mais caro mas usa cabos normais

**Recomendação Inicial**:
- 2x DAC TL-SM5220-5M (NAS + Roteador) = ~$100
- Mais econômico e simples

---

## Configuração do Switch Omada SX3008F

### Primeiro Acesso

**Via Web UI (Standalone)**:
1. Conecte PC na porta 1 do switch
2. Configure IP estático no PC: 192.168.0.100/24
3. Acesse: http://192.168.0.146 (IP padrão do switch)
4. Usuário: admin / Senha: admin (primeira vez)
5. Configure novo IP: 192.168.0.2 (sugestão)

**Via Omada Controller (Cloud SDN)**:
1. Instale Omada Controller (hardware, software ou cloud)
2. Adote o switch automaticamente (ZTP)
3. Gerencie centralmente com outros dispositivos Omada

### Configurações Essenciais

**1. Configuração Básica**
- IP do switch: 192.168.0.2
- Gateway: 192.168.0.1 (Archer BE700)
- Nome: "Switch-10G-Core"

**2. VLANs** (se usar)
- Criar VLANs 1, 10, 20, 30, 99
- Tagged/Untagged conforme necessidade

**3. Link Aggregation**
- LAG 1: Portas 1-2 para roteador (20G)
- LAG 2: Portas 3-4 para NAS (20G) - se suportado

**4. QoS**
- Prioridade alta: Porta do G9 (Home Assistant)
- Prioridade média: NAS
- Prioridade baixa: Backup traffic

**5. Segurança**
- Habilitar Port Security
- Configurar ACLs se necessário
- DoS Defend: Enabled

**6. Monitoring**
- SNMP para monitoramento externo
- Port mirroring para diagnóstico

---

## Integração com Home Assistant

### Monitoramento do Switch

**Via SNMP**:
1. Habilite SNMP no SX3008F
2. No HA: **HACS** → **SNMP**
3. Configure para monitorar:
   - Tráfego de rede por porta
   - Erros de link
   - Temperatura (se disponível)
   - Uptime

**Via Omada Controller**:
- Se usar Omada Controller, pode integrar via API
- Custom component disponível na comunidade

### Dashboards Úteis

**Monitoramento de Rede**:
- Tráfego 10G em tempo real
- Status de links
- Uso de banda do NAS
- Latência entre dispositivos

---

## Performance Esperada

### Velocidades de Transferência

**NAS → PC via 10G**:
- Leitura: ~1000 MB/s (8 Gbps)
- Gravação: ~800-1000 MB/s
- Depende dos SSDs (Samsung 990 EVO Plus = até 5000 MB/s)

**Home Assistant → NAS (1G)**:
- Leitura: ~110-125 MB/s
- Suficiente para backups, gravações de câmeras

**Wi-Fi 7 (6GHz) → NAS via switch**:
- Até 2.8 Gbps (350 MB/s) em condições ideais
- Perfeito para streaming 4K, backups wireless

### Latência

- G9 ↔ Dispositivos IoT: <5ms
- NAS ↔ Workstation: <1ms (10G)
- Internet ↔ Dispositivos: Depende do ISP

---

## Diagrama de Consumo Elétrico

| Equipamento | Consumo | Observação |
|-------------|---------|------------|
| Archer BE700 | ~15-20W | Idle |
| SX3008F | 15.46W | Fanless, sempre ligado |
| G9 (Home Assistant) | ~30-50W | Depende do CPU |
| NAS (futuro) | ~20-40W | Depende do modelo |
| **Total** | **~80-125W** | 24/7 |

**Custo mensal** (R$ 0.80/kWh):
- Máximo: 125W × 24h × 30d = 90 kWh/mês = ~R$ 72/mês
- Típico: 100W × 24h × 30d = 72 kWh/mês = ~R$ 58/mês

---

## Próximos Passos

### Quando o NAS Chegar

1. **Instalar SSDs no NAS**
   - Samsung 990 EVO Plus 4TB
   - WD BLACK SN7100 4TB
   - Configurar RAID 1 (espelhamento)

2. **Conectar Switch SX3008F**
   - Ligar switch
   - Configurar IP: 192.168.0.2
   - Conectar ao Archer BE700 via DAC

3. **Conectar NAS ao Switch**
   - Porta 10G do NAS → Porta 3 do switch (via DAC)
   - Configurar IP fixo no NAS
   - Testar velocidade

4. **Configurar Shares**
   - SMB/CIFS para Windows/Linux
   - NFS para Linux (melhor performance)
   - Criar shares para: Backups HA, Mídia, Documentos

5. **Integrar com Home Assistant**
   - Adicionar NAS como storage externo
   - Configurar backup automático
   - Monitoramento via SNMP

---

## Recursos e Links Úteis

### Documentação Oficial

**Switch SX3008F**:
- [Página Oficial Omada](https://www.omadanetworks.com/us/business-networking/omada-switch-l3-l2-managed/sx3008f/)
- [Manual do Usuário](https://static.tp-link.com/upload/manual/2024/202402/20240229/1910012875_SX3008F_UG.pdf)

**Archer BE700**:
- [Guia Completo de Configuração](CONFIGURACAO_ARCHER_BE700.md)

**Home Assistant**:
- [Próximos Passos](PROXIMOS_PASSOS.md)
- [Comandos Úteis](COMANDOS_UTEIS.md)

### Cabos e Módulos Compatíveis

- TP-Link TL-SM5220 Series (DAC)
- TP-Link TL-SM410U (10GBASE-T)
- TP-Link TL-SM5110-SR/LR (Fiber)

### Comunidade

- r/homelab - Projetos de rede doméstica
- r/homeassistant - Automação residencial
- TP-Link Omada Community Forum

---

## Checklist de Implementação

### Fase Atual (Sem NAS)
- [x] Home Assistant instalado no G9
- [x] Archer BE700 configurado
- [ ] IP fixo configurado para G9
- [ ] IoT Network criada
- [ ] Backups automáticos do HA

### Fase Futura (Com NAS)
- [ ] Comprar cabos DAC (2x TL-SM5220-5M)
- [ ] Conectar switch SX3008F
- [ ] Configurar switch (IP, VLANs, QoS)
- [ ] Instalar SSDs no NAS
- [ ] Conectar NAS ao switch 10G
- [ ] Configurar RAID 1
- [ ] Criar shares de rede
- [ ] Integrar NAS com Home Assistant
- [ ] Configurar backups automáticos
- [ ] Testar performance 10G
- [ ] Documentar configuração final

---

**Sua infraestrutura será de nível profissional com 10 Gigabit de backbone!** 🚀

Custo aproximado de cabos necessários: ~R$ 500-700
- 2x DAC 10G (NAS + Roteador)
- Ou módulos SFP+ alternativos
