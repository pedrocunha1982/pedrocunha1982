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
- **IP**: 192.168.0.84
- **Gateway**: 192.168.0.1
- **Interface**: enp3s0 (Ethernet)
- **MAC**: E0:51:08:1A:5A:31
- **DNS**: 192.168.0.1

**Discos Removidos (transferidos para NAS):**
- Samsung SSD 990 EVO Plus 4TB
- WD BLACK SN7100 4TB

---

## Instalação (Concluída)

### Método Utilizado
Instalação via Ubuntu Live USB gravando Home Assistant OS diretamente no SSD JUMPER 512G.

### Arquivos Disponíveis
- **Guia Completo**: [INSTALL_HOMEASSISTANT.md](INSTALL_HOMEASSISTANT.md)
- **Script Automatizado**: `install_homeassistant.sh`
- **Comandos Úteis**: [COMANDOS_UTEIS.md](COMANDOS_UTEIS.md)
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

<!--
**pedrocunha1982/pedrocunha1982** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.
-->
