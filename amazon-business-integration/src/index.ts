/**
 * Amazon Business Integration
 *
 * Este módulo fornece integração com Amazon Business para:
 * - Busca e consulta de produtos
 * - Gerenciamento de listas de compras
 * - Comparação de preços entre fornecedores
 *
 * Uso:
 * 1. Configure as variáveis de ambiente (veja .env.example)
 * 2. Execute o servidor MCP: npm run mcp
 * 3. Configure o Claude Code para usar o servidor MCP
 */

export { AmazonBusinessClient } from "./clients/amazon-business.js";
export { ShoppingListManager } from "./services/shopping-list.js";
export { PriceComparisonService } from "./services/price-comparison.js";

export type {
  Product,
  ProductDetails,
  PriceInfo,
  CartResult,
  AmazonBusinessConfig,
} from "./clients/amazon-business.js";

export type { ShoppingItem, ShoppingList } from "./services/shopping-list.js";

export type {
  PriceSource,
  ComparisonResult,
  ComparisonQuery,
} from "./services/price-comparison.js";
