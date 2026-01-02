# Configuração da BIOS Intel N150 para Linux Live

## Índice
1. [Preparação](#preparação)
2. [Acessando a BIOS](#acessando-a-bios)
3. [Configurações Necessárias](#configurações-necessárias)
4. [Ordem de Boot](#ordem-de-boot)
5. [Solução de Problemas](#solução-de-problemas)

## Preparação

Antes de configurar a BIOS, certifique-se de ter:

- **Pendrive bootável** com Linux Live (mínimo 4GB)
- **ISO do Linux** de sua escolha (Ubuntu, Linux Mint, Fedora, etc.)
- **Ferramenta para criar pendrive bootável**: Rufus (Windows), Etcher (multiplataforma), ou dd (Linux)

### Criando o Pendrive Bootável

#### No Windows (usando Rufus):
1. Baixe o Rufus em https://rufus.ie
2. Insira o pendrive (será formatado)
3. Selecione a ISO do Linux
4. Escolha esquema de partição: **MBR** para BIOS ou **GPT** para UEFI
5. Clique em "Iniciar"

#### No Linux:
```bash
# Identifique o dispositivo (ex: /dev/sdb)
lsblk

# Crie o pendrive bootável (CUIDADO: substitua /dev/sdX pelo seu dispositivo)
sudo dd if=linux.iso of=/dev/sdX bs=4M status=progress && sync
```

## Acessando a BIOS

### Passos para Entrar na BIOS Intel N150:

1. **Desligue o computador** completamente
2. **Ligue o computador** e **pressione repetidamente** a tecla de acesso:
   - **F2** - Tecla principal para Intel N150
   - **Del** ou **Delete** - Alternativa em alguns modelos
   - **F10** - Em alguns fabricantes
   - **F12** - Para menu de boot rápido (Boot Menu)

3. **Timing é importante**: Comece a pressionar a tecla assim que o computador ligar, antes do logo do Windows aparecer

### Dica: Boot Menu Direto
- Pressione **F12** ao ligar para acessar o menu de boot sem entrar na BIOS
- Isso permite selecionar o dispositivo de boot uma única vez

## Configurações Necessárias

### 1. Modo de Boot (UEFI vs Legacy/BIOS)

**Para Intel N150 (geralmente suporta Legacy BIOS):**

Navegue até a aba **Boot** ou **Startup**:

```
Boot Mode: [Legacy] ou [UEFI] ou [Both]
```

**Recomendações:**
- Para sistemas antigos (pré-2012): Use **Legacy** ou **CSM Enabled**
- Para sistemas modernos: Use **UEFI**
- Se não souber: Tente **Both** ou **Legacy First**

### 2. Secure Boot (se disponível)

```
Secure Boot: [Disabled]
```

**Importante:** Secure Boot pode impedir o boot de algumas distribuições Linux. Desabilite-o inicialmente.

### 3. Fast Boot

```
Fast Boot: [Disabled]
```

Desabilitar Fast Boot ajuda a detectar dispositivos USB durante a inicialização.

### 4. USB Boot

```
USB Boot: [Enabled]
```

Certifique-se de que o boot por USB está habilitado.

## Ordem de Boot

### Configurando a Prioridade de Boot:

1. Na BIOS, navegue até **Boot** → **Boot Priority** ou **Boot Order**

2. Configure a ordem (use F5/F6 ou +/- para mover):
   ```
   1st Boot Device: USB HDD ou USB Storage
   2nd Boot Device: Hard Drive ou HDD
   3rd Boot Device: CD/DVD (opcional)
   ```

3. **Alternativa:** Alguns modelos mostram assim:
   ```
   Boot Option #1: [USB Hard Disk]
   Boot Option #2: [SATA HDD]
   Boot Option #3: [Network Boot]
   ```

### Exemplo Visual da Configuração:

```
╔════════════════════════════════════════╗
║        BOOT CONFIGURATION              ║
╠════════════════════════════════════════╣
║ Boot Mode:        [Legacy]             ║
║ Secure Boot:      [Disabled]           ║
║ Fast Boot:        [Disabled]           ║
║ USB Boot:         [Enabled]            ║
║                                        ║
║ BOOT ORDER:                            ║
║  1. USB Hard Disk                      ║
║  2. SATA Hard Drive                    ║
║  3. Network Boot                       ║
║                                        ║
║ F5/F6: Move  F10: Save & Exit         ║
╚════════════════════════════════════════╝
```

## Salvando e Saindo

1. Pressione **F10** para "Save Changes and Exit"
2. Confirme com **Yes** ou **Enter**
3. O computador reiniciará

### Com o Pendrive Inserido:
- Se configurado corretamente, o Linux Live iniciará automaticamente
- Você verá o menu do GRUB ou o logo da distribuição

## Solução de Problemas

### Problema 1: BIOS não abre

**Soluções:**
- Tente diferentes teclas: F2, Del, F10, F12
- Pressione a tecla **antes** do logo do Windows aparecer
- Desligue completamente (não use reiniciar)
- Desconecte a bateria por 30 segundos (notebooks)

### Problema 2: Pendrive não aparece no boot

**Soluções:**
1. **Verifique se o pendrive está bootável:**
   - Recrie o pendrive usando outra ferramenta
   - Use modo Legacy (MBR) em vez de UEFI (GPT)

2. **Na BIOS:**
   - Habilite "USB Boot" ou "USB Storage Boot"
   - Desabilite "Fast Boot"
   - Desabilite "Secure Boot"

3. **Teste outra porta USB:**
   - Prefira portas USB 2.0 (geralmente funcionam melhor)
   - Evite hubs USB

### Problema 3: Boot inicia mas trava

**Soluções:**
1. **Tente opções nocompatíveis no GRUB:**
   - Ao iniciar o Linux, pressione 'e' no menu GRUB
   - Adicione ao final da linha do kernel:
     ```
     nomodeset acpi=off noapic
     ```
   - Pressione F10 para boot

2. **Modo de compatibilidade:**
   - No menu do Linux Live, escolha "Safe Graphics Mode" ou "Compatibility Mode"

### Problema 4: Sistema não encontra hard drive depois

**Solução:**
- Na BIOS, volte a ordem de boot:
  ```
  1st Boot Device: Hard Drive
  2nd Boot Device: USB
  ```
- Ou remova o pendrive durante o boot

## Configurações Específicas Intel N150

### Características do Intel N150:
- **Processador:** Intel Atom N150 (32-bit ou 64-bit)
- **Chipset:** Intel NM10
- **Ano:** 2010-2011
- **BIOS:** Geralmente Phoenix ou InsydeH2O

### Distribuições Linux Recomendadas para N150:

Devido às limitações de hardware (processador Atom, pouca RAM):

1. **Lubuntu** - Muito leve, baseado em Ubuntu
2. **Linux Mint XFCE** - Leve e amigável
3. **Puppy Linux** - Extremamente leve
4. **antiX** - Leve e rápido
5. **Bodhi Linux** - Minimalista

### Configuração Otimizada para N150:

```
Boot Mode:           Legacy
Secure Boot:         Disabled (se disponível)
Fast Boot:           Disabled
USB Boot:            Enabled
SATA Mode:           AHCI (melhor performance)
Virtualization:      Disabled (economiza recursos)
```

## Atalhos de Teclado Comuns

| Tecla | Função |
|-------|--------|
| **F2** | Entrar na BIOS/Setup |
| **F10** | Salvar e Sair |
| **F12** | Menu de Boot (Boot Menu) |
| **ESC** | Cancelar/Voltar |
| **F5/F6** | Mover itens para cima/baixo |
| **+/-** | Alterar valores |
| **Enter** | Selecionar/Confirmar |

## Checklist Final

Antes de fazer o boot do Linux Live:

- [ ] Pendrive bootável criado corretamente
- [ ] Pendrive inserido na porta USB (prefira USB 2.0)
- [ ] BIOS configurada com Boot Mode adequado (Legacy ou UEFI)
- [ ] Secure Boot desabilitado
- [ ] Fast Boot desabilitado
- [ ] USB Boot habilitado
- [ ] Ordem de boot: USB em primeiro
- [ ] Configurações salvas (F10)
- [ ] Computador reiniciado

## Recursos Adicionais

### Testando a ISO antes de gravar:
```bash
# Verifique o checksum da ISO baixada
sha256sum linux.iso

# Compare com o checksum oficial do site
```

### Backup da configuração atual:
- Anote as configurações originais da BIOS antes de alterar
- Tire fotos com o celular de cada tela da BIOS

## Próximos Passos

Após fazer boot do Linux Live:

1. **Teste o sistema** sem instalar (modo Live)
2. **Verifique compatibilidade** de hardware (Wi-Fi, som, vídeo)
3. **Decida se quer instalar** permanentemente
4. **Faça backup** dos dados importantes antes de instalar

---

**Nota:** Este guia é baseado em configurações comuns para Intel N150. Algumas opções podem variar dependendo do fabricante do netbook (Asus, Acer, HP, etc.).

**Data de criação:** Janeiro 2026
**Compatibilidade:** Intel Atom N150 e processadores similares
