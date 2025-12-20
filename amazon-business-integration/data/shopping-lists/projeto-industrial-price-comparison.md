# Comparativo de Precos - Projeto Industrial ESP32/STM32

**Data:** 2024-12-20
**Mercado:** EUA
**Moeda:** USD

## Resumo Executivo

| Fornecedor | Melhor Para | Observacoes |
|------------|-------------|-------------|
| **LCSC** | Componentes SMD, MCUs | Melhor preco, frete da China |
| **DigiKey** | Estoque, velocidade | Preco medio, entrega rapida |
| **Mouser** | Alternativa DigiKey | Precos similares |
| **Adafruit/SparkFun** | Breakout boards, makers | Mais caro, mas pronto pra usar |
| **Amazon** | Modulos prontos, SSR | Precos variaveis |
| **Amazon Business** | Bulk pricing, tax exempt | Descontos em quantidade |

---

## Amazon Business - Vantagens para Compras Industriais

### O que e Amazon Business?
Amazon Business oferece precos especiais para empresas, com:
- **Descontos por quantidade** (5-15% em compras bulk)
- **Tax exemption** (isencao de impostos para empresas)
- **Business Prime** - frete gratis em 1-2 dias
- **Purchasing approval workflows**
- **Integracao com sistemas de procurement**

### Componentes Disponiveis no Amazon Business

| Componente | Preco Regular | Preco Business* | Economia |
|------------|--------------|-----------------|----------|
| MAX31855 Breakout | ~$12 | ~$10 | ~17% |
| SSR-40DA | ~$12 | ~$9 | ~25% |
| ESP32 DevKit | ~$12 | ~$10 | ~17% |
| Termopar Tipo K (pack 5) | ~$25 | ~$20 | ~20% |
| DS18B20 Waterproof | ~$5 | ~$4 | ~20% |

*Precos estimados com Business discount + quantity pricing

### Como Acessar Amazon Business
1. Acesse [business.amazon.com](https://business.amazon.com)
2. Crie conta com email empresarial
3. Verifique sua empresa (EIN/Tax ID)
4. Acesse precos Business-only

### Produtos Recomendados Amazon Business (Industrial & Scientific)

**MAX31855 Thermocouple Modules:**
- HiLetgo MAX31855 K-Type Module (~$8-10)
- HUABAN MAX31855 Breakout Board (~$10-12)
- Octo K-Type 8-channel MAX31855 (~$45) - para expansao futura

**ESP32 Development Boards:**
- ESP32-DevKitC oficial (~$10)
- HiLetgo ESP32 (~$8)
- ESP32-WROOM-32D (~$7)

**Solid State Relays:**
- Inkbird SSR-40DA para PID (~$10)
- SSR-40DA com heatsink (~$12)

---

## Comparativo Detalhado por Componente

### 1. Microcontroladores

| Componente | DigiKey | Mouser | LCSC | Adafruit | Recomendado |
|------------|---------|--------|------|----------|-------------|
| **STM32F411CEU6** (chip) | $6.10 | ~$6.00 | **$1.41** | - | LCSC |
| **STM32F411 BlackPill** (board) | $16.50 | - | ~$5.00 | - | LCSC/AliExpress |
| **ESP32-DevKitC-32E** | $10.00 | $10.00 | - | $15.00 | DigiKey |
| **ESP32-WROOM-32-N4** (modulo) | - | - | **$2.74** | - | LCSC |

**Economia STM32:** ~$4.70/unidade comprando na LCSC vs DigiKey

---

### 2. Sensores de Temperatura

| Componente | DigiKey | SparkFun | Adafruit | Amazon | Recomendado |
|------------|---------|----------|----------|--------|-------------|
| **MAX31855KASA+T** (chip) | **$9.34** | - | - | ~$8 | DigiKey |
| **MAX31855 Breakout** | - | ~$16 | **$14.95** | ~$12 | Adafruit |
| **Termopar Tipo K** | ~$15 | ~$10 | ~$10 | **~$5** | Amazon |
| **DS18B20** (chip) | $6.59* | - | - | ~$2 | Amazon |
| **DS18B20 Waterproof** | - | ~$6 | ~$10 | **~$3** | Amazon |

*Nota: DS18B20 esta obsoleto na DigiKey

**Recomendacao:** Para 3x MAX31855 + termopares, comprar breakouts Adafruit ($14.95 x 3 = $44.85) para facilitar montagem.

---

### 3. Componentes de Potencia

| Componente | DigiKey | Amazon | AliExpress | Recomendado |
|------------|---------|--------|------------|-------------|
| **SSR-40DA** (40A) | ~$15 | **~$8-12** | ~$3 | Amazon |
| **Contator 25A 230V** | ~$25 | ~$20 | ~$10 | DigiKey (qualidade) |
| **ACS712 20A** (chip) | $3.79* | - | ~$0.50 | - |
| **ACS712 20A** (modulo) | - | **~$5** | ~$1.50 | Amazon |

*Nota: ACS712 em backorder na DigiKey

---

### 4. Optoacopladores e ICs

| Componente | DigiKey | Mouser | LCSC | Recomendado |
|------------|---------|--------|------|-------------|
| **TLP281-4** | ~$1.50 | ~$1.50 | **~$0.30** | LCSC |
| **LM393** | ~$0.50 | ~$0.50 | **~$0.10** | LCSC |
| **TPL5010** (watchdog) | ~$2.00 | ~$2.00 | - | DigiKey |

---

### 5. Interface (Display, LEDs, Buzzer)

| Componente | DigiKey | Amazon | AliExpress | ITEAD | Recomendado |
|------------|---------|--------|------------|-------|-------------|
| **Nextion 5" NX8048T050** | - | ~$55 | ~$40 | **~$45** | ITEAD (oficial) |
| **LED RGB 5mm** | ~$0.30 | - | ~$0.05 | - | LCSC |
| **Buzzer Piezo 95dB** | ~$2.00 | - | ~$0.50 | - | DigiKey |
| **LED Piloto 220V** | ~$5.00 | ~$3 | ~$1 | - | Amazon |

**Nota:** Display Nextion NX8048T050 esta sendo descontinuado. Considere NX8048P050_011R.

---

### 6. Protecao e Seguranca

| Componente | DigiKey | Amazon | Recomendado |
|------------|---------|--------|-------------|
| **E-Stop NC** | ~$15 | **~$8** | Amazon |
| **MOV 275V** | ~$1.00 | - | DigiKey |
| **Fusivel 20A + Suporte** | ~$3.00 | ~$5 | DigiKey |
| **Sensor sobretemp.** | ~$5.00 | - | DigiKey |

---

### 7. Conectores e Passivos

| Componente | DigiKey | LCSC | Recomendado |
|------------|---------|------|-------------|
| **Cristal 8MHz + caps** | ~$1.50 | **~$0.30** | LCSC |
| **Botao tactil IP65** (x6) | ~$2.50/un | ~$1.00/un | DigiKey (IP65 real) |
| **Soquete microSD** | ~$1.50 | **~$0.20** | LCSC |
| **Cartao microSD 8GB** | - | - | Amazon ~$5 |

---

## Estrategia de Compra Recomendada

### Pedido 1: DigiKey (Entrega Rapida - 2-3 dias)
Componentes criticos e de qualidade garantida:

| Item | Qtd | Preco Unit. | Total |
|------|-----|-------------|-------|
| ESP32-DevKitC-32E | 1 | $10.00 | $10.00 |
| MAX31855KASA+T | 3 | $9.34 | $28.02 |
| TPL5010 | 1 | $2.00 | $2.00 |
| MOV 275V | 1 | $1.00 | $1.00 |
| Fusivel + suporte | 1 | $3.00 | $3.00 |
| Buzzer 95dB | 1 | $2.00 | $2.00 |
| Botao IP65 | 6 | $2.50 | $15.00 |
| **Subtotal** | | | **$61.02** |
| Frete (estimado) | | | ~$8.00 |
| **Total DigiKey** | | | **~$69.00** |

### Pedido 2: LCSC (Economia - 7-15 dias)
Componentes genericos e SMD:

| Item | Qtd | Preco Unit. | Total |
|------|-----|-------------|-------|
| STM32F411CEU6 | 1 | $1.41 | $1.41 |
| TLP281-4 | 4 | $0.30 | $1.20 |
| LM393 | 1 | $0.10 | $0.10 |
| LED RGB | 1 | $0.10 | $0.10 |
| Cristal 8MHz + caps | 1 | $0.30 | $0.30 |
| Soquete microSD | 1 | $0.20 | $0.20 |
| **Subtotal** | | | **$3.31** |
| Frete (estimado) | | | ~$15.00 |
| **Total LCSC** | | | **~$18.00** |

### Pedido 3: Amazon (Conveniencia - 1-2 dias Prime)
Modulos prontos e acessorios:

| Item | Qtd | Preco Unit. | Total |
|------|-----|-------------|-------|
| SSR-40DA + heatsink | 1 | $10.00 | $10.00 |
| DS18B20 waterproof | 1 | $3.00 | $3.00 |
| ACS712 20A modulo | 1 | $5.00 | $5.00 |
| E-Stop NC | 1 | $8.00 | $8.00 |
| LED Piloto 220V | 1 | $3.00 | $3.00 |
| microSD 8GB industrial | 1 | $8.00 | $8.00 |
| Termopar Tipo K (x3) | 3 | $5.00 | $15.00 |
| **Subtotal** | | | **$52.00** |
| Frete Prime | | | FREE |
| **Total Amazon** | | | **~$52.00** |

### Pedido 4: ITEAD/Nextion (Display - 5-10 dias)

| Item | Qtd | Preco Unit. | Total |
|------|-----|-------------|-------|
| Nextion 5" | 1 | $45.00 | $45.00 |
| Frete | | | ~$10.00 |
| **Total ITEAD** | | | **~$55.00** |

---

## Resumo Final

| Fornecedor | Total | Tempo Entrega |
|------------|-------|---------------|
| DigiKey | ~$69 | 2-3 dias |
| LCSC | ~$18 | 7-15 dias |
| Amazon | ~$52 | 1-2 dias |
| ITEAD | ~$55 | 5-10 dias |
| **TOTAL PROJETO** | **~$194** | |

### Alternativa: Tudo na DigiKey
Se precisar de tudo rapido: ~$280-320 (mais caro, mas entrega em 2-3 dias)

### Alternativa: Tudo na China (LCSC + AliExpress)
Maximo de economia: ~$100-120 (mais barato, mas 2-4 semanas de espera)

---

## Links Uteis

- [Amazon Business](https://business.amazon.com) - Precos empresariais
- [DigiKey](https://www.digikey.com)
- [Mouser](https://www.mouser.com)
- [LCSC](https://www.lcsc.com) - Componentes da China
- [Adafruit](https://www.adafruit.com) - Breakout boards
- [SparkFun](https://www.sparkfun.com) - Breakout boards
- [ITEAD/Nextion](https://itead.cc) - Displays HMI
- [Octopart](https://octopart.com) - Comparador de precos
- [Findchips](https://www.findchips.com) - Verificar estoque

---

*Precos consultados em Dezembro 2024. Valores podem variar.*
