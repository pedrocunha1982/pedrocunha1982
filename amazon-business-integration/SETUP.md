# Guia de Configuração - Amazon Business Integration

## Pré-requisitos

- Node.js 18+ instalado
- Conta Amazon Business ativa
- Acesso ao Amazon Developer Portal

## Passo 1: Obter Credenciais Amazon SP-API

### 1.1 Registrar como Desenvolvedor

1. Acesse [Amazon Seller Central](https://sellercentral.amazon.com.br/)
2. Vá em **Configurações** > **Permissões do usuário**
3. Em **Acesso de desenvolvedor**, clique em **Registrar**

### 1.2 Criar Aplicativo

1. Acesse [Amazon Developer Console](https://developer.amazonservices.com/)
2. Clique em **Add new app client**
3. Configure:
   - **App name**: Amazon Business Integration
   - **API Type**: SP API
   - **IAM ARN**: Crie uma role IAM na AWS (veja 1.3)

### 1.3 Configurar IAM Role (AWS)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "execute-api:Invoke",
      "Resource": "arn:aws:execute-api:*:*:*"
    }
  ]
}
```

### 1.4 Obter Refresh Token

1. Após criar o app, você receberá:
   - **LWA Client ID**
   - **LWA Client Secret**

2. Faça a autorização OAuth:
```
https://sellercentral.amazon.com.br/apps/authorize/consent?application_id=YOUR_APP_ID
```

3. Após autorizar, você receberá um código. Troque por refresh token:
```bash
curl -X POST https://api.amazon.com/auth/o2/token \
  -d "grant_type=authorization_code" \
  -d "code=YOUR_AUTH_CODE" \
  -d "client_id=YOUR_CLIENT_ID" \
  -d "client_secret=YOUR_CLIENT_SECRET"
```

## Passo 2: Configurar o Projeto

### 2.1 Instalar Dependências

```bash
cd amazon-business-integration
npm install
```

### 2.2 Configurar Variáveis de Ambiente

```bash
cp .env.example .env
```

Edite o arquivo `.env`:

```env
AMAZON_CLIENT_ID=amzn1.application-oa2-client.xxxxx
AMAZON_CLIENT_SECRET=xxxxx
AMAZON_REFRESH_TOKEN=Atzr|xxxxx
AMAZON_MARKETPLACE_ID=A2Q3Y263D00KWC
AMAZON_REGION=na-east-1
```

**Marketplace IDs:**
- Brasil: `A2Q3Y263D00KWC`
- EUA: `ATVPDKIKX0DER`
- México: `A1AM78C64UM0Y8`

### 2.3 Testar a Instalação

```bash
npm run build
npm run dev
```

## Passo 3: Integrar com Claude Code

### 3.1 Configurar MCP Server

Adicione ao seu arquivo de configuração do Claude Code (`~/.claude/config.json` ou similar):

```json
{
  "mcpServers": {
    "amazon-business": {
      "command": "node",
      "args": ["/caminho/para/amazon-business-integration/dist/mcp-server.js"],
      "env": {
        "AMAZON_CLIENT_ID": "seu_client_id",
        "AMAZON_CLIENT_SECRET": "seu_client_secret",
        "AMAZON_REFRESH_TOKEN": "seu_refresh_token",
        "AMAZON_MARKETPLACE_ID": "A2Q3Y263D00KWC"
      }
    }
  }
}
```

### 3.2 Alternativa: Usar tsx (desenvolvimento)

```json
{
  "mcpServers": {
    "amazon-business": {
      "command": "npx",
      "args": ["tsx", "/caminho/para/amazon-business-integration/src/mcp-server.ts"]
    }
  }
}
```

## Passo 4: Usar a Integração

Após configurar, você pode usar comandos como:

- **Buscar produtos**: "Busque resistores 10k ohm no Amazon Business"
- **Ver preços**: "Qual o preço do ASIN B08XYZ123?"
- **Criar lista**: "Adicione 100 capacitores 100uF à lista de compras"
- **Comparar preços**: "Compare preços deste componente"

## Ferramentas Disponíveis

| Ferramenta | Descrição |
|------------|-----------|
| `amazon_search_products` | Buscar produtos por termo |
| `amazon_get_product_details` | Detalhes de um produto (ASIN) |
| `amazon_get_price` | Preço atual com desconto Business |
| `shopping_list_add` | Adicionar à lista de compras |
| `shopping_list_view` | Ver lista de compras |
| `shopping_list_remove` | Remover item da lista |
| `shopping_list_clear` | Limpar lista |
| `compare_prices` | Comparar preços entre fornecedores |
| `amazon_add_to_cart` | Link para adicionar ao carrinho |

## Solução de Problemas

### Erro de autenticação
- Verifique se o refresh token ainda é válido
- Tokens expiram após período inativo longo
- Regenere o token seguindo o Passo 1.4

### Erro de permissão
- Verifique se seu app tem as permissões corretas
- No Amazon Developer Console, revise os escopos OAuth

### Timeout nas requisições
- Aumente o timeout no cliente
- Verifique sua conexão de internet
- A API pode estar instável temporariamente

## Próximas Integrações (Roadmap)

- [ ] DigiKey API
- [ ] Mouser Electronics API
- [ ] Alibaba/AliExpress
- [ ] LCSC Electronics
- [ ] Newark/Farnell

## Suporte

Para dúvidas sobre a SP-API:
- [Documentação SP-API](https://developer-docs.amazon.com/sp-api/)
- [Fórum de Desenvolvedores](https://sellercentral.amazon.com.br/forums/)
