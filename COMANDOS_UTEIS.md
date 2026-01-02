# Comandos Úteis - Ubuntu Live e Home Assistant

## Comandos Úteis no Ubuntu Live

### Verificar Hardware do G9

```bash
# Informações da CPU
lscpu

# Informações de RAM
free -h

# Informações detalhadas do sistema
sudo lshw -short

# Informações de rede
ip addr show

# Informações de discos
lsblk -f
sudo fdisk -l
```

### Verificar Conexão de Rede

```bash
# Testar conectividade
ping -c 4 google.com

# Ver interfaces de rede
ip link show

# Configurar IP manualmente (se necessário)
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip route add default via 192.168.1.1
```

### Preparar Disco (Manualmente)

```bash
# Ver todos os discos
lsblk

# Desmontar todas as partições de um disco
sudo umount /dev/sda*

# Apagar todas as partições (CUIDADO!)
sudo wipefs -a /dev/sda

# Verificar se o disco está limpo
sudo fdisk -l /dev/sda
```

### Download Manual do Home Assistant OS

```bash
# Criar diretório
mkdir ~/ha-install
cd ~/ha-install

# Baixar versão específica (substitua VERSION)
VERSION="13.2"
wget https://github.com/home-assistant/operating-system/releases/download/${VERSION}/haos_generic-x86-64-${VERSION}.img.xz

# Extrair
unxz haos_generic-x86-64-${VERSION}.img.xz

# Gravar no disco (SUBSTITUA /dev/sdX!)
sudo dd if=haos_generic-x86-64-${VERSION}.img of=/dev/sdX bs=4M status=progress conv=fsync

# Sincronizar
sync
```

## Comandos Pós-Instalação (no G9 já com Home Assistant)

### Acessar o Console do Home Assistant (via SSH ou teclado/monitor)

```bash
# Login padrão no console
# Usuário: root (sem senha no primeiro acesso)

# Verificar status do sistema
ha core info
ha supervisor info
ha host info

# Ver logs
ha core logs
ha supervisor logs

# Reiniciar serviços
ha core restart
ha supervisor restart

# Atualizar sistema
ha core update
ha supervisor update
ha os update
```

### Configurar IP Estático (via console do HA)

```bash
# Editar configuração de rede
ha network info
ha network update enp0s3 --ipv4-method static --ipv4-address 192.168.1.100/24 --ipv4-gateway 192.168.1.1 --ipv4-nameserver 8.8.8.8
```

## Troubleshooting

### Home Assistant não está acessível na porta 8123

```bash
# No console do HA, verificar status
ha core info

# Se status não for "running", verificar logs
ha core logs

# Verificar se a porta está aberta
netstat -tulpn | grep 8123

# Verificar firewall
iptables -L
```

### Descobrir IP do Home Assistant na rede

**No seu computador (não no G9):**

```bash
# Linux/Mac - Scan da rede
sudo nmap -sn 192.168.1.0/24

# Ou usar arp
arp -a

# Windows - Scan da rede
arp -a

# Ou usar Advanced IP Scanner (GUI)
```

### Resetar Home Assistant

```bash
# No console do HA
ha core rebuild

# Ou reinstalar do zero (apaga TUDO)
# Simplesmente reinstale usando o script
```

### Backup antes de mudanças importantes

```bash
# No console do HA
ha backups new --name "backup-antes-mudanca"

# Listar backups
ha backups list

# Restaurar backup
ha backups restore <slug>
```

## Verificações de Saúde do Sistema

### No Ubuntu Live (antes de instalar)

```bash
# Teste de velocidade do disco
sudo hdparm -Tt /dev/sda

# Teste de memória (demora!)
# sudo memtest86+ (requer boot separado)

# Teste de temperatura
sensors

# Se sensors não funcionar
sudo apt install lm-sensors
sudo sensors-detect
sensors
```

### No Home Assistant (após instalação)

```bash
# Dashboard de saúde
# Acesse: http://IP:8123/config/system

# Via CLI
ha host info
ha os info
ha supervisor info
```

## URLs Úteis

- Home Assistant Web UI: `http://homeassistant.local:8123`
- Observer (diagnósticos): `http://homeassistant.local:4357`
- Portainer (se habilitado): `http://homeassistant.local:9000`

## Notas Importantes

1. **Primeiro boot**: Pode demorar 5-20 minutos
2. **Acesso SSH**: Precisa ser habilitado via interface web primeiro
3. **Addons**: Instale via interface web (Supervisor > Add-on Store)
4. **Backups**: Configure backups automáticos o quanto antes
5. **Atualizações**: Home Assistant atualiza frequentemente - sempre faça backup antes

## Especificações Recomendadas para G9

- **CPU**: x86-64 (64-bit)
- **RAM**: Mínimo 2GB, recomendado 4GB+
- **Disco**: Mínimo 32GB, recomendado 128GB+ SSD
- **Rede**: Ethernet (Wi-Fi possível mas não recomendado)
