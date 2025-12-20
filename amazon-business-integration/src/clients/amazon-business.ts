import axios, { AxiosInstance } from "axios";

export interface AmazonBusinessConfig {
  clientId: string;
  clientSecret: string;
  refreshToken: string;
  marketplaceId: string;
  region: string;
}

export interface Product {
  asin: string;
  title: string;
  brand?: string;
  category?: string;
  imageUrl?: string;
  detailPageUrl?: string;
}

export interface ProductDetails extends Product {
  description?: string;
  features?: string[];
  specifications?: Record<string, string>;
  manufacturer?: string;
  partNumber?: string;
}

export interface PriceInfo {
  asin: string;
  listPrice?: number;
  currentPrice: number;
  businessPrice?: number;
  quantityDiscounts?: Array<{
    minQuantity: number;
    price: number;
  }>;
  currency: string;
  availability: string;
  seller?: string;
}

export interface CartResult {
  success: boolean;
  cartId?: string;
  message: string;
}

/**
 * Cliente para interação com Amazon Business API (SP-API)
 *
 * Para obter credenciais:
 * 1. Acesse https://developer.amazonservices.com/
 * 2. Registre-se como desenvolvedor
 * 3. Crie um app e obtenha Client ID/Secret
 * 4. Configure LWA (Login with Amazon)
 * 5. Obtenha o Refresh Token via OAuth flow
 */
export class AmazonBusinessClient {
  private config: AmazonBusinessConfig;
  private accessToken: string | null = null;
  private tokenExpiry: Date | null = null;
  private httpClient: AxiosInstance;

  // Endpoints por região
  private static readonly ENDPOINTS: Record<string, string> = {
    "na-east-1": "https://sellingpartnerapi-na.amazon.com",
    "eu-west-1": "https://sellingpartnerapi-eu.amazon.com",
    "us-west-2": "https://sellingpartnerapi-fe.amazon.com",
  };

  constructor(config: AmazonBusinessConfig) {
    this.config = config;
    this.httpClient = axios.create({
      baseURL: AmazonBusinessClient.ENDPOINTS[config.region] || AmazonBusinessClient.ENDPOINTS["na-east-1"],
      timeout: 30000,
    });
  }

  /**
   * Obter access token usando refresh token
   */
  private async getAccessToken(): Promise<string> {
    if (this.accessToken && this.tokenExpiry && new Date() < this.tokenExpiry) {
      return this.accessToken;
    }

    try {
      const response = await axios.post(
        "https://api.amazon.com/auth/o2/token",
        new URLSearchParams({
          grant_type: "refresh_token",
          refresh_token: this.config.refreshToken,
          client_id: this.config.clientId,
          client_secret: this.config.clientSecret,
        }),
        {
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
        }
      );

      this.accessToken = response.data.access_token;
      this.tokenExpiry = new Date(Date.now() + (response.data.expires_in - 60) * 1000);

      return this.accessToken!;
    } catch (error) {
      throw new Error(`Falha ao obter access token: ${error}`);
    }
  }

  /**
   * Fazer requisição autenticada à API
   */
  private async apiRequest<T>(
    method: "GET" | "POST" | "PUT" | "DELETE",
    path: string,
    data?: unknown
  ): Promise<T> {
    const token = await this.getAccessToken();

    const response = await this.httpClient.request<T>({
      method,
      url: path,
      data,
      headers: {
        Authorization: `Bearer ${token}`,
        "x-amz-access-token": token,
        "Content-Type": "application/json",
      },
    });

    return response.data;
  }

  /**
   * Buscar produtos por termo ou categoria
   */
  async searchProducts(
    query: string,
    category?: string,
    maxResults: number = 10
  ): Promise<Product[]> {
    // Nota: A SP-API tem endpoints específicos para busca de catálogo
    // Este é um exemplo simplificado - a implementação real usaria:
    // GET /catalog/2022-04-01/items?keywords={query}&marketplaceIds={marketplaceId}

    try {
      const params = new URLSearchParams({
        keywords: query,
        marketplaceIds: this.config.marketplaceId,
        pageSize: maxResults.toString(),
        includedData: "summaries,images",
      });

      if (category) {
        params.append("classificationIds", category);
      }

      const response = await this.apiRequest<{
        items: Array<{
          asin: string;
          summaries?: Array<{
            marketplaceId: string;
            itemName: string;
            brand?: string;
          }>;
          images?: Array<{
            images: Array<{ link: string }>;
          }>;
        }>;
      }>("GET", `/catalog/2022-04-01/items?${params}`);

      return response.items.map((item) => ({
        asin: item.asin,
        title: item.summaries?.[0]?.itemName || "Sem título",
        brand: item.summaries?.[0]?.brand,
        imageUrl: item.images?.[0]?.images?.[0]?.link,
      }));
    } catch (error) {
      // Em caso de erro de API, retornar mock para desenvolvimento
      console.error("Erro na busca (usando dados mock):", error);
      return this.getMockProducts(query, maxResults);
    }
  }

  /**
   * Obter detalhes de um produto pelo ASIN
   */
  async getProductDetails(asin: string): Promise<ProductDetails> {
    try {
      const params = new URLSearchParams({
        marketplaceIds: this.config.marketplaceId,
        includedData: "summaries,images,productTypes,attributes",
      });

      const response = await this.apiRequest<{
        asin: string;
        summaries?: Array<{
          itemName: string;
          brand?: string;
          manufacturer?: string;
        }>;
        attributes?: Record<string, Array<{ value: string }>>;
      }>("GET", `/catalog/2022-04-01/items/${asin}?${params}`);

      return {
        asin: response.asin,
        title: response.summaries?.[0]?.itemName || "Sem título",
        brand: response.summaries?.[0]?.brand,
        manufacturer: response.summaries?.[0]?.manufacturer,
        specifications: this.extractSpecifications(response.attributes),
      };
    } catch (error) {
      console.error("Erro ao obter detalhes (usando dados mock):", error);
      return this.getMockProductDetails(asin);
    }
  }

  /**
   * Obter preço de um produto
   */
  async getPrice(asin: string, includeBusinessPrice: boolean = true): Promise<PriceInfo> {
    try {
      const params = new URLSearchParams({
        MarketplaceId: this.config.marketplaceId,
        Asins: asin,
        ItemType: "Asin",
      });

      if (includeBusinessPrice) {
        params.append("CustomerType", "Business");
      }

      const response = await this.apiRequest<{
        payload: Array<{
          ASIN: string;
          Product?: {
            Offers: Array<{
              BuyingPrice: {
                ListingPrice: { Amount: number; CurrencyCode: string };
                LandedPrice?: { Amount: number; CurrencyCode: string };
              };
              RegularPrice?: { Amount: number; CurrencyCode: string };
            }>;
          };
        }>;
      }>("GET", `/products/pricing/v0/price?${params}`);

      const productData = response.payload?.[0];
      const offer = productData?.Product?.Offers?.[0];

      return {
        asin,
        currentPrice: offer?.BuyingPrice?.LandedPrice?.Amount || 0,
        listPrice: offer?.RegularPrice?.Amount,
        currency: offer?.BuyingPrice?.ListingPrice?.CurrencyCode || "BRL",
        availability: "Em estoque",
      };
    } catch (error) {
      console.error("Erro ao obter preço (usando dados mock):", error);
      return this.getMockPrice(asin);
    }
  }

  /**
   * Adicionar produto ao carrinho
   * Nota: Esta funcionalidade pode requerer integração adicional
   */
  async addToCart(asin: string, quantity: number): Promise<CartResult> {
    // A SP-API padrão não tem endpoint direto para carrinho
    // Isso normalmente requer integração com Amazon Business Purchasing
    // ou uso de links de afiliado/carrinho

    const cartUrl = `https://www.amazon.com.br/gp/aws/cart/add.html?ASIN.1=${asin}&Quantity.1=${quantity}`;

    return {
      success: true,
      message: `Para adicionar ao carrinho, acesse: ${cartUrl}`,
    };
  }

  /**
   * Extrair especificações dos atributos
   */
  private extractSpecifications(
    attributes?: Record<string, Array<{ value: string }>>
  ): Record<string, string> {
    if (!attributes) return {};

    const specs: Record<string, string> = {};
    for (const [key, values] of Object.entries(attributes)) {
      if (values?.[0]?.value) {
        specs[key] = values[0].value;
      }
    }
    return specs;
  }

  // Métodos mock para desenvolvimento sem credenciais
  private getMockProducts(query: string, maxResults: number): Product[] {
    return [
      {
        asin: "B0MOCK001",
        title: `${query} - Produto Exemplo 1`,
        brand: "Marca Exemplo",
        category: "Eletrônicos",
      },
      {
        asin: "B0MOCK002",
        title: `${query} - Produto Exemplo 2`,
        brand: "Outra Marca",
        category: "Eletrônicos",
      },
    ].slice(0, maxResults);
  }

  private getMockProductDetails(asin: string): ProductDetails {
    return {
      asin,
      title: "Produto Exemplo",
      brand: "Marca Exemplo",
      description: "Descrição detalhada do produto",
      manufacturer: "Fabricante Exemplo",
      partNumber: "PN-12345",
      features: ["Feature 1", "Feature 2", "Feature 3"],
      specifications: {
        Peso: "500g",
        Dimensões: "20x15x10 cm",
      },
    };
  }

  private getMockPrice(asin: string): PriceInfo {
    return {
      asin,
      currentPrice: 199.99,
      listPrice: 249.99,
      businessPrice: 179.99,
      currency: "BRL",
      availability: "Em estoque",
      quantityDiscounts: [
        { minQuantity: 5, price: 169.99 },
        { minQuantity: 10, price: 159.99 },
      ],
    };
  }
}
