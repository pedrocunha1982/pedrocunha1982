# Configuração BIOS Intel N150 - Versão Simplificada

## O que você está vendo na aba BOOT:

```
┌────────────────────────────────────────┐
│ BOOT                                   │
├────────────────────────────────────────┤
│ Setup Prompt Timeout    ........ 1     │
│ Bootup NumLock State           Off     │
│ Quiet Boot                   Enable    │
│                                        │
│ Boot Order (fixado):                   │
│   1. [...]                             │
│   2. [...]                             │
│   3. [...]                             │
└────────────────────────────────────────┘
```

## Configurações para Linux Live

### 1. Setup Prompt Timeout
**Valor:** Deixe em **1** ou aumente para **3**
- Isso dá mais tempo para pressionar F2/F12 ao ligar

### 2. Bootup NumLock State
**Valor:** Pode deixar **Off** (não afeta o boot)

### 3. Quiet Boot
**Valor:** Mude para **Disabled** (desabilitado)
- **Como mudar:** Use setas ↑↓ para selecionar, Enter para mudar
- **Por quê:** Com Quiet Boot desabilitado, você vê mensagens de boot e pode identificar problemas

### 4. Boot Order (Ordem de Boot) - MAIS IMPORTANTE!

Esta é a parte principal! Você precisa colocar o **USB** em primeiro lugar.

**Como deve ficar:**

```
┌────────────────────────────────────────┐
│ Boot Order:                            │
├────────────────────────────────────────┤
│ 1. USB Hard Disk                       │  ← Pendrive aqui!
│ 2. Hard Disk Drive                     │  ← HD interno
│ 3. CD/DVD Drive                        │
└────────────────────────────────────────┘
```

**Como mudar a ordem:**
1. Use setas ↑↓ para selecionar o item
2. Use **F5** (subir) ou **F6** (descer) para mover
   - Ou use teclas **+** (subir) e **-** (descer)
3. Coloque **USB Hard Disk** na posição **1**

## O que procurar na ordem de boot:

Seu pendrive pode aparecer como:
- **USB Hard Disk**
- **USB HDD**
- **Removable Device**
- **USB Storage**
- **USB: [marca do pendrive]**

**IMPORTANTE:** O pendrive só aparece se estiver inserido quando você ligar o PC!

## Outras Abas da BIOS

Já que sua BIOS não tem Secure Boot e Fast Boot na aba Boot, vamos verificar outras abas:

### Aba ADVANCED (se existir):

Procure por:
- **USB Configuration** → USB Controller: **Enabled**
- **SATA Configuration** → SATA Mode: **AHCI** (recomendado)

### Aba SECURITY (se existir):

Procure por:
- **Secure Boot** → **Disabled**
- Se não existir, não se preocupe (N150 antigo pode não ter)

## Passo a Passo Completo

### 1. Antes de ligar o PC:
```
✓ Insira o pendrive bootável
✓ Use porta USB 2.0 (preta, não azul)
```

### 2. Ligar e entrar na BIOS:
```
Ligar → Pressionar F2 repetidamente
```

### 3. Na aba BOOT:
```
Setup Prompt Timeout:  [1] ou [3]    (ok)
Bootup NumLock State:  [Off]         (ok)
Quiet Boot:            [Disabled]    (mudar para Disabled)
```

### 4. Configurar Boot Order:
```
Use ↑↓ para selecionar
Use F5/F6 ou +/- para mover

Resultado final:
1. USB Hard Disk        ← Pendrive
2. Hard Disk Drive      ← HD interno
3. CD/DVD               ← Opcional
```

### 5. Salvar:
```
Pressione F10
Confirme: Yes
PC reinicia automaticamente
```

## Se o USB não aparecer na lista

### Opção 1: Tente outra porta USB
- Desligue o PC completamente
- Mude o pendrive para outra porta USB
- Prefira portas USB 2.0 (pretas)
- Ligue e entre na BIOS (F2)

### Opção 2: Aba ADVANCED
```
Procure: Advanced → USB Configuration
Verifique: USB Controller [Enabled]
           USB 2.0 Controller [Enabled]
```

### Opção 3: Use Boot Menu (F12)
Em vez de entrar na BIOS:
```
1. Desligue o PC
2. Ligue e pressione F12 (repetidamente)
3. Menu aparece com lista de dispositivos
4. Selecione o USB com setas ↑↓
5. Pressione Enter
```

**Boot Menu é mais fácil!** Mostra todos os dispositivos disponíveis.

## Exemplo de Boot Menu (F12):

```
┌──────────────────────────────────┐
│ Please select boot device:       │
├──────────────────────────────────┤
│ > USB: SanDisk Ultra            │ ← Seu pendrive
│   SATA: WDC WD5000              │
│   CD/DVD Drive                   │
│                                  │
│ ESC to cancel                    │
└──────────────────────────────────┘
```

Use ↑↓ para selecionar USB e Enter para boot.

## Criando Pendrive Bootável Correto

Para BIOS antiga como a sua, use modo **Legacy/MBR**:

### Windows (Rufus):
```
1. Abra Rufus
2. Dispositivo: [Seu pendrive]
3. Seleção de boot: [Selecione a ISO]
4. Esquema de partição: MBR        ← IMPORTANTE!
5. Sistema de destino: BIOS ou UEFI
6. Iniciar
```

### Linux:
```bash
sudo dd if=linux.iso of=/dev/sdX bs=4M status=progress && sync
```

## Distribuições Recomendadas para N150

Como seu N150 é antigo (2010-2011), use Linux leve:

1. **Lubuntu 22.04 LTS** (muito leve)
2. **antiX** (extremamente leve)
3. **Puppy Linux** (roda na RAM)
4. **Linux Mint XFCE** (leve e completo)

Baixe versão **32-bit** se o processador for 32-bit!

## Verificar se N150 é 32 ou 64 bits

Intel Atom N150 pode ser:
- **N150**: 64-bit (mais comum)
- Alguns modelos: apenas 32-bit

**Como verificar:**
- Procure etiqueta no netbook com especificações
- Ou tente boot com ISO 64-bit (se não funcionar, use 32-bit)

## Resumo Final

**Configuração mínima necessária:**

```
┌─────────────────────────────────────┐
│ ABA BOOT                            │
├─────────────────────────────────────┤
│ Quiet Boot:        [Disabled]       │
│                                     │
│ Boot Order:                         │
│   1. USB Hard Disk    ← PRINCIPAL! │
│   2. Hard Disk Drive                │
│   3. CD/DVD                         │
│                                     │
│ F10 → Save & Exit                   │
└─────────────────────────────────────┘
```

**OU use F12 (Boot Menu) diretamente!**

## Problemas Comuns

### "USB não aparece na BIOS"
✓ Pendrive inserido antes de ligar?
✓ Porta USB 2.0 (preta)?
✓ Pendrive bootável em modo MBR/Legacy?
✓ Testou F12 (Boot Menu)?

### "Bootup error"
✓ Quiet Boot está Disabled? (para ver erro)
✓ Pendrive criado corretamente?
✓ ISO compatível com N150?

### "Sistema não inicia"
✓ Pendrive em 1º na ordem de boot?
✓ Tentou F12 e selecionou USB manualmente?

---

**Dica:** Seu N150 tem BIOS simples e antiga. Use **F12** para Boot Menu - é mais fácil que mexer na BIOS!

**Boa sorte!** 🐧
