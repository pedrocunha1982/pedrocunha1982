# GMKtec NucBox G9 - Especificações Completas

Documentação completa do mini PC GMKtec NucBox G9 usado como servidor Home Assistant.

## Visão Geral

O GMKtec NucBox G9 é um mini PC compacto projetado para uso como NAS/servidor, com foco em alto desempenho de rede e expansão de storage.

**Status**: Home Assistant OS 13.2 instalado no slot M.2 #1 (JUMPER 512G)

---

## Especificações de Hardware

### Processador
- **Modelo**: Intel N150
- **Cores/Threads**: 4 cores / 4 threads
- **Base Clock**: ~1.0 GHz
- **Boost Clock**: Até 3.6 GHz
- **Cache**: 6 MB
- **TDP**: 6W (design de baixo consumo)

### Memória
- **Tipo**: LPDDR5-4800
- **Capacidade**: 12 GB
- **Soldada**: Sim (não expansível)
- **Velocidade**: 4800 MHz (80% mais rápido que DDR4)

### Storage

**Slots M.2 Disponíveis**: 4x M.2 2280 PCIe

**Configuração Atual**:
- **Slot 1**: JUMPER 512G NVMe (Home Assistant OS)
- **Slot 2**: Vazio
- **Slot 3**: Vazio
- **Slot 4**: Vazio

**Capacidade Máxima**: 4x 4TB = 16TB total

**SSDs Removidos** (para usar no NAS futuro):
- Samsung SSD 990 EVO Plus 4TB
- WD BLACK SN7100 4TB

### Rede (Dual 2.5 Gigabit Ethernet) ⭐

**Controladores**: 2x Intel I226-V

**Porta 1 (enp3s0)**:
- **Velocidade**: 2.5 Gbps (atualmente conectada em porta 1G do roteador)
- **MAC**: E0:51:08:1A:5A:31
- **IP**: 192.168.0.84 (fixo via DHCP reservation)
- **Status**: ✅ Conectada e ativa
- **Uso**: Rede principal (Home Assistant)

**Porta 2**:
- **Velocidade**: 2.5 Gbps
- **Status**: ⚠️ Não conectada
- **Uso Futuro**: Link aggregation, rede dedicada IoT/Storage, ou redundância

**Performance**:
- Velocidade individual: 2.5 Gbps (312.5 MB/s)
- Com Link Aggregation (LACP): Até 5 Gbps (625 MB/s)

### Wireless
- **Wi-Fi**: Wi-Fi 6 (802.11ax)
- **Bluetooth**: 5.2
- **Status**: Disponível mas não em uso (Ethernet preferido)

### Vídeo/Display

**Saídas**:
- 2x HDMI 2.0 (4K@60Hz)
- 1x USB-C com DisplayPort (4K@60Hz)

**Suporte**: Triple display (3 monitores simultâneos)

**Uso Atual**: Headless (sem monitor - gerenciado remotamente)

### Portas e Conectividade

**USB**:
- 3x USB 3.2 Gen 2 (10 Gbps)
- 1x USB-C full-function (DP/Data/Power Delivery)

**Áudio**:
- 1x 3.5mm combo jack (headphone/mic)

**Energia**:
- DC 19V input
- Consumo típico: ~15-25W (com Home Assistant)
- Consumo máximo: ~30-35W (carga total)

### Refrigeração (Triple Fan System) ❄️

**Configuração de 3 Ventoinhas**:
- **Fan 1-2**: Cooling para SSDs e módulos DDR5
- **Fan 3**: Ventilador grande dedicado para CPU

**Performance**:
- Dissipação eficiente de calor
- Operação silenciosa: 33-36 dB
- Temperatura controlada mesmo sob carga

**Vantagem**: Ideal para operação 24/7 sem throttling térmico

### Dimensões e Construção

- **Tamanho**: ~123 x 113 x 50 mm (ultra compacto)
- **Montagem**: Desktop (com pés de borracha inclusos)
- **Material**: Alumínio (dissipação de calor passiva adicional)
- **Peso**: ~500g (aproximado)

---

## Sistema Operacional

### Configuração Original (Dual Boot)
- **OS 1**: Windows 11 Pro (padrão de fábrica)
- **OS 2**: Ubuntu 24.10 (sistema secundário)

### Configuração Atual (Home Assistant Dedicado)
- **OS**: Home Assistant OS 13.2
- **Instalação**: Substituiu ambos os sistemas originais
- **Modo**: Single boot dedicado

**Vantagens da Instalação Atual**:
- 100% dos recursos dedicados ao Home Assistant
- Sem overhead de dual boot
- Máxima estabilidade
- Boot mais rápido

---

## Performance e Benchmarks

### CPU Performance
- **Single-Core**: Adequado para tarefas sequenciais
- **Multi-Core**: Bom para automações paralelas
- **Eficiência Energética**: Excelente (6W TDP)

**Ideal Para**:
- Home Assistant (leve a moderado)
- Até ~100 dispositivos IoT
- Automações complexas
- Add-ons leves a médios
- Node-RED, InfluxDB, Grafana

**Limitações**:
- IA/ML pesado (Frigate com muitas câmeras)
- Transcodificação de vídeo 4K em tempo real
- VMs múltiplas pesadas

### Memória Performance
- **12GB LPDDR5-4800**: Rápida e eficiente
- **Suficiente para**: Home Assistant + múltiplos add-ons
- **Limitação**: Não expansível (soldada)

### Storage Performance
- **NVMe Gen 3**: ~3000 MB/s leitura, ~2000 MB/s gravação (JUMPER 512G)
- **Latência**: <100µs (excelente para banco de dados)
- **Expansão**: 3 slots livres para projetos futuros

### Network Performance
- **2.5G Ethernet**: 2.5x mais rápido que Gigabit padrão
- **Latência**: <1ms (rede local)
- **Dual Port**: Possibilita agregação ou segmentação

---

## Uso de Recursos (Home Assistant)

### Típico (Idle)
- **CPU**: 5-15%
- **RAM**: 2-4 GB (~30% dos 12GB)
- **Disco**: 8-10 GB usados (Home Assistant + dados)
- **Rede**: Mínimo (~1-10 Mbps)
- **Energia**: ~15W

### Moderado (Com add-ons e automações)
- **CPU**: 20-40%
- **RAM**: 4-6 GB (~50%)
- **Disco**: 20-50 GB (com histórico e backups)
- **Rede**: 50-100 Mbps
- **Energia**: ~20W

### Máximo (Carga pesada)
- **CPU**: 60-80%
- **RAM**: 8-10 GB (~80%)
- **Disco**: Até 512GB disponível
- **Rede**: Até 2.5 Gbps
- **Energia**: ~30W

---

## Configuração de Rede Atual

### Conexão Principal
- **Interface**: enp3s0 (Porta Ethernet 1)
- **Velocidade Negociada**: 1 Gbps (conectada em porta 1G do roteador)
- **Velocidade Máxima**: 2.5 Gbps (não utilizada - limitada pelo roteador)
- **IP**: 192.168.0.84/24 (DHCP com reserva)
- **Gateway**: 192.168.0.1 (Archer BE700)
- **DNS**: 192.168.0.1

### Porta 2 (Não Utilizada)
- **Status**: Desconectada
- **Potencial**: Link aggregation, rede IoT dedicada, ou storage network

---

## Possibilidades de Upgrade de Rede

### Opção 1: Aproveitar 2.5G (RECOMENDADO Curto Prazo)

**Mover cabo para porta 2.5G do Archer BE700**:
- Velocidade: 1 Gbps → 2.5 Gbps
- Benefício: 2.5x mais rápido
- Custo: R$ 0 (só trocar porta)
- Ideal para: Backups rápidos, streaming local

### Opção 2: Link Aggregation (Médio Prazo)

**Usar ambas as portas agregadas (LACP)**:
- Velocidade: Até 5 Gbps total (2x 2.5G)
- Redundância: Failover automático
- Requisitos: Roteador ou switch com suporte LACP
- Complexidade: Média

### Opção 3: Rede Dedicada Storage (Longo Prazo)

**Quando NAS chegar**:
- Porta 1: Rede principal (192.168.0.x)
- Porta 2: Rede storage dedicada (10.0.0.x) via switch 10G
- Benefício: Tráfego separado, sem congestionamento
- Ideal para: Backups, gravações de câmeras

---

## Expansão Futura

### Storage
- **3 slots M.2 livres**: Adicionar até 12TB extra
- **Uso Potencial**:
  - Backups locais
  - Gravações de câmeras (Frigate)
  - Database histórico (InfluxDB)
  - Mídia local (thumbnails, TTS)

### Rede
- **Segunda porta 2.5G**: Pronta para uso
- **Wi-Fi 6**: Backup wireless se Ethernet falhar

### Compute
- **CPU/RAM**: Fixos (não expansíveis)
- **Suficiente para**: 90% dos casos de uso Home Assistant

---

## Comparação com Alternativas

### vs Raspberry Pi 4/5
✅ **G9 Vantagens**:
- Dual 2.5G Ethernet (vs 1G)
- 4x M.2 slots (vs microSD/USB)
- 12GB RAM (vs 8GB max)
- Triple fan cooling (vs passivo/ativo básico)
- x86-64 (melhor compatibilidade software)

❌ **Pi Vantagens**:
- GPIO para hardware hacking
- Menor consumo (~5W)
- Mais barato
- Comunidade maior

### vs NUC Intel
✅ **G9 Vantagens**:
- Dual 2.5G Ethernet (muitos NUCs têm 1G)
- 4x M.2 slots (NUCs têm 1-2)
- Mais compacto
- Menor consumo
- Melhor custo/benefício

❌ **NUC Vantagens**:
- CPUs mais potentes disponíveis
- RAM expansível
- Melhor para VMs/Containers pesados

### vs Servidores Dedicados
✅ **G9 Vantagens**:
- Consumo baixíssimo (vs 50-200W)
- Silencioso (vs barulhento)
- Compacto (vs rack 1U/2U)
- Custo inicial baixo

❌ **Servidor Vantagens**:
- Muito mais potência
- ECC RAM
- IPMI/iLO
- Redundância (PSU, fans)

---

## Recomendações de Uso

### Ideal Para:
✅ Home Assistant servidor dedicado (seu caso)
✅ NAS leve (4x 4TB = 16TB)
✅ Servidor de mídia (Plex/Jellyfin 1080p)
✅ Servidor de desenvolvimento
✅ Router/Firewall (pfSense, OPNsense)
✅ Aplicações 24/7 de baixo consumo

### Não Recomendado Para:
❌ Gaming
❌ Edição de vídeo 4K
❌ Machine Learning pesado
❌ Múltiplas VMs Windows simultaneamente
❌ Transcodificação 4K em tempo real

---

## Manutenção e Troubleshooting

### Limpeza
- **Frequência**: A cada 6 meses
- **Procedimento**: Ar comprimido nos vents
- **Foco**: Ventoinhas e heatsinks

### Monitoramento de Temperatura
```bash
# No Home Assistant OS (via SSH)
ha host info
```

**Temperaturas Normais**:
- CPU idle: 35-45°C
- CPU load: 50-65°C
- Crítico: >80°C (throttling)

### Backup
- **Frequência**: Semanal (automático)
- **Destino**: NAS futuro (quando chegar)
- **Método**: Home Assistant built-in backup

### Atualização de Firmware
- **BIOS**: Verificar site GMKtec periodicamente
- **Network Drivers**: Auto-atualizados pelo HA OS

---

## Links e Recursos

### Fabricante
- [GMKtec Official Site](https://www.gmktec.com/)
- [GMKtec G9 Product Page](https://www.gmktec.com/products/intel-twin-lake-n150-dual-system-4-bay-nas-mini-pc-nucbox-g9)
- [GMKtec Blog - G9 Announcement](https://www.gmktec.com/blogs/blog-post-2024/coming-soon-gmktec-g9-dual-system-4-bay-all-flash-nas-mini-pc)

### Reviews e Comunidade
- [Liliputing Review](https://liliputing.com/gmktec-nucbox-g9-review-this-tiny-nas-supports-four-m-2-ssds-and-dual-2-5-gbe-lan-connections/)
- [NotebookCheck Coverage](https://www.notebookcheck.net/GMKtec-G9-Ultra-mini-PC-that-doubles-as-network-storage.947794.0.html)

### Suporte
- GMKtec Support (via site oficial)
- r/MiniPCs (Reddit community)
- r/homeassistant (para uso específico HA)

---

## Conclusão

O GMKtec NucBox G9 é uma **excelente escolha** para Home Assistant:

✅ **Dual 2.5G Ethernet** - Rede rápida e escalável
✅ **4x M.2 Slots** - Expansão de storage massiva
✅ **12GB LPDDR5** - Memória rápida e suficiente
✅ **Triple Fan Cooling** - Operação 24/7 confiável
✅ **Baixo Consumo** - ~15-30W (econômico)
✅ **Compacto e Silencioso** - Discreto no ambiente

**Custo-benefício excelente** para um servidor Home Assistant dedicado!

---

**Configuração Atual**: ✅ Operacional com Home Assistant OS 13.2
**Próximos Upgrades**: Mover para porta 2.5G do roteador, configurar segunda porta quando NAS chegar
