# Dell Precision 7820 — Diagnóstico e Plano de Recuperação da BIOS

## Sintoma observado

- Workstation **Dell Precision 7820 Tower** não arranca corretamente (sem POST visível).
- Padrão dos LEDs no botão de power: **3 piscadelas âmbar → pausa → 3 piscadelas brancas**.
- Código Dell **`3,3`** = **"BIOS Recovery image not found"**.

## O que esse código significa

A motherboard, CPU, RAM e a fonte de alimentação estão **funcionais o suficiente** para correr o *bootblock* de recuperação da BIOS. O sistema **sabe** que a BIOS principal está corrompida (ou inacessível) e está ativamente a tentar recuperar — mas **não encontra o ficheiro de imagem de recuperação** nem na partição escondida do disco, nem numa pen USB.

> Conclusão: **não é hardware partido**. É preciso entregar manualmente o ficheiro de recuperação da BIOS.

---

## Ferramentas disponíveis (em mãos)

Da bancada:

1. **Cartão POST card antigo (PCI + ISA)** — com Atmel AT89S52, PALCE16V8, SN74HC374, display de 4 dígitos, LEDs de tensão (-12V/+12V/+5V/+3.3V) e LEDs de bus (CLK/IRDY/FRAME/RESET).
   - ⚠️ **Não é compatível com o 7820**: o 7820 só tem slots **PCIe**. O PCI legacy e o ISA são fisicamente e eletricamente incompatíveis. Além disso, sistemas UEFI modernos já não escrevem fiavelmente códigos POST na porta `0x80`. Esta peça fica de fora.
2. **Adaptador "1.8V Adapter"** para programador SPI (CH341A) — necessário se o chip BIOS for de 1.8V (chips com sufixo `…W` no part number, ex. `W25Q128FW`).
3. **Clip de teste SOIC-8** — para ler/gravar o chip BIOS sem dessoldar.
4. **Adaptador / soquete SOIC-8** — para programar o chip já dessoldado.
5. **Cabo flat IDC** e display externo de 7-segmentos (acessório do POST card antigo — também não aplicável aqui).

---

## Plano de recuperação (em ordem)

### Plano A — Recovery via pen USB (tentar primeiro)

Probabilidade alta de resolver, ~15 minutos.

1. **Preparar a pen**:
   - USB 2.0 ≤ 8 GB.
   - Formatar **FAT32 / MBR** (não GPT).
2. **Obter a BIOS oficial**:
   - Ir a [dell.com/support](https://www.dell.com/support).
   - Introduzir a **Service Tag** do 7820.
   - Categoria **BIOS** → versão mais recente (`Precision_7820_2.X.X.exe`).
3. **Extrair o ficheiro de recuperação** (noutro PC Windows):
   ```
   Precision_7820_2.X.X.exe /writehdrfile
   ```
   Gera um `.hdr` na mesma pasta. Em alternativa, `/writeromfile` gera um `.rom`.
4. **Renomear** o ficheiro para exatamente:
   ```
   BIOS_IMG.rcv
   ```
   e copiar para a **raiz** da pen.
5. **Disparar o recovery**:
   1. Tirar o cabo de energia da tomada.
   2. Meter a pen numa porta **USB 2.0 traseira** do 7820.
   3. Ligar um **teclado USB com fios** (também na traseira — wireless não funciona neste modo).
   4. **Segurar `Ctrl + Esc`**.
   5. **Sem largar**, meter o cabo de energia na tomada.
   6. Carregar uma vez no botão de power.
   7. Continuar a segurar `Ctrl + Esc` até:
      - Aparecer a **barra de progresso "BIOS Recovery"** no ecrã, **OU**
      - Os **LEDs do teclado (Num/Caps)** piscarem.
   8. Largar. O recovery deteta o `BIOS_IMG.rcv` e faz flash automaticamente. **Não desligar** — 3 a 8 minutos.

**Dica extra antes**: limpar o CMOS — tirar a bateria CR2032 por ~1 minuto e voltar a colocar. Resolve estados presos de NVRAM que às vezes impedem o recovery.

---

### Plano B — Flash externo SPI (se o Plano A falhar)

Este é o cenário onde entram as ferramentas SPI da bancada.

1. **Localizar o chip BIOS** na motherboard:
   - SOIC-8, perto do chipset / bateria CMOS.
   - Marcações típicas: `25Q128`, `25Q256`, `W25Q…`, `MX25L…`.
   - **Verificar tensão**: sufixo `…W` no part number ⇒ **1.8V** ⇒ usar **obrigatoriamente** o adaptador 1.8V. Caso contrário, é 3.3V.
2. **Preparar a placa**:
   - **Desligar o cabo de energia** da tomada.
   - Remover a bateria CMOS.
   - Prender o **clip SOIC-8** no chip respeitando o **pino 1** (canto chanfrado / marca redonda do chip alinha com o pino 1 do clip — fio vermelho do flat).
3. **Backup obrigatório** (3 leituras, comparar hashes):
   ```bash
   sudo flashrom -p ch341a_spi -r backup1.bin
   sudo flashrom -p ch341a_spi -r backup2.bin
   sudo flashrom -p ch341a_spi -r backup3.bin
   sha256sum backup*.bin
   ```
   - Os três hashes **têm de ser idênticos**. Se não forem → mau contacto do clip → reposicionar e repetir. **Não gravar enquanto não bater certo.**
4. **Preparar o binário a gravar**:
   - O `.hdr`/`.rcv` da Dell **não é** o binário cru do chip — é um payload de recovery.
   - Opções:
     - **Opção limpa**: abrir o `backup1.bin` no **UEFITool** ou **Intel FIT**, substituir apenas a região **BIOS** mantendo Flash Descriptor, ME e GbE do backup. Evita brickar o **Intel Management Engine**.
     - **Opção bruta**: gravar o binário da Dell completo (se o backup estiver totalmente corrompido) e depois reconfigurar a ME com o **CSME System Tools**.
5. **Gravar**:
   ```bash
   sudo flashrom -p ch341a_spi -w bios_novo.bin -V
   ```
   Tempo: 3–10 min. Não tocar no clip durante o processo.
6. **Verificar**:
   ```bash
   sudo flashrom -p ch341a_spi -v bios_novo.bin
   ```
7. **Pós-flash**:
   - Voltar a ligar bateria CMOS e energia.
   - **Limpar CMOS** (jumper `RTCRST` ou tirar a CR2032 por 1 min).
   - Primeiro arranque pode demorar 1–2 min (inicialização da NVRAM nova).

---

## Notas de segurança

- ⚠️ **Nunca** ligar um clip SPI ao chip com a placa ligada à corrente.
- ⚠️ **Nunca** programar um chip de 1.8V com o programador em 3.3V sem o adaptador — destrói o chip e potencialmente o chipset.
- ⚠️ **Nunca** gravar sem ter pelo menos um backup com hash verificado.
- ⚠️ **Nunca** interromper o flash a meio (não desligar, não retirar o clip).

---

## O que confirmar antes de avançar

- [ ] Service Tag do 7820 (para descarregar a BIOS exata).
- [ ] Versão da BIOS que estava instalada antes do problema.
- [ ] Houve update de BIOS, queda de energia ou alteração de hardware recente?
- [ ] Acesso a outro PC Windows para extrair o `.hdr` da BIOS.
- [ ] Pen USB 2.0 ≤ 8 GB disponível.

---

## Decisão / próximos passos

1. Tentar **Plano A** (USB recovery). Se funcionar, fim do problema.
2. Se falhar (ou continuar com código `3,3` mesmo com pen pronta), avançar para **Plano B** (flash SPI externo) com as ferramentas em mãos.
3. Caso surja um padrão de LEDs **diferente** após qualquer tentativa, registar e re-diagnosticar com a tabela Dell de códigos de LED.
