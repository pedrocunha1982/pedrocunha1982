# Integração de IA Local com Home Assistant

**Data:** 2025-01-02
**Status:** Planejamento
**Objetivo:** Rodar modelos de IA localmente e integrar com Home Assistant

---

## Visão Geral da Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                        SUA REDE LOCAL                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────┐         ┌──────────────────────────────┐ │
│  │   GMKtec G9      │         │   Computador de IA           │ │
│  │   192.168.0.84   │◄───────►│   (a configurar)             │ │
│  │                  │   LAN   │                              │ │
│  │  Home Assistant  │         │  ┌────────────────────────┐  │ │
│  │  OS 13.2         │         │  │      OLLAMA            │  │ │
│  │                  │         │  │   porta 11434          │  │ │
│  │  ┌────────────┐  │         │  │                        │  │ │
│  │  │ ai_task    │  │────────►│  │  Modelos:              │  │ │
│  │  │ component  │  │  HTTP   │  │  - llama3.2            │  │ │
│  │  └────────────┘  │         │  │  - mistral             │  │ │
│  │                  │         │  │  - home-3b-v2          │  │ │
│  │  ┌────────────┐  │         │  │  - llava (visão)       │  │ │
│  │  │ Ollama     │  │         │  └────────────────────────┘  │ │
│  │  │ Integration│  │         │                              │ │
│  │  └────────────┘  │         │  ┌────────────────────────┐  │ │
│  └──────────────────┘         │  │   Open WebUI           │  │ │
│                               │  │   porta 8080           │  │ │
│                               │  │   (interface web)      │  │ │
│                               │  └────────────────────────┘  │ │
│                               └──────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────┐                                          │
│  │   Seu Mac        │◄────── Acesso via browser/Claude Code    │
│  │   (este aqui)    │                                          │
│  └──────────────────┘                                          │
└─────────────────────────────────────────────────────────────────┘
```

---

## Parte 1: Configurar Ollama no Computador de IA

### 1.1 Instalar Ollama

```bash
# Linux (Ubuntu/Debian)
curl -fsSL https://ollama.com/install.sh | sh

# Ou via Docker
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

### 1.2 Configurar Acesso de Rede

Por padrão, Ollama só aceita conexões locais. Para acessar da rede:

```bash
# Editar serviço do systemd
sudo systemctl edit ollama.service
```

Adicionar:
```ini
[Service]
Environment="OLLAMA_HOST=0.0.0.0"
```

Reiniciar:
```bash
sudo systemctl daemon-reload
sudo systemctl restart ollama
```

### 1.3 Baixar Modelos Recomendados

```bash
# Modelo otimizado para Home Assistant (recomendado!)
ollama pull fixt/home-3b-v2

# Modelos gerais
ollama pull llama3.2          # 3B, leve e rápido
ollama pull mistral           # 7B, bom equilíbrio
ollama pull llama3.1:8b       # 8B, mais capaz

# Para análise de imagens (câmeras)
ollama pull llava             # Multimodal - vê imagens!
ollama pull llava:13b         # Versão maior, mais precisa
```

### 1.4 Testar Ollama

```bash
# Testar localmente
curl http://localhost:11434/api/generate -d '{
  "model": "fixt/home-3b-v2",
  "prompt": "Turn on the living room lights",
  "stream": false
}'

# Testar da rede (substitua IP)
curl http://192.168.0.XX:11434/api/tags
```

---

## Parte 2: Configurar Home Assistant

### 2.1 Adicionar Integração Ollama

1. Acesse: **Settings → Devices & Services → Add Integration**
2. Busque: **Ollama**
3. Configure:
   - **URL:** `http://192.168.0.XX:11434` (IP do computador de IA)
   - **Model:** `fixt/home-3b-v2` (ou outro)
4. Clique **Submit**

### 2.2 Configurar AI Task (novo!)

1. Acesse: **Settings → System → General**
2. Role até **AI Task preferences**
3. Selecione a entidade Ollama como padrão

### 2.3 Expor Entidades para a IA

1. Acesse: **Settings → Voice Assistants → Expose tab**
2. Clique **+ Expose Entities**
3. Selecione entidades que a IA pode controlar

> ⚠️ **Recomendação:** Comece com menos de 25 entidades para melhor desempenho

### 2.4 Opções Avançadas de Configuração

| Opção | Valor Recomendado | Descrição |
|-------|-------------------|-----------|
| Context Window | 8192 | Tokens de contexto |
| Max History | 10 | Mensagens no histórico |
| Keep Alive | 300 | Segundos para manter modelo na memória |
| Control HA | Assist | Permite controlar entidades |

---

## Parte 3: Usar AI Tasks em Automações

### 3.1 Serviço: generate_data

Gera dados estruturados a partir de texto:

```yaml
service: ai_task.generate_data
data:
  task_name: "Análise de Clima"
  instructions: |
    Analise o estado atual do clima e gere um resumo.
    Temperatura: {{ states('sensor.temperatura') }}°C
    Umidade: {{ states('sensor.umidade') }}%
  structure:
    type: object
    properties:
      resumo:
        type: string
      recomendacao:
        type: string
      conforto:
        type: integer
        minimum: 1
        maximum: 10
```

### 3.2 Serviço: generate_image

Gera imagens (requer modelo com suporte):

```yaml
service: ai_task.generate_image
data:
  task_name: "Visualização do Clima"
  instructions: "Crie uma imagem representando um dia ensolarado com 28°C"
  entity_id: ai_task.stable_diffusion  # se configurado
```

### 3.3 Exemplo: Notificação Inteligente

```yaml
automation:
  - alias: "Notificação Inteligente - Forno de Cerâmica"
    trigger:
      - platform: numeric_state
        entity_id: sensor.forno_temperatura
        above: 800
    action:
      - service: ai_task.generate_data
        data:
          task_name: "Gerar Mensagem Forno"
          instructions: |
            O forno de cerâmica atingiu {{ states('sensor.forno_temperatura') }}°C.
            Gere uma mensagem curta e informativa para notificar o usuário.
        response_variable: ai_response
      - service: notify.mobile_app
        data:
          message: "{{ ai_response.data.message }}"
```

### 3.4 Exemplo: Análise de Câmera

```yaml
automation:
  - alias: "Contar Pessoas na Sala"
    trigger:
      - platform: time_pattern
        hours: "/1"  # A cada hora
    action:
      - service: ai_task.generate_data
        data:
          task_name: "Contagem de Pessoas"
          instructions: "Conte quantas pessoas estão visíveis na imagem"
          attachments:
            - media_content_id: media-source://camera/camera.sala
              media_content_type: image/jpeg
          structure:
            type: object
            properties:
              pessoas:
                type: integer
              descricao:
                type: string
        response_variable: contagem
      - service: input_number.set_value
        target:
          entity_id: input_number.pessoas_em_casa
        data:
          value: "{{ contagem.data.pessoas }}"
```

---

## Parte 4: Modelos Recomendados

### Para Controle do Home Assistant

| Modelo | Tamanho | Uso | Notas |
|--------|---------|-----|-------|
| `fixt/home-3b-v2` | 3B | Controle de casa | **Otimizado para HA!** |
| `llama3.2` | 3B | Geral | Rápido, bom para início |
| `mistral` | 7B | Geral | Bom equilíbrio |

### Para Análise de Imagens

| Modelo | Tamanho | Uso |
|--------|---------|-----|
| `llava` | 7B | Análise visual básica |
| `llava:13b` | 13B | Análise visual avançada |
| `bakllava` | 7B | Alternativa ao llava |

### Requisitos de Hardware

| Modelo | RAM Mínima | GPU VRAM | Notas |
|--------|------------|----------|-------|
| 3B | 4GB | 4GB | CPU ok |
| 7B | 8GB | 8GB | GPU recomendada |
| 13B | 16GB | 16GB | GPU necessária |
| 70B | 64GB | 48GB+ | Servidor dedicado |

---

## Parte 5: Open WebUI (Interface Bonita)

Para ter uma interface de chat similar ao ChatGPT:

```bash
# Docker
docker run -d -p 8080:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main

# Acessar: http://192.168.0.XX:8080
```

---

## Parte 6: Aprendizado e Experimentação

### 6.1 Primeiros Passos para Aprender

1. **Semana 1:** Instalar Ollama, testar comandos básicos
2. **Semana 2:** Integrar com Home Assistant, criar primeira automação
3. **Semana 3:** Experimentar diferentes modelos, comparar resultados
4. **Semana 4:** Criar automações mais complexas com ai_task

### 6.2 Comandos Úteis do Ollama

```bash
# Listar modelos instalados
ollama list

# Informações de um modelo
ollama show llama3.2

# Rodar modelo interativamente
ollama run llama3.2

# Remover modelo
ollama rm modelo_antigo

# Ver logs
journalctl -u ollama -f
```

### 6.3 Dicas para Treino

1. **Comece pequeno:** Use modelos 3B primeiro
2. **Teste prompts:** Refine as instruções até funcionar bem
3. **Monitore uso:** Acompanhe CPU/RAM/GPU
4. **Documente:** Anote o que funciona e o que não funciona

---

## Checklist de Implementação

### Computador de IA
- [ ] Instalar Linux/Windows
- [ ] Instalar Ollama
- [ ] Configurar acesso de rede (0.0.0.0)
- [ ] Baixar modelo fixt/home-3b-v2
- [ ] Testar com curl
- [ ] (Opcional) Instalar Open WebUI

### Home Assistant
- [ ] Adicionar integração Ollama
- [ ] Configurar URL do servidor
- [ ] Definir AI Task padrão
- [ ] Expor entidades
- [ ] Criar primeira automação de teste

### Validação
- [ ] Testar controle de luz via IA
- [ ] Testar geração de dados
- [ ] Testar análise de câmera (se tiver llava)
- [ ] Monitorar performance

---

## Referências

- [Home Assistant - Integração Ollama](https://www.home-assistant.io/integrations/ollama/)
- [Home Assistant - AI Tasks](https://www.home-assistant.io/integrations/ai_task)
- [Ollama Download](https://ollama.com/download)
- [Modelo home-3b-v2](https://ollama.com/fixt/home-3b-v2)
- [Home-LLM Project](https://github.com/acon96/home-llm)
- [StratoBuilds - Guia Local LLM](https://stratobuilds.com/project/local-llm-ollama-home-assistant/)
- [Peyanski - Local AI Guide](https://peyanski.com/local-ai-with-home-assistant-and-ollama/)
- [Blog HA - AI in Home Assistant](https://www.home-assistant.io/blog/2025/09/11/ai-in-home-assistant)
- [Release 2025.8 - Summer of AI](https://www.home-assistant.io/blog/2025/08/06/release-20258)

---

*Documento criado para o projeto AI Server de Pedro Cunha*
