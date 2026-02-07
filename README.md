## Hi there 👋

# Dell Precision 5820/T5820 - Ecra Preto (Sem Saida de Video) - Guia de Resolucao

O computador Dell Precision 5820 (T5820) esta ligado mas o ecra ficou preto/sem imagem. Este guia foi criado especificamente para este modelo de workstation, com base no manual oficial da Dell.

**Referencia**: [Dell Precision 5820 Owner's Manual](https://www.dell.com/support/manuals/en-us/precision-5820-workstation/precision_5820_om_pub/preboot-blinking-power-button-codes)

---

## Passo 1: Desligar e Ligar (Power Cycle Simples)

Antes de tudo, tente o basico:

1. **Desligue** o computador pelo botao de power (mantenha premido ate desligar)
2. **Espere 30 segundos**
3. **Ligue** novamente o computador
4. Se o ecra continuar preto, avance para o Passo 2

> Muitas vezes um simples "desliga e liga" resolve o problema — especialmente se o computador ficou em suspensao ou o sistema bloqueou.

## Passo 2: Reset de Energia (Power Drain)

Se o simples desligar e ligar nao resolveu, este passo forca um reset completo da energia interna.

1. **Desligue** o computador completamente (mantenha o botao de power premido 10 segundos)
2. **Desconecte** o cabo de energia da tomada
3. **Mantenha premido** o botao de power durante **30 segundos** (com tudo desconectado)
4. Reconecte o cabo de energia
5. Ligue o computador

## Passo 3: Verificar Cabos e Ligacoes

- Verifique se o cabo de video (HDMI, DisplayPort, VGA) esta bem ligado
- Tente um **cabo diferente** se possivel
- Tente ligar a uma **porta de video diferente** (a Precision 5820 tem varias saidas)
- Verifique se o monitor esta ligado e na fonte de entrada correta
- Se tiver placa grafica dedicada, ligue o cabo **diretamente na placa grafica** (nao na placa-mae)

## Passo 4: Monitor Externo / Testar Outro Monitor

- Ligue a Precision 5820 a um **monitor diferente ou TV** usando HDMI ou DisplayPort
- Se aparecer imagem no outro monitor, o problema e no monitor original
- Tente diferentes portas de video na placa grafica

---

## Passo 5: Verificar LEDs de Diagnostico (MUITO IMPORTANTE)

O Dell Precision 5820 usa o **botao de power** como indicador de diagnostico. O LED pisca em padroes de **ambar** e **branco** para indicar problemas.

### Como interpretar os codigos:

1. O LED pisca **X vezes em ambar** (cor laranja)
2. Pausa de 1.5 segundos
3. O LED pisca **Y vezes em branco**
4. Pausa de 3 segundos
5. O padrao repete-se

**Exemplo**: 2 piscadelas ambar + 3 piscadelas brancas = Codigo **2-3**

### Estados do LED de Power:

| Estado do LED | Significado |
|---------------|-------------|
| **Apagado** | Sem energia |
| **Branco fixo** | Estado normal (S0) - computador a funcionar |
| **Branco a piscar** | Modo de baixo consumo (S1/S3) - NAO e erro |
| **Ambar fixo** | POWER_GOOD ativo - fonte de alimentacao OK |
| **Ambar-Branco a piscar** | CODIGO DE ERRO - ver tabela abaixo |

---

## Tabela Completa de Codigos de Diagnostico - Precision 5820

| Codigo | Piscadelas | Problema | Solucao |
|--------|------------|----------|---------|
| **1-1** | 1 ambar, 1 branca | Placa-mae com defeito | Contactar suporte tecnico Dell |
| **1-2** | 1 ambar, 2 brancas | Placa-mae, fonte, ou cabos | Testar fonte (BIST Test), reconectar cabos de alimentacao |
| **1-3** | 1 ambar, 3 brancas | Placa-mae, memoria ou processador | Recolocar RAM e CPU; testar com modulos conhecidos |
| **1-4** | 1 ambar, 4 brancas | Pilha CMOS/CR2032 fraca | **Substituir pilha CR2032** na placa-mae |
| **2-1** | 2 ambar, 1 branca | CPU em configuracao ou falha de CPU | Recolocar CPU; contactar suporte se persistir |
| **2-2** | 2 ambar, 2 brancas | BIOS ROM corrompida (modo recovery) | **Fazer flash da BIOS** - ver Passo 8 |
| **2-3** | 2 ambar, 3 brancas | Memoria NAO detetada | Remover modulos RAM um a um; testar cada slot |
| **2-4** | 2 ambar, 4 brancas | Falha de memoria RAM | Remover modulos um a um para identificar o defeituoso |
| **2-5** | 2 ambar, 5 brancas | Memoria incompativel | Verificar compatibilidade da RAM; usar modulos compativeis |
| **2-6** | 2 ambar, 6 brancas | Falha no chipset da placa-mae | Remover componentes sistematicamente; contactar suporte |
| **2-7** | 2 ambar, 7 brancas | Falha na placa grafica (GPU) | Recolocar placa grafica; testar com outra GPU |
| **3-1** | 3 ambar, 1 branca | Falha de RTC/Relogio | Substituir pilha CMOS; reset da BIOS |
| **3-2** | 3 ambar, 2 brancas | Falha PCI/Video | Dispositivo PCI em configuracao ou com defeito; remover placas de expansao |
| **3-3** | 3 ambar, 3 brancas | BIOS Recovery - imagem nao encontrada | **Criar pen USB de recuperacao** - ver Passo 8 |
| **3-4** | 3 ambar, 4 brancas | Falha de recurso da placa-mae | Contactar suporte tecnico |
| **3-5** | 3 ambar, 5 brancas | EC nao responde | Remover energia; aguardar 30 seg; tentar novamente |
| **3-6** | 3 ambar, 6 brancas | Falha de SPI Flash | Flash da BIOS necessario |
| **4-7** | 4 ambar, 7 brancas | Tampa lateral aberta/removida | Desligar; instalar tampas laterais; religar |

---

## Passo 6: Recolocar a Memoria RAM

Este e um dos problemas mais comuns (codigos 2-3, 2-4, 2-5):

1. **Desligue** o computador e desconecte da energia
2. **Abra** a tampa lateral da Precision 5820
3. **Localize os slots de RAM** (normalmente 4 ou 8 slots)
4. **Pressione as patilhas laterais** para libertar cada modulo
5. **Remova todos os modulos** de RAM
6. **Limpe os contactos dourados** com uma borracha branca suave
7. **Recoloque UM modulo apenas** no slot 1 (DIMM1)
8. **Ligue o computador** - se funcionar, adicione modulos um a um
9. Se nao funcionar com nenhum modulo, experimente RAM de outro computador

> **Dica**: A Precision 5820 usa memoria ECC (se Xeon) ou non-ECC (se Core-X). Verifique compatibilidade.

## Passo 7: Reset da BIOS/CMOS

1. **Desligue** o computador e desconecte da energia
2. **Abra** a caixa da Precision 5820
3. **Localize a pilha CR2032** na placa-mae (pilha redonda prateada)
4. **Remova a pilha** com cuidado (use uma chave de fendas pequena)
5. **Aguarde 5 minutos** (ou pressione o botao power algumas vezes)
6. **Recoloque a pilha** (lado + para cima)
7. **Feche a caixa**, ligue a energia e teste

> **Nota**: Se o codigo de erro era 1-4, substitua a pilha por uma nova.

---

## Passo 8: Recuperacao da BIOS (Ctrl + Esc)

Se suspeita que a BIOS ficou corrompida (codigo 2-2 ou 3-3):

### Metodo 1: Recovery automatico

1. **Desligue** o computador completamente
2. Mantenha premidas as teclas **Ctrl + Esc** ao mesmo tempo
3. **Enquanto mantem premidas**, ligue o computador pelo botao de power
4. **Mantenha premido durante 30 segundos** ou ate ver atividade
5. Aguarde — o Dell vai tentar recuperar/reflash da BIOS automaticamente
6. O computador reinicia sozinho quando terminar

### Metodo 2: Recovery com pen USB (codigo 3-3)

Se o metodo 1 nao funcionar ou aparecer o codigo 3-3:

#### O que precisas:
- Uma **pen USB** (minimo 1GB, formatada em FAT32)
- Acesso a **outro computador** com internet
- O **Service Tag** do teu Dell (etiqueta na parte de tras da torre)

#### Passo a passo (no outro computador):

1. Vai a **https://www.dell.com/support/home**
2. Introduz o **Service Tag** ou procura "Precision 5820"
3. Clica em **"Controladores e transferencias"** (Drivers & Downloads)
4. Em Categoria, filtra por **"BIOS"**
5. Faz download do ficheiro mais recente (e um **.exe**)
6. Insere a pen USB e **formata em FAT32**:
   - Windows: clica direito na pen > Formatar > seleciona FAT32 > Iniciar
7. Copia o ficheiro .exe para a **raiz da pen** (nao dentro de pastas)
8. **Renomeia** o ficheiro para: **`BIOS_IMG.rcv`**
   - Exemplo: `Precision_5820_BIOS_2.15.0.exe` → `BIOS_IMG.rcv`

#### Agora na Precision 5820 avariada:

1. Com o Dell **desligado**, insere a pen USB
2. Usa uma porta **USB preta (2.0)** na parte de tras - funciona melhor
3. Mantem premido **Ctrl + Esc** e liga o computador
4. Mantem premido durante **pelo menos 30 segundos**
5. Se aparecer um menu de recuperacao, seleciona a pen USB
6. Aguarda — a barra de progresso pode demorar varios minutos
7. **NAO desligue o computador** durante o processo
8. O Dell reinicia sozinho quando terminar

> **Dica**: Se nao funcionar, tenta noutra porta USB e repete.

#### Scripts automaticos para preparar a pen USB:

**Windows** — `preparar_pen_bios.bat`:
1. Descarregar o ficheiro `preparar_pen_bios.bat`
2. Clicar direito > **Executar como administrador**
3. Seguir as instrucoes no ecra

**macOS** — `preparar_pen_bios_mac.sh`:
1. Abrir o **Terminal**
2. Executar: `chmod +x preparar_pen_bios_mac.sh && ./preparar_pen_bios_mac.sh`
3. Seguir as instrucoes

---

## Passo 9: Desconectar Discos M.2/NVMe (Diagnostico por Eliminacao)

**IMPORTANTE**: Se o sistema operativo (Windows/Linux/Ubuntu) estava a reportar erros antes do problema, ou se ja tentaste todos os passos acima sem sucesso, o SSD M.2 pode estar com defeito.

### Quando fazer isto:
- O Ubuntu/Linux reportou "problemas internos" ou erros de disco
- O Windows dava erros de SMART ou disco
- Codigo de LED relacionado com armazenamento
- Todos os outros passos falharam

### Como fazer:

1. **Desligue** o computador e desconecte da energia
2. **Abra** a caixa da Precision 5820
3. **Localize os slots M.2** na placa-mae (podem estar debaixo de dissipadores)
4. **Desaparafuse** o parafuso que segura cada M.2
5. **Remova os SSDs M.2** puxando suavemente
6. **Feche a caixa** e ligue o computador
7. **Observe**:
   - Se aparecer imagem/BIOS → o M.2 era o problema
   - Se continuar preto → problema e noutro componente

### Se aparecer imagem sem o M.2:

O SSD provavelmente esta com defeito. Podes:

1. **Arrancar de um USB Live** (Ubuntu/Linux) para testar o M.2
2. Verificar saude do SSD:
   ```bash
   sudo apt install smartmontools nvme-cli
   sudo smartctl -a /dev/nvme0n1   # Ver saude SMART
   sudo nvme smart-log /dev/nvme0n1  # Logs do NVMe
   ```
3. Tentar reparar o filesystem:
   ```bash
   sudo fsck -y /dev/nvme0n1p1
   ```
4. Se o SSD estiver com muitos erros, **substituir por um novo**

---

## Passo 10: Verificar/Recolocar Placa Grafica

Se o codigo de erro e 2-7 ou 3-2:

1. **Desligue** e desconecte da energia
2. **Abra** a caixa
3. **Desconecte** os cabos de alimentacao da placa grafica (6-pin ou 8-pin)
4. **Desaparafuse** a placa grafica do suporte traseiro
5. **Pressione a patilha** do slot PCIe e **remova** a placa
6. **Limpe** os contactos dourados com ar comprimido
7. **Recoloque** a placa com firmeza ate ouvir um click
8. **Reconecte** os cabos de alimentacao
9. **Teste** - se falhar, experimente outro slot PCIe ou outra GPU

---

## Passo 11: Diagnostico Integrado Dell (ePSA)

O Dell Precision 5820 tem diagnostico integrado (ePSA 3.0):

### Metodo 1: Menu de Boot
1. Ligue o computador
2. Pressione **F12** repetidamente durante o arranque
3. Selecione **"Diagnostics"** no menu
4. Aguarde os testes (pode demorar 10-30 minutos)

### Metodo 2: Tecla de atalho
1. Desligue o computador
2. Mantenha premida a tecla **Fn** (se tiver teclado Dell)
3. Ligue o computador mantendo Fn premido
4. O diagnostico inicia automaticamente

### Metodo 3: Teste LCD/Video
1. Desligue o computador
2. Mantenha premida a tecla **D**
3. Ligue o computador mantendo D premido
4. O ecra deve mostrar cores (vermelho, verde, azul, branco, preto)
5. Se aparecerem cores → ecra/monitor funciona
6. Se nada aparecer → problema de GPU ou monitor

---

## Passo 12: Modo Seguro (Se o Windows/Linux carrega)

Se o computador parece estar a carregar (ouve sons, disco a trabalhar):

### Windows:
1. Desligue o computador
2. Ligue e pressione **F8** repetidamente
3. Selecione **Modo Seguro**
4. Se funcionar → problema e do driver grafico
5. Desinstale o driver e reinicie

### Linux/Ubuntu:
1. Durante o arranque GRUB, selecione **"Advanced options"**
2. Escolha o kernel com **(recovery mode)**
3. Selecione **"resume"** para continuar em modo seguro
4. Se funcionar, pode ser problema de drivers Nvidia/AMD

---

## Resumo Rapido - Ordem de Diagnostico

| # | Acao | Codigo LED relacionado |
|---|------|------------------------|
| 1 | Power cycle simples | — |
| 2 | Power drain (30 seg) | — |
| 3 | Verificar cabos video | — |
| 4 | Testar outro monitor | — |
| 5 | **Observar codigo LED** | TODOS |
| 6 | Recolocar RAM | 2-3, 2-4, 2-5 |
| 7 | Reset CMOS/pilha | 1-4, 3-1 |
| 8 | Recovery BIOS (Ctrl+Esc) | 2-2, 3-3 |
| 9 | Desconectar M.2/SSD | Sistema com erros |
| 10 | Recolocar placa grafica | 2-7, 3-2 |
| 11 | Diagnostico ePSA (F12) | — |
| 12 | Modo seguro | Driver grafico |

---

## Links Uteis - Dell Precision 5820

- [Manual Oficial Dell Precision 5820](https://www.dell.com/support/manuals/en-us/precision-5820-workstation)
- [Codigos de Diagnostico LED](https://www.dell.com/support/manuals/en-us/precision-5820-workstation/precision_5820_om_pub/preboot-blinking-power-button-codes)
- [Guia de Diagnostico Precision Workstations](https://www.dell.com/support/kbdoc/en-us/000153002/a-reference-guide-to-the-precision-workstation-diagnostic-indicators)
- [Resolver No POST/No Video](https://www.dell.com/support/kbdoc/en-us/000125609/resolve-no-power-no-post-no-boot-or-no-video-issues-with-your-dell-computer)
- [Suporte Dell - Introduzir Service Tag](https://www.dell.com/support/home)

---

**Se nenhum passo resolver**: O problema pode ser na placa-mae ou processador, e sera necessario assistencia tecnica profissional ou contactar o suporte Dell (1-800-624-9896 nos EUA ou atraves do site).
