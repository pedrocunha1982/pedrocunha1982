# Lista Final Otimizada - Projeto Industrial ESP32/STM32

**Data:** 2024-12-20
**Objetivo:** Controle via ESP32/STM32 (NÃO PID standalone)
**Arquitetura:** Duas PCBs (baixa/alta tensão separadas)

---

## LISTA COMPLETA COM ASINs VERIFICADOS

### Microcontroladores (Controle Principal)

| # | Qtd | Item | ASIN | Interface | Preço Est. |
|---|-----|------|------|-----------|------------|
| 1 | 1 | STM32F411 BlackPill | B08946CFLZ | USB/SPI/I2C | ~$15 |
| 2 | 1 | ESP32 DevKitC | B0718T232Z | WiFi/BT/SPI | ~$10 |

### Sensores de Temperatura (SPI - Compatível STM32/ESP32)

| # | Qtd | Item | ASIN | Interface | Preço Est. |
|---|-----|------|------|-----------|------------|
| 3 | 3 | MAX31855 Breakout Module | B0D8KNT9MH | SPI | ~$10 cada |
| 4 | 1 | Termopar Tipo K (pack 5) até 1000°C | B0083SZC6S | Analógico | ~$15 |
| 5 | 1 | DS18B20 Waterproof | B087JQ6MCP | 1-Wire | ~$5 |

### Display e Interface (UART/GPIO)

| # | Qtd | Item | ASIN | Interface | Preço Est. |
|---|-----|------|------|-----------|------------|
| 6 | 1 | Display Nextion 5" | B0BBT6F2Y7 | UART | ~$55 |
| 7 | 2 | Botão Tactil IP65 (pack 5) | B0CM63R39Q | GPIO | ~$10 x2 |
| 8 | 1 | LED RGB Difuso | B077XGF3YR | GPIO/PWM | ~$6 |
| 9 | 1 | Buzzer 95 dB | B083RXGNGQ | GPIO | ~$8 |

### Potência (Controlado por GPIO/PWM)

| # | Qtd | Item | ASIN | Controle | Preço Est. |
|---|-----|------|------|----------|------------|
| 10 | 1 | SSR-40DA Solid State Relay | B00HV974KC | 3-32V DC | ~$10 |
| 11 | 1 | ACS712 20A Current Sensor | B07S6MT19D | Analógico | ~$8 |
| 12 | 1 | Contator 25A 230V AC | B07QL766KD | Bobina 230V | ~$18 |
| 13 | 2 | TLP281 Optoacoplador (pack 3) | B01MRR4K6Z | GPIO | ~$8 x2 |

### Segurança e Proteção

| # | Qtd | Item | ASIN | Função | Preço Est. |
|---|-----|------|------|--------|------------|
| 14 | 1 | E-Stop Emergência NC IP67 | B0DH1MHVGY | NC contato | ~$12 |
| 15 | 1 | Fusível 20A + Suporte Panel | B0769685K8 | Proteção | ~$8 |
| 16 | 1 | MOV Varistor 275V (10pcs) | B00BP0PTYQ | Surge | ~$8 |
| 17 | 1 | Thermal Fuse 240°C 10A | B00LX5HQ6M | Cutoff | ~$6 |
| 18 | 1 | LED Piloto 220V (Red 2-pack) | B00HU06NWM | Indicação | ~$8 |

### Módulos Auxiliares

| # | Qtd | Item | ASIN | Interface | Preço Est. |
|---|-----|------|------|-----------|------------|
| 19 | 1 | TPL5010 Watchdog Timer | B07R6X69VW | I2C | ~$12 |
| 20 | 1 | LM393 Comparador Module | B0924TLD5L | Analógico | ~$6 |

### Armazenamento (SPI - Compatível STM32/ESP32)

| # | Qtd | Item | ASIN | Interface | Preço Est. |
|---|-----|------|------|-----------|------------|
| 21 | 1 | Módulo microSD SPI (5pcs) | B07BJ2P6X6 | SPI | ~$8 |
| 22 | 1 | Cartão microSD 8GB | B073K14CVB | - | ~$8 |

### Passivos

| # | Qtd | Item | ASIN | Uso | Preço Est. |
|---|-----|------|------|-----|------------|
| 23 | 1 | Cristal 8 MHz + capacitores | B07YWLCTBS | Clock STM32 | ~$5 |

---

## RESUMO

| Categoria | Itens | Subtotal Est. |
|-----------|-------|---------------|
| Microcontroladores | 2 | ~$25 |
| Sensores Temperatura | 5 | ~$60 |
| Display/Interface | 5 | ~$89 |
| Potência | 5 | ~$52 |
| Segurança | 5 | ~$42 |
| Módulos Auxiliares | 2 | ~$18 |
| Armazenamento | 2 | ~$16 |
| Passivos | 1 | ~$5 |
| **TOTAL** | **27 linhas** | **~$307** |

---

## LINK PARA ADICIONAR TUDO AO CARRINHO

[**CLIQUE AQUI - ADICIONAR TODOS OS ITENS**](https://www.amazon.com/gp/aws/cart/add.html?ASIN.1=B08946CFLZ&Quantity.1=1&ASIN.2=B0718T232Z&Quantity.2=1&ASIN.3=B0D8KNT9MH&Quantity.3=3&ASIN.4=B0083SZC6S&Quantity.4=1&ASIN.5=B087JQ6MCP&Quantity.5=1&ASIN.6=B0BBT6F2Y7&Quantity.6=1&ASIN.7=B0CM63R39Q&Quantity.7=2&ASIN.8=B077XGF3YR&Quantity.8=1&ASIN.9=B083RXGNGQ&Quantity.9=1&ASIN.10=B00HV974KC&Quantity.10=1&ASIN.11=B07S6MT19D&Quantity.11=1&ASIN.12=B07QL766KD&Quantity.12=1&ASIN.13=B01MRR4K6Z&Quantity.13=2&ASIN.14=B0DH1MHVGY&Quantity.14=1&ASIN.15=B0769685K8&Quantity.15=1&ASIN.16=B00BP0PTYQ&Quantity.16=1&ASIN.17=B00LX5HQ6M&Quantity.17=1&ASIN.18=B00HU06NWM&Quantity.18=1&ASIN.19=B07R6X69VW&Quantity.19=1&ASIN.20=B0924TLD5L&Quantity.20=1&ASIN.21=B07BJ2P6X6&Quantity.21=1&ASIN.22=B073K14CVB&Quantity.22=1&ASIN.23=B07YWLCTBS&Quantity.23=1)

---

## LISTA DE ASINs PARA IMPORTAÇÃO DIRETA

Copie e cole no Amazon Business "Add by ASIN":

```
B08946CFLZ
B0718T232Z
B0D8KNT9MH
B0083SZC6S
B087JQ6MCP
B0BBT6F2Y7
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
B07BJ2P6X6
B073K14CVB
B07YWLCTBS
```

---

## COMPONENTES SUBSTITUÍDOS (vs lista anterior)

| Original ASIN | Problema | Novo ASIN | Produto |
|---------------|----------|-----------|---------|
| B083R5F3FF | Indisponível | **B0D8KNT9MH** | MAX31855 Breakout (2024) |
| B07117MR1P | Indisponível | **B0083SZC6S** | Termopar K até 1000°C |
| B01N5GND45 | Indisponível | **B07S6MT19D** | ACS712 20A Module |
| B07GNFDZ7L | Indisponível | **B0DH1MHVGY** | E-Stop IP67 (2024) |
| B07QQJX7T1 | Indisponível | **B00HU06NWM** | LED Piloto 220V Red |
| B07PFLHPVX | Indisponível | **B0769685K8** | Fusível 20A Panel Mount |
| B07K8GD4WS | Indisponível | **B00BP0PTYQ** | MOV 275V (10pcs) |
| B07F7TLZW6 | Indisponível | **B07BJ2P6X6** | Módulo microSD SPI |
| B07WZLQND5 | Indisponível | **B00LX5HQ6M** | Thermal Fuse 240°C |

---

## COMPATIBILIDADE ESP32/STM32

Todos os módulos são compatíveis com controle via microcontrolador:

### Interfaces Utilizadas:

| Interface | Pinos STM32F411 | Pinos ESP32 | Componentes |
|-----------|-----------------|-------------|-------------|
| **SPI** | PA5-7 (SPI1) | 18,19,23 | MAX31855, microSD |
| **UART** | PA2-3 (USART2) | 16,17 | Nextion Display |
| **I2C** | PB6-7 (I2C1) | 21,22 | TPL5010 |
| **1-Wire** | PA0 | 4 | DS18B20 |
| **ADC** | PA1,4 | 34,35,36 | ACS712, LM393 |
| **GPIO** | PB0-5 | 25-33 | Botões, LEDs, SSR |

### Arquitetura Dual-MCU:

```
┌─────────────────────────────────────────────────────────┐
│                    PCB BAIXA TENSÃO                      │
│  ┌─────────┐     ┌─────────┐     ┌──────────────┐       │
│  │ STM32   │◄───►│  ESP32  │◄───►│ Nextion 5"   │       │
│  │ F411    │SPI  │ DevKit  │UART │ Display      │       │
│  └────┬────┘     └────┬────┘     └──────────────┘       │
│       │               │                                  │
│  ┌────┴────┐     ┌────┴────┐                            │
│  │MAX31855 │     │ microSD │                            │
│  │(x3 SPI) │     │ Module  │                            │
│  └─────────┘     └─────────┘                            │
└─────────────────────────────────────────────────────────┘
         │ Optoacopladores TLP281 │
         ▼                        ▼
┌─────────────────────────────────────────────────────────┐
│                    PCB ALTA TENSÃO                       │
│  ┌─────────┐     ┌─────────┐     ┌──────────────┐       │
│  │SSR-40DA │     │Contator │     │ E-Stop       │       │
│  │(aquec.) │     │ 25A     │     │ NC           │       │
│  └─────────┘     └─────────┘     └──────────────┘       │
│       │               │                │                 │
│  ┌────┴────┐     ┌────┴────┐     ┌─────┴─────┐          │
│  │ACS712   │     │Fusível  │     │Thermal    │          │
│  │20A      │     │20A+MOV  │     │Fuse 240°C │          │
│  └─────────┘     └─────────┘     └───────────┘          │
└─────────────────────────────────────────────────────────┘
```

---

## NOTAS IMPORTANTES

1. **MAX31855 (B0D8KNT9MH):** Módulo breakout de 2024, interface SPI, leitura direta de termopar K
2. **Termopares (B0083SZC6S):** Pack de 2 unidades com isolamento cerâmico até 1000°C
3. **ACS712 (B07S6MT19D):** Módulo com 2 unidades, saída analógica 100mV/A
4. **E-Stop (B0DH1MHVGY):** IP67 waterproof, 660V 10A, com caixa de proteção
5. **Módulo microSD (B07BJ2P6X6):** Pack 5 unidades com level shifter 3.3V/5V

---

*Gerado em Dezembro 2024 - Otimizado para controle ESP32/STM32*
