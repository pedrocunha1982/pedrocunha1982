import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { AmazonBusinessClient } from "./clients/amazon-business.js";
import { ShoppingListManager } from "./services/shopping-list.js";
import { PriceComparisonService } from "./services/price-comparison.js";
import dotenv from "dotenv";

dotenv.config();

const server = new Server(
  {
    name: "amazon-business-integration",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Inicializar serviços
const amazonClient = new AmazonBusinessClient({
  clientId: process.env.AMAZON_CLIENT_ID!,
  clientSecret: process.env.AMAZON_CLIENT_SECRET!,
  refreshToken: process.env.AMAZON_REFRESH_TOKEN!,
  marketplaceId: process.env.AMAZON_MARKETPLACE_ID!,
  region: process.env.AMAZON_REGION || "na-east-1",
});

const shoppingList = new ShoppingListManager();
const priceComparison = new PriceComparisonService([amazonClient]);

// Definir ferramentas disponíveis
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "amazon_search_products",
        description: "Buscar produtos no Amazon Business por palavra-chave ou ASIN",
        inputSchema: {
          type: "object",
          properties: {
            query: {
              type: "string",
              description: "Termo de busca ou ASIN do produto",
            },
            category: {
              type: "string",
              description: "Categoria opcional para filtrar resultados",
            },
            maxResults: {
              type: "number",
              description: "Número máximo de resultados (padrão: 10)",
            },
          },
          required: ["query"],
        },
      },
      {
        name: "amazon_get_product_details",
        description: "Obter detalhes completos de um produto pelo ASIN",
        inputSchema: {
          type: "object",
          properties: {
            asin: {
              type: "string",
              description: "ASIN do produto Amazon",
            },
          },
          required: ["asin"],
        },
      },
      {
        name: "amazon_get_price",
        description: "Obter preço atual de um produto",
        inputSchema: {
          type: "object",
          properties: {
            asin: {
              type: "string",
              description: "ASIN do produto",
            },
            includeBusinessPrice: {
              type: "boolean",
              description: "Incluir preços especiais para Business (padrão: true)",
            },
          },
          required: ["asin"],
        },
      },
      {
        name: "shopping_list_add",
        description: "Adicionar item à lista de compras",
        inputSchema: {
          type: "object",
          properties: {
            name: {
              type: "string",
              description: "Nome do produto",
            },
            asin: {
              type: "string",
              description: "ASIN do produto Amazon (opcional)",
            },
            quantity: {
              type: "number",
              description: "Quantidade desejada",
            },
            notes: {
              type: "string",
              description: "Notas adicionais",
            },
            listName: {
              type: "string",
              description: "Nome da lista (padrão: 'default')",
            },
          },
          required: ["name", "quantity"],
        },
      },
      {
        name: "shopping_list_view",
        description: "Visualizar lista de compras",
        inputSchema: {
          type: "object",
          properties: {
            listName: {
              type: "string",
              description: "Nome da lista (padrão: 'default')",
            },
          },
        },
      },
      {
        name: "shopping_list_remove",
        description: "Remover item da lista de compras",
        inputSchema: {
          type: "object",
          properties: {
            itemId: {
              type: "string",
              description: "ID do item a remover",
            },
            listName: {
              type: "string",
              description: "Nome da lista (padrão: 'default')",
            },
          },
          required: ["itemId"],
        },
      },
      {
        name: "shopping_list_clear",
        description: "Limpar lista de compras",
        inputSchema: {
          type: "object",
          properties: {
            listName: {
              type: "string",
              description: "Nome da lista (padrão: 'default')",
            },
          },
        },
      },
      {
        name: "compare_prices",
        description: "Comparar preços de um produto entre diferentes fornecedores",
        inputSchema: {
          type: "object",
          properties: {
            productName: {
              type: "string",
              description: "Nome ou descrição do produto",
            },
            asin: {
              type: "string",
              description: "ASIN Amazon (opcional)",
            },
            partNumber: {
              type: "string",
              description: "Part number do fabricante (opcional)",
            },
          },
          required: ["productName"],
        },
      },
      {
        name: "amazon_add_to_cart",
        description: "Adicionar produto ao carrinho do Amazon Business",
        inputSchema: {
          type: "object",
          properties: {
            asin: {
              type: "string",
              description: "ASIN do produto",
            },
            quantity: {
              type: "number",
              description: "Quantidade",
            },
          },
          required: ["asin", "quantity"],
        },
      },
    ],
  };
});

// Handler para executar ferramentas
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case "amazon_search_products": {
        const results = await amazonClient.searchProducts(
          args.query as string,
          args.category as string | undefined,
          (args.maxResults as number) || 10
        );
        return {
          content: [{ type: "text", text: JSON.stringify(results, null, 2) }],
        };
      }

      case "amazon_get_product_details": {
        const details = await amazonClient.getProductDetails(args.asin as string);
        return {
          content: [{ type: "text", text: JSON.stringify(details, null, 2) }],
        };
      }

      case "amazon_get_price": {
        const price = await amazonClient.getPrice(
          args.asin as string,
          (args.includeBusinessPrice as boolean) ?? true
        );
        return {
          content: [{ type: "text", text: JSON.stringify(price, null, 2) }],
        };
      }

      case "shopping_list_add": {
        const item = shoppingList.addItem(
          (args.listName as string) || "default",
          {
            name: args.name as string,
            asin: args.asin as string | undefined,
            quantity: args.quantity as number,
            notes: args.notes as string | undefined,
          }
        );
        return {
          content: [
            { type: "text", text: `Item adicionado: ${JSON.stringify(item, null, 2)}` },
          ],
        };
      }

      case "shopping_list_view": {
        const list = shoppingList.getList((args.listName as string) || "default");
        return {
          content: [{ type: "text", text: JSON.stringify(list, null, 2) }],
        };
      }

      case "shopping_list_remove": {
        const removed = shoppingList.removeItem(
          (args.listName as string) || "default",
          args.itemId as string
        );
        return {
          content: [
            {
              type: "text",
              text: removed ? "Item removido com sucesso" : "Item não encontrado",
            },
          ],
        };
      }

      case "shopping_list_clear": {
        shoppingList.clearList((args.listName as string) || "default");
        return {
          content: [{ type: "text", text: "Lista limpa com sucesso" }],
        };
      }

      case "compare_prices": {
        const comparison = await priceComparison.compare({
          productName: args.productName as string,
          asin: args.asin as string | undefined,
          partNumber: args.partNumber as string | undefined,
        });
        return {
          content: [{ type: "text", text: JSON.stringify(comparison, null, 2) }],
        };
      }

      case "amazon_add_to_cart": {
        const result = await amazonClient.addToCart(
          args.asin as string,
          args.quantity as number
        );
        return {
          content: [{ type: "text", text: JSON.stringify(result, null, 2) }],
        };
      }

      default:
        return {
          content: [{ type: "text", text: `Ferramenta desconhecida: ${name}` }],
          isError: true,
        };
    }
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    return {
      content: [{ type: "text", text: `Erro: ${errorMessage}` }],
      isError: true,
    };
  }
});

// Iniciar servidor
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("MCP Server Amazon Business iniciado");
}

main().catch(console.error);
