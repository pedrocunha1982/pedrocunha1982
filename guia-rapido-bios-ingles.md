# Guia Rápido - BIOS em Inglês (Intel N150)

## Acessar a BIOS

**Teclas para pressionar ao ligar:**
- **F2** (principal) ou **Del** ou **F12**

---

## Configurações Principais (em Inglês)

### Aba: BOOT ou STARTUP

```
┌─────────────────────────────────────────┐
│ Boot Configuration                      │
├─────────────────────────────────────────┤
│ Boot Mode: [Legacy] ◄── Selecione aqui │
│   Opções: Legacy / UEFI / Both          │
│                                         │
│ Secure Boot: [Disabled] ◄── Desabilite │
│                                         │
│ Fast Boot: [Disabled] ◄── Desabilite   │
│                                         │
│ USB Boot: [Enabled] ◄── Habilite       │
└─────────────────────────────────────────┘
```

### Ordem de Boot (Boot Priority / Boot Order)

```
┌─────────────────────────────────────────┐
│ Boot Priority Order                     │
├─────────────────────────────────────────┤
│ 1st Boot Device: [USB HDD]              │
│ 2nd Boot Device: [Hard Disk Drive]      │
│ 3rd Boot Device: [CD/DVD]               │
│                                         │
│ Use ↑↓ ou F5/F6 para mover             │
└─────────────────────────────────────────┘
```

Ou pode aparecer assim:

```
┌─────────────────────────────────────────┐
│ Boot Option Priorities                  │
├─────────────────────────────────────────┤
│ Boot Option #1: [USB Hard Disk]         │
│ Boot Option #2: [SATA HDD: ...]         │
│ Boot Option #3: [Network Boot]          │
└─────────────────────────────────────────┘
```

---

## Termos da BIOS - Tradução

| Inglês (BIOS) | Português | O que fazer |
|---------------|-----------|-------------|
| **Boot** | Inicialização | Entre nesta aba |
| **Boot Mode** | Modo de Boot | Selecione "Legacy" |
| **Legacy** | BIOS tradicional | Melhor para N150 |
| **UEFI** | BIOS moderna | Pode não funcionar |
| **Secure Boot** | Boot Seguro | Coloque "Disabled" |
| **Disabled** | Desabilitado | ✓ Desligado |
| **Enabled** | Habilitado | ✓ Ligado |
| **Fast Boot** | Boot Rápido | Coloque "Disabled" |
| **USB Boot** | Boot por USB | Coloque "Enabled" |
| **Boot Priority** | Prioridade de Boot | Ordem dos dispositivos |
| **Boot Order** | Ordem de Boot | Mesma coisa |
| **1st Boot Device** | 1º Dispositivo | Coloque USB aqui |
| **USB HDD** | HD USB | Seu pendrive |
| **USB Storage** | Armazenamento USB | Seu pendrive |
| **Hard Disk Drive** | Disco Rígido | HD interno |
| **SATA HDD** | HD SATA | HD interno |
| **CD/DVD** | Leitor de CD/DVD | Disco óptico |
| **Network Boot** | Boot por Rede | PXE boot |
| **Save & Exit** | Salvar e Sair | F10 para salvar |
| **Exit Without Saving** | Sair sem Salvar | ESC para cancelar |
| **Load Defaults** | Carregar Padrões | Restaurar original |
| **AHCI** | Modo SATA moderno | Recomendado |
| **IDE** | Modo SATA antigo | Compatibilidade |

---

## Passo a Passo Rápido

### 1. Entrar na BIOS
```
Ligar PC → Pressionar F2 repetidamente
```

### 2. Ir para configurações de Boot
```
Use as setas ← → para mover entre abas
Procure: "Boot" ou "Startup"
```

### 3. Configurar Boot Mode
```
Boot Mode: [Legacy]  ← Use Enter para mudar
```

### 4. Desabilitar Secure Boot (se existir)
```
Secure Boot: [Disabled]
```

### 5. Desabilitar Fast Boot
```
Fast Boot: [Disabled]
```

### 6. Habilitar USB Boot
```
USB Boot: [Enabled]
```

### 7. Configurar ordem de boot
```
Procure: "Boot Priority" ou "Boot Order"
Use F5/F6 ou +/- para mover:

1st: USB HDD (ou USB Storage)
2nd: Hard Disk Drive (HD interno)
```

### 8. Salvar e Sair
```
Pressione F10
Aparece: "Save configuration and exit?"
Selecione: Yes ou OK
Pressione: Enter
```

---

## Nomes Comuns para Pendrive USB

Na BIOS, seu pendrive pode aparecer como:

- `USB HDD`
- `USB Hard Disk`
- `USB Storage Device`
- `Removable Device`
- `Generic USB Storage`
- `USB: [Nome do fabricante]` (ex: USB: SanDisk)
- `UEFI: [Nome]` (se bootável UEFI)

**Importante:** O pendrive só aparece se estiver inserido quando ligar o PC!

---

## Atalhos de Teclado

```
F2        → Enter Setup (Entrar na BIOS)
F10       → Save and Exit (Salvar e Sair)
F12       → Boot Menu (Menu de Boot)
ESC       → Exit / Cancel (Sair/Cancelar)
F5        → Move Up (Mover para cima)
F6        → Move Down (Mover para baixo)
+ / -     → Change Value (Mudar valor)
Enter     → Select (Selecionar)
← →       → Navigate Tabs (Navegar abas)
↑ ↓       → Navigate Options (Navegar opções)
```

---

## Abas Comuns da BIOS

```
┌────────────────────────────────────────────┐
│ Main | Advanced | Security | Boot | Exit  │
├────────────────────────────────────────────┤
│                                            │
│ Main      → Informações básicas (data/hora)│
│ Advanced  → Configurações avançadas        │
│ Security  → Senhas e segurança             │
│ Boot      → VOCÊ PRECISA DESTA! ◄─────────│
│ Exit      → Salvar/Sair/Cancelar           │
│                                            │
└────────────────────────────────────────────┘
```

---

## Menu de Boot Rápido (F12)

Se pressionar **F12** ao ligar, pode ver:

```
┌──────────────────────────────┐
│ Please select boot device:   │
├──────────────────────────────┤
│ > USB Hard Disk              │ ← Selecione isto!
│   SATA HDD: WDC WD5000       │
│   CD/DVD Drive               │
│   Network Boot               │
│                              │
│ Enter Setup (F2)             │
└──────────────────────────────┘
```

Use ↑↓ para selecionar e Enter para boot.

---

## Configuração Completa Recomendada

```
╔══════════════════════════════════════════╗
║           BOOT SETTINGS                  ║
╠══════════════════════════════════════════╣
║ Boot Mode:            [Legacy]           ║
║ Boot Type:            [Legacy]           ║
║ CSM Support:          [Enabled]          ║
║ Secure Boot:          [Disabled]         ║
║ Fast Boot:            [Disabled]         ║
║ USB Boot:             [Enabled]          ║
║ Network Boot:         [Disabled]         ║
║                                          ║
║ BOOT PRIORITY ORDER:                     ║
║   1. USB Hard Disk                       ║
║   2. SATA HDD: WDC...                    ║
║   3. Disabled                            ║
║                                          ║
║ [F10] Save & Exit                        ║
╚══════════════════════════════════════════╝
```

---

## Mensagens de Confirmação

Quando pressionar F10:

```
┌─────────────────────────────────────┐
│ Setup Confirmation                  │
├─────────────────────────────────────┤
│ Save configuration changes and exit?│
│                                     │
│         [Yes]        [No]           │
└─────────────────────────────────────┘
```

**Selecione "Yes" e pressione Enter**

---

## Se o Pendrive Não Aparecer

### Checklist:

1. **Pendrive inserido?**
   - Insira ANTES de ligar o PC
   - Use porta USB 2.0 (geralmente preta)

2. **USB Boot habilitado?**
   ```
   USB Boot: [Enabled] ✓
   ```

3. **Tente F12 (Boot Menu) ao ligar**
   - Mais fácil que entrar na BIOS
   - Mostra todos dispositivos disponíveis

4. **Recrie o pendrive:**
   - Modo Legacy/MBR (não UEFI/GPT)
   - Use Rufus no Windows
   - Selecione "MBR partition scheme"

---

## Restaurar Configuração Original

Se algo der errado:

```
1. Entre na BIOS (F2)
2. Procure: "Load Setup Defaults"
   Ou: "Load Optimized Defaults"
   Ou: "Restore Defaults"
3. Pressione Enter
4. Confirme: Yes
5. Pressione F10 para salvar
```

---

## Problemas Comuns

### "No bootable device"

**Significa:** Nenhum dispositivo bootável encontrado

**Solução:**
1. Verifique se pendrive está inserido
2. Recrie o pendrive bootável
3. Tente Boot Menu (F12)

### "Secure Boot Violation"

**Significa:** Secure Boot está bloqueando

**Solução:**
```
Security → Secure Boot → [Disabled]
```

### "Operating System not found"

**Significa:** Sistema não encontrado

**Solução:**
1. Boot Mode errado (troque Legacy ↔ UEFI)
2. Pendrive não bootável (recrie)

---

## Exemplo Real de Tela BIOS (InsydeH2O)

```
┌────────────────────────────────────────────────────────┐
│  InsydeH20 Setup Utility                               │
├─┬──────────────────────────────────────────────────────┤
│M│ Main   Advanced   Security   Boot   Exit             │
│a├──────────────────────────────────────────────────────┤
│i│ Boot Configuration                                   │
│n│                                                      │
│ │   Boot Mode             [Legacy]                     │
│ │   PXE Boot to LAN       [Disabled]                   │
│ │   Fast Boot             [Disabled]                   │
│ │                                                      │
│ │ Boot Priority Order                                  │
│ │                                                      │
│ │   Boot Option #1        [USB Hard Disk]              │
│ │   Boot Option #2        [SATA HDD: WDC WD5000]       │
│ │   Boot Option #3        [Disabled]                   │
│ │                                                      │
├─┴──────────────────────────────────────────────────────┤
│ ↑↓: Move  Enter: Select  F5/F6: Change  F10: Save      │
└────────────────────────────────────────────────────────┘
```

---

**Dica Final:** Tire foto de cada tela com o celular para não esquecer as configurações originais!

**Boa sorte!** 🐧
