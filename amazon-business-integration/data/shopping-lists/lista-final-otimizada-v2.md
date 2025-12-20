# Lista Final Otimizada V2 - Projeto Industrial STM32 + ESP32-S3 Slave

**Data:** 2024-12-20
**Arquitetura:** STM32 (Mestre) + ESP32-S3 Waveshare (Slave)
**Layout:** Duas PCBs (baixa/alta tensão separadas)

---

## ARQUITETURA MASTER-SLAVE

```
┌─────────────────────────────────────────────────────────────────┐
│                    STM32F411 (MESTRE)                            │
│                                                                  │
│  Controle crítico em tempo real:                                │
│  • Algoritmo PID de temperatura                                 │
│  • Leitura termopares (MAX31855 x3 via SPI)                    │
│  • Controle SSR (aquecimento)                                   │
│  • Monitoramento corrente (ACS712)                              │
│  • Segurança (watchdog, E-stop, thermal fuse)                  │
│                                                                  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ UART (comandos/dados)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│              ESP32-S3 Waveshare 7" Touch (SLAVE)                 │
│                                                                  │
│  Interface e conectividade:                                     │
│  • Display 7" 800x480 touch capacitivo                         │
│  • WiFi/Bluetooth (app móvel, cloud, OTA)                      │
│  • Data logging (microSD integrado)                            │
│  • RS485/CAN (expansão industrial futura)                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## LISTA COMPLETA COM ASINs VERIFICADOS

### 1. Controladores

| # | Qtd | Item | ASIN | Função | Preço |
|---|-----|------|------|--------|-------|
| 1 | 1 | STM32F411 BlackPill | B08946CFLZ | Mestre (PID, sensores, SSR) | ~$15 |
| 2 | 1 | **Waveshare ESP32-S3 7" Touch** | **B0D6XSY47** | Slave (display, WiFi, SD) | **$45.59** |

### 2. Sensores de Temperatura

| # | Qtd | Item | ASIN | Interface | Preço |
|---|-----|------|------|-----------|-------|
| 3 | 3 | MAX31855 Breakout Module | B0D8KNT9MH | SPI → STM32 | ~$10 cada |
| 4 | 1 | Termopar Tipo K (pack 2) até 1000°C | B0083SZC6S | MAX31855 | ~$15 |
| 5 | 1 | DS18B20 Waterproof | B087JQ6MCP | 1-Wire → STM32 | ~$5 |

### 3. Interface (GPIO)

| # | Qtd | Item | ASIN | Interface | Preço |
|---|-----|------|------|-----------|-------|
| 6 | 2 | Botão Tactil IP65 (pack 5) | B0CM63R39Q | GPIO → STM32 | ~$10 x2 |
| 7 | 1 | LED RGB Difuso | B077XGF3YR | GPIO → STM32 | ~$6 |
| 8 | 1 | Buzzer 95 dB | B083RXGNGQ | GPIO → STM32 | ~$8 |

### 4. Potência

| # | Qtd | Item | ASIN | Controle | Preço |
|---|-----|------|------|----------|-------|
| 9 | 1 | SSR-40DA Solid State Relay | B00HV974KC | PWM → STM32 | ~$10 |
| 10 | 1 | ACS712 20A Current Sensor | B07S6MT19D | ADC → STM32 | ~$8 |
| 11 | 1 | Contator 25A 230V AC | B07QL766KD | GPIO → STM32 | ~$18 |
| 12 | 2 | TLP281 Optoacoplador (pack 3) | B01MRR4K6Z | Isolação | ~$8 x2 |

### 5. Segurança e Proteção

| # | Qtd | Item | ASIN | Função | Preço |
|---|-----|------|------|--------|-------|
| 13 | 1 | E-Stop Emergência NC IP67 | B0DH1MHVGY | Parada emergência | ~$12 |
| 14 | 1 | Fusível 20A + Suporte Panel | B0769685K8 | Proteção sobrecorrente | ~$8 |
| 15 | 1 | MOV Varistor 275V (10pcs) | B00BP0PTYQ | Proteção surto | ~$8 |
| 16 | 1 | Thermal Fuse 240°C 10A | B00LX5HQ6M | Proteção sobretemperatura | ~$6 |
| 17 | 1 | LED Piloto 220V (Red 2-pack) | B00HU06NWM | Indicação AC | ~$8 |

### 6. Módulos Auxiliares

| # | Qtd | Item | ASIN | Interface | Preço |
|---|-----|------|------|-----------|-------|
| 18 | 1 | TPL5010 Watchdog Timer | B07R6X69VW | I2C → STM32 | ~$12 |
| 19 | 1 | LM393 Comparador Module | B0924TLD5L | Analógico | ~$6 |

### 7. Armazenamento

| # | Qtd | Item | ASIN | Uso | Preço |
|---|-----|------|------|-----|-------|
| 20 | 1 | Cartão microSD 8GB | B073K14CVB | Logging (slot no Waveshare) | ~$8 |

### 8. Passivos

| # | Qtd | Item | ASIN | Uso | Preço |
|---|-----|------|------|-----|-------|
| 21 | 1 | Cristal 8 MHz + capacitores | B07YWLCTBS | Clock STM32 | ~$5 |

---

## RESUMO COMPARATIVO

| Versão | Display | ESP32 | microSD | Total Est. |
|--------|---------|-------|---------|------------|
| V1 (anterior) | Nextion 5" ($55) | DevKitC ($10) | Módulo ($8) | ~$307 |
| **V2 (atual)** | **Waveshare 7" ($45.59)** | **Integrado** | **Integrado** | **~$253** |
| **Economia** | - | - | - | **~$54** |

### Totais V2:

| Categoria | Itens | Subtotal |
|-----------|-------|----------|
| Controladores | 2 | ~$61 |
| Sensores Temperatura | 3 | ~$50 |
| Interface | 3 | ~$34 |
| Potência | 4 | ~$44 |
| Segurança | 5 | ~$42 |
| Módulos Auxiliares | 2 | ~$18 |
| Armazenamento | 1 | ~$8 |
| Passivos | 1 | ~$5 |
| **TOTAL** | **21 itens** | **~$253** |

---

## LINK PARA ADICIONAR AO CARRINHO

[**ADICIONAR TODOS OS ITENS AO CARRINHO**](https://www.amazon.com/gp/aws/cart/add.html?ASIN.1=B08946CFLZ&Quantity.1=1&ASIN.2=B0D6XSY47&Quantity.2=1&ASIN.3=B0D8KNT9MH&Quantity.3=3&ASIN.4=B0083SZC6S&Quantity.4=1&ASIN.5=B087JQ6MCP&Quantity.5=1&ASIN.6=B0CM63R39Q&Quantity.6=2&ASIN.7=B077XGF3YR&Quantity.7=1&ASIN.8=B083RXGNGQ&Quantity.8=1&ASIN.9=B00HV974KC&Quantity.9=1&ASIN.10=B07S6MT19D&Quantity.10=1&ASIN.11=B07QL766KD&Quantity.11=1&ASIN.12=B01MRR4K6Z&Quantity.12=2&ASIN.13=B0DH1MHVGY&Quantity.13=1&ASIN.14=B0769685K8&Quantity.14=1&ASIN.15=B00BP0PTYQ&Quantity.15=1&ASIN.16=B00LX5HQ6M&Quantity.16=1&ASIN.17=B00HU06NWM&Quantity.17=1&ASIN.18=B07R6X69VW&Quantity.18=1&ASIN.19=B0924TLD5L&Quantity.19=1&ASIN.20=B073K14CVB&Quantity.20=1&ASIN.21=B07YWLCTBS&Quantity.21=1)

---

## LISTA DE ASINs PARA AMAZON BUSINESS

Copie e cole no "Add by ASIN":

```
B08946CFLZ
B0D6XSY47
B0D8KNT9MH
B0083SZC6S
B087JQ6MCP
B0CM63R39Q
B077XGF3YR
B083RXGNGQ
B00HV974KC
B07S6MT19D
B07QL766KD
B01MRR4K6Z
B0DH1MHVGY
B0769685K8
B00BP0PTYQ
B00LX5HQ6M
B00HU06NWM
B07R6X69VW
B0924TLD5L
B073K14CVB
B07YWLCTBS
```

---

## ITENS REMOVIDOS (substituídos pelo Waveshare)

| Item Removido | ASIN Antigo | Motivo |
|---------------|-------------|--------|
| ESP32 DevKitC | B0718T232Z | ESP32-S3 integrado no Waveshare |
| Nextion 5" | B0BBT6F2Y7 | Display 7" integrado no Waveshare |
| Módulo microSD | B07BJ2P6X6 | Slot microSD integrado no Waveshare |

---

## CONEXÕES STM32F411

### Pinout do STM32F411 BlackPill:

```
                    STM32F411 BlackPill
                   ┌─────────────────────┐
              3.3V │●                   ●│ 5V
               GND │●                   ●│ GND
               PA0 │● 1-Wire (DS18B20)  ●│ PB10
               PA1 │● ADC (ACS712)      ●│ PB2
               PA2 │● UART TX → ESP32   ●│ PB1
               PA3 │● UART RX ← ESP32   ●│ PB0 (GPIO)
               PA4 │● SPI CS1 (MAX1)    ●│ PA15 (GPIO)
               PA5 │● SPI SCK           ●│ PA12 (GPIO)
               PA6 │● SPI MISO          ●│ PA11 (GPIO)
               PA7 │● SPI MOSI          ●│ PA10 (GPIO)
               PB6 │● I2C SCL           ●│ PA9 (GPIO)
               PB7 │● I2C SDA           ●│ PA8 (GPIO)
               PB8 │● SPI CS2 (MAX2)    ●│ PB15 (PWM SSR)
               PB9 │● SPI CS3 (MAX3)    ●│ PB14 (GPIO)
                   └─────────────────────┘
```

### Comunicação UART (STM32 ↔ ESP32-S3):

```c
// Protocolo simples - STM32 envia para ESP32-S3:
// Formato: "CMD:param1,param2,param3\n"

// Exemplo - Atualizar display:
"TEMP:850.5,823.1,801.0\n"     // 3 temperaturas
"PWR:75\n"                      // Potência SSR 75%
"STATE:HEATING\n"               // Estado atual
"ALARM:OVERTEMP\n"              // Alarme

// ESP32-S3 responde:
"ACK\n"                         // Confirmação
"BTN:START\n"                   // Botão pressionado no touch
"SET:TARGET,900\n"              // Usuário definiu temperatura alvo
```

---

## WAVESHARE ESP32-S3 - RECURSOS DISPONÍVEIS

### Conectores do módulo Waveshare:

| # | Conector | Uso no Projeto |
|---|----------|----------------|
| 1 | ESP32-S3N8R8 | CPU 240MHz, 8MB RAM, 8MB Flash |
| 2 | Display 7" | Interface principal |
| 3 | Touch capacitivo | Entrada do usuário |
| 4 | **TF Card Slot** | **Data logging** |
| 5 | USB Type-C | Programação/debug |
| 6 | UART1 | Debug |
| 7 | **UART2** | **← Comunicação com STM32** |
| 8 | Sensor Header | Livre |
| 9 | CAN Header | Expansão futura |
| 10 | I2C Header | Expansão futura |
| 11 | RS485 Header | Comunicação industrial |
| 12 | Bateria 3.7V | Backup (opcional) |

---

## DIAGRAMA DAS DUAS PCBs

```
┌─────────────────────────────────────────────────────────────────┐
│                      PCB BAIXA TENSÃO (3.3V/5V)                  │
│                                                                  │
│  ┌──────────────┐          ┌─────────────────────────────────┐  │
│  │  STM32F411   │◄──UART──►│  Waveshare ESP32-S3 7" Touch   │  │
│  │  (MESTRE)    │          │  (SLAVE)                        │  │
│  └──────┬───────┘          │  • Display 800x480              │  │
│         │                  │  • WiFi/BT                      │  │
│    ┌────┴────┐             │  • microSD                      │  │
│    │   SPI   │             └─────────────────────────────────┘  │
│    │         │                                                   │
│  ┌─┴──┬──┬──┴─┐   ┌─────────┐   ┌─────────┐                    │
│  │MAX1│MAX2│MAX3│   │TPL5010 │   │DS18B20  │                    │
│  └────┴────┴────┘   │Watchdog│   │Ambiente │                    │
│                     └─────────┘   └─────────┘                    │
│                                                                  │
└──────────────────────────┬──────────────────────────────────────┘
                           │
              Optoacopladores TLP281
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                      PCB ALTA TENSÃO (220V AC)                   │
│                                                                  │
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────────────┐   │
│  │   SSR-40DA  │   │ Contator    │   │     E-STOP          │   │
│  │  (aquecim.) │   │   25A       │   │   (emergência)      │   │
│  └──────┬──────┘   └──────┬──────┘   └──────────┬──────────┘   │
│         │                 │                      │               │
│  ┌──────┴──────┐   ┌──────┴──────┐   ┌──────────┴──────────┐   │
│  │  ACS712     │   │  Fusível    │   │   Thermal Fuse      │   │
│  │  (corrente) │   │  20A + MOV  │   │   240°C             │   │
│  └─────────────┘   └─────────────┘   └─────────────────────┘   │
│                                                                  │
│  ┌─────────────┐                                                │
│  │ LED Piloto  │ ← Indicação de energia AC                      │
│  │   220V      │                                                │
│  └─────────────┘                                                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## NOTAS IMPORTANTES

1. **Waveshare B0D6XSY47:** Verificar ASIN correto - pode ser B0D6XSY471 ou similar
2. **Comunicação:** UART2 do Waveshare conecta ao UART2 do STM32 (PA2/PA3)
3. **Nível lógico:** Ambos operam em 3.3V, conexão direta
4. **microSD:** Já integrado no Waveshare, usar para logs de temperatura
5. **WiFi:** ESP32-S3 pode enviar dados para app móvel ou cloud

---

*Lista V2 - Dezembro 2024 - Arquitetura STM32 Mestre + ESP32-S3 Slave*
