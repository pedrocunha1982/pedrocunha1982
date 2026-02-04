## Hi there 👋

# Dell - Ecra Preto (Sem Saida de Video) - Guia de Resolucao

O computador Dell esta ligado mas o ecra ficou preto/sem imagem. Abaixo estao os passos para diagnosticar e resolver o problema.

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
3. Se for portatil: **remova a bateria** (se possivel)
4. **Mantenha premido** o botao de power durante **30 segundos** (com tudo desconectado)
5. Reconecte o cabo de energia (e bateria, se aplicavel)
6. Ligue o computador

## Passo 3: Verificar Cabos e Ligacoes

- Verifique se o cabo de video (HDMI, DisplayPort, VGA) esta bem ligado
- Tente um **cabo diferente** se possivel
- Se tiver monitor externo, tente ligar a uma **porta de video diferente**
- Verifique se o monitor esta ligado e na fonte de entrada correta

## Passo 4: Monitor Externo / TV

- Ligue o Dell a um **monitor externo ou TV** usando HDMI
- Se aparecer imagem no monitor externo, o problema e no ecra do portatil
- Use a tecla **Fn + F8** (ou a tecla com icone de monitor) para alternar entre ecras

## Passo 5: Verificar LEDs e Sons de Diagnostico

Quando liga o Dell, observe:

| Sinal | Significado |
|-------|-------------|
| LED de power aceso fixo | Computador esta a receber energia |
| LED a piscar | Codigo de erro - conte as piscadelas |
| Beeps ao ligar | Codigo de erro de hardware |
| Ventoinhas a rodar | Placa-mae esta a funcionar |

### Codigos de LED comuns Dell:
- **2 piscadelas ambar, 3 brancas** = Problema de memoria RAM
- **2 piscadelas ambar, 4 brancas** = Problema de RAM incompativel
- **2 piscadelas ambar, 7 brancas** = Falha na placa grafica (GPU)
- **3 piscadelas ambar, 3 brancas** = Falha na recuperacao da BIOS (imagem nao encontrada)

## Passo 6: Recolocar a Memoria RAM

1. Desligue o computador e desconecte da energia
2. Abra a tampa traseira (portatil) ou a caixa (desktop)
3. **Remova os modulos de RAM** pressionando as patilhas laterais
4. Limpe os contactos dourados com uma borracha suave
5. **Recoloque a RAM** com firmeza ate ouvir o "click"
6. Tente ligar novamente

## Passo 7: Reset da BIOS/CMOS

- **Portatil Dell**: Desligue, remova a bateria, mantenha o botao power premido 30 seg
- **Desktop Dell**: Abra a caixa, localize a pilha CR2032 na placa-mae, remova-a durante 5 minutos, recoloque-a

## Passo 8: Recuperacao da BIOS (Ctrl + Esc)

Se suspeita que a BIOS ficou corrompida (ex: apos atualizacao falhada ou corte de energia):

1. **Desligue** o computador completamente
2. Mantenha premidas as teclas **Ctrl + Esc** ao mesmo tempo
3. **Enquanto mantem premidas**, ligue o computador pelo botao de power
4. **Solte as teclas** quando o LED piscar ou aparecer uma barra de progresso
5. Aguarde — o Dell vai tentar recuperar/reflash da BIOS automaticamente
6. O computador reinicia sozinho quando terminar

> **Nota**: Este processo pode demorar alguns minutos. Nao desligue o computador durante a recuperacao.

### Se aparecer o codigo 3 ambar + 3 brancas (BIOS nao encontrada):

O computador tentou recuperar a BIOS mas nao encontrou uma imagem valida. Precisa de criar uma **pen USB de recuperacao** noutro computador.

#### O que precisas:
- Uma **pen USB** (qualquer tamanho, minimo 1GB)
- Acesso a **outro computador** com internet
- O **Service Tag** do teu Dell (etiqueta por baixo/atras do computador, tipo: ABC1234)

#### Passo a passo (no outro computador):

1. Vai a **https://www.dell.com/support/home** e clica em "Identificar produto" ou introduz o Service Tag
2. Clica em **"Controladores e transferencias"** (Drivers & Downloads)
3. Em Categoria, filtra por **"BIOS"**
4. Faz download do ficheiro mais recente (e um **.exe**)
5. Insere a pen USB e **formata em FAT32**:
   - Windows: clica direito na pen > Formatar > seleciona FAT32 > Iniciar
6. Copia o ficheiro .exe para a **raiz da pen** (nao dentro de pastas)
7. **Renomeia** o ficheiro: muda a extensao de `.exe` para `.rcv`
   - Exemplo: `Inspiron_5520_BIOS_1.15.0.exe` → **`BIOS_IMG.rcv`**

#### Agora no Dell avariado:

1. Com o Dell **desligado**, insere a pen USB
2. Usa uma porta **USB preta (2.0)** em vez de azul (3.0) — funciona melhor
3. Usa o **teclado integrado** do portatil (nao externo)
4. Mantem premido **Ctrl + Esc** e liga o computador pelo botao power
5. Mantem premido durante **pelo menos 30 segundos**
6. Se aparecer um menu de recuperacao, seleciona o caminho da pen (raiz "/")
7. Aguarda — a barra de progresso pode demorar varios minutos
8. **NAO desligue o computador** durante o processo
9. O Dell reinicia sozinho quando terminar

> **Dica**: Se nao funcionar a primeira vez, tenta noutra porta USB e repete.

## Passo 9: Diagnostico Integrado Dell (Built-in Self Test)

1. Desligue o computador
2. Pressione e mantenha a tecla **D** enquanto liga o computador
3. Isto inicia o teste de diagnostico do ecra/LCD
4. Se aparecerem cores no ecra, o painel LCD esta funcional

### E se escolhi Diagnostico no Boot e o ecra ficou preto?

Se entrou no menu de boot, selecionou o diagnostico (SupportAssist) e o ecra ficou totalmente preto:

- **Espere no maximo 2-3 minutos** — o diagnostico pode demorar a iniciar
- Se continuar preto apos 3 minutos, **force o desligar** (botao power 10 segundos)
- Tente o **teste LCD direto com a tecla D** (descrito acima) — este teste e mais basico e funciona mesmo quando o diagnostico completo falha
- Se nem o teste com a tecla D mostrar imagem, o problema e provavelmente de hardware (ecra ou GPU)

## Passo 10: Modo Seguro (Se o Windows carrega)

Se o computador parece estar a carregar o Windows (ouve sons, disco a trabalhar):

1. Desligue o computador
2. Ligue e pressione **F8** repetidamente (ou Shift + F8)
3. Selecione **Modo Seguro**
4. Se funcionar em modo seguro: o problema e do driver grafico
5. Desinstale o driver grafico e reinicie normalmente

---

## Resumo Rapido

| # | Acao | Tempo |
|---|------|-------|
| 1 | Desligar e ligar (power cycle) | 1 min |
| 2 | Reset de energia (power drain) | 2 min |
| 3 | Verificar cabos | 1 min |
| 4 | Testar monitor externo | 2 min |
| 5 | Observar LEDs/beeps | 1 min |
| 6 | Recolocar RAM | 10 min |
| 7 | Reset BIOS/CMOS | 5 min |
| 8 | Recuperacao da BIOS (Ctrl+Esc) | 5 min |
| 9 | Teste LCD integrado (tecla D) | 2 min |
| 10 | Modo seguro | 5 min |

---

**Se nenhum passo resolver**: O problema pode ser na placa grafica (GPU) ou na placa-mae, e sera necessario assistencia tecnica profissional ou contactar o suporte Dell.
