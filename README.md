## Hi there 👋

# Dell - Ecra Preto (Sem Saida de Video) - Guia de Resolucao

O computador Dell esta ligado mas o ecra ficou preto/sem imagem. Abaixo estao os passos para diagnosticar e resolver o problema.

---

## Passo 1: Reset de Energia (Power Drain)

Este e o passo mais importante e resolve a maioria dos casos.

1. **Desligue** o computador completamente (mantenha o botao de power premido 10 segundos)
2. **Desconecte** o cabo de energia da tomada
3. Se for portatil: **remova a bateria** (se possivel)
4. **Mantenha premido** o botao de power durante **30 segundos** (com tudo desconectado)
5. Reconecte o cabo de energia (e bateria, se aplicavel)
6. Ligue o computador

## Passo 2: Verificar Cabos e Ligacoes

- Verifique se o cabo de video (HDMI, DisplayPort, VGA) esta bem ligado
- Tente um **cabo diferente** se possivel
- Se tiver monitor externo, tente ligar a uma **porta de video diferente**
- Verifique se o monitor esta ligado e na fonte de entrada correta

## Passo 3: Monitor Externo / TV

- Ligue o Dell a um **monitor externo ou TV** usando HDMI
- Se aparecer imagem no monitor externo, o problema e no ecra do portatil
- Use a tecla **Fn + F8** (ou a tecla com icone de monitor) para alternar entre ecras

## Passo 4: Verificar LEDs e Sons de Diagnostico

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

## Passo 5: Recolocar a Memoria RAM

1. Desligue o computador e desconecte da energia
2. Abra a tampa traseira (portatil) ou a caixa (desktop)
3. **Remova os modulos de RAM** pressionando as patilhas laterais
4. Limpe os contactos dourados com uma borracha suave
5. **Recoloque a RAM** com firmeza ate ouvir o "click"
6. Tente ligar novamente

## Passo 6: Reset da BIOS/CMOS

- **Portatil Dell**: Desligue, remova a bateria, mantenha o botao power premido 30 seg
- **Desktop Dell**: Abra a caixa, localize a pilha CR2032 na placa-mae, remova-a durante 5 minutos, recoloque-a

## Passo 7: Diagnostico Integrado Dell (Built-in Self Test)

1. Desligue o computador
2. Pressione e mantenha a tecla **D** enquanto liga o computador
3. Isto inicia o teste de diagnostico do ecra/LCD
4. Se aparecerem cores no ecra, o painel LCD esta funcional

## Passo 8: Modo Seguro (Se o Windows carrega)

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
| 1 | Reset de energia (power drain) | 2 min |
| 2 | Verificar cabos | 1 min |
| 3 | Testar monitor externo | 2 min |
| 4 | Observar LEDs/beeps | 1 min |
| 5 | Recolocar RAM | 10 min |
| 6 | Reset BIOS/CMOS | 5 min |
| 7 | Teste LCD integrado (tecla D) | 2 min |
| 8 | Modo seguro | 5 min |

---

**Se nenhum passo resolver**: O problema pode ser na placa grafica (GPU) ou na placa-mae, e sera necessario assistencia tecnica profissional ou contactar o suporte Dell.
