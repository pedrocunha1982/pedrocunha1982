# Guia de Instalação do Home Assistant OS no Computador G9

## Pré-requisitos
- Ubuntu Live USB bootado no computador G9
- Conexão com a internet
- Disco/SSD onde o Home Assistant OS será instalado

## IMPORTANTE: Backup
⚠️ **ATENÇÃO**: Este processo irá APAGAR TODOS OS DADOS do disco selecionado!
Faça backup de qualquer dado importante antes de continuar.

## Passo 1: Preparação no Ubuntu Live

### 1.1 Abrir Terminal
Pressione `Ctrl + Alt + T` para abrir o terminal no Ubuntu Live.

### 1.2 Identificar o Disco de Destino
Execute:
```bash
lsblk
```

Identifique o disco onde deseja instalar (exemplos):
- `/dev/sda` - Disco SATA tradicional
- `/dev/nvme0n1` - SSD NVMe
- `/dev/mmcblk0` - eMMC

**ANOTE O NOME DO DISCO** - você precisará dele!

### 1.3 Verificar Conexão com Internet
```bash
ping -c 4 google.com
```

## Passo 2: Baixar e Executar o Script de Instalação

### 2.1 Clonar este Repositório
```bash
cd ~
git clone https://github.com/pedrocunha1982/pedrocunha1982.git
cd pedrocunha1982
```

### 2.2 Tornar o Script Executável
```bash
chmod +x install_homeassistant.sh
```

### 2.3 Executar o Script
```bash
sudo ./install_homeassistant.sh
```

O script irá:
1. Verificar requisitos
2. Mostrar discos disponíveis
3. Solicitar confirmação do disco de destino
4. Baixar a versão mais recente do Home Assistant OS
5. Gravar a imagem no disco
6. Verificar a instalação

## Passo 3: Instalação Manual (Alternativa)

Se preferir fazer manualmente:

### 3.1 Baixar Home Assistant OS
```bash
cd ~/Downloads
wget https://github.com/home-assistant/operating-system/releases/download/13.2/haos_generic-x86-64-13.2.img.xz
```

### 3.2 Extrair a Imagem
```bash
unxz haos_generic-x86-64-13.2.img.xz
```

### 3.3 Gravar no Disco
**SUBSTITUA /dev/sdX pelo seu disco real!**
```bash
sudo dd if=haos_generic-x86-64-13.2.img of=/dev/sdX bs=4M status=progress conv=fsync
```

### 3.4 Sincronizar
```bash
sync
```

## Passo 4: Pós-Instalação

### 4.1 Remover o USB Live
Remova o pendrive do Ubuntu Live.

### 4.2 Reiniciar
```bash
sudo reboot
```

### 4.3 Primeiro Boot do Home Assistant
O computador deve bootar do disco onde instalou o Home Assistant OS.

**Aguarde 5-20 minutos** para o primeiro boot - o sistema fará configurações iniciais.

### 4.4 Acessar o Home Assistant
1. Descubra o IP do G9:
   - Verifique seu roteador
   - Ou use: `http://homeassistant.local:8123`

2. Abra no navegador:
   - `http://IP_DO_G9:8123`
   - Exemplo: `http://192.168.1.100:8123`

3. Configure sua conta inicial

## Resolução de Problemas

### O computador não boota do disco
- Verifique a ordem de boot na BIOS/UEFI
- Certifique-se que instalou no disco correto
- Verifique se UEFI/Legacy está configurado corretamente

### Não consigo acessar http://homeassistant.local:8123
- Use o IP direto ao invés do .local
- Verifique se está na mesma rede
- Aguarde mais tempo (primeiro boot pode demorar)

### Erro durante a gravação
- Verifique se o disco não está montado: `sudo umount /dev/sdX*`
- Tente outro disco/SSD
- Verifique a integridade do download

## Especificações do G9

Após a instalação, documente aqui as specs do G9:
- CPU:
- RAM:
- Disco:
- Rede:

## Referências
- [Home Assistant OS Releases](https://github.com/home-assistant/operating-system/releases)
- [Documentação Oficial](https://www.home-assistant.io/installation/)
