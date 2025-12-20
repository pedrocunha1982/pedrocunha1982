import { AmazonBusinessClient, PriceInfo } from "../clients/amazon-business.js";

export interface PriceSource {
  name: string;
  price: number;
  currency: string;
  availability: string;
  url?: string;
  businessPrice?: number;
  quantityDiscounts?: Array<{
    minQuantity: number;
    price: number;
  }>;
  shippingCost?: number;
  deliveryEstimate?: string;
}

export interface ComparisonResult {
  productName: string;
  searchedAt: Date;
  sources: PriceSource[];
  bestPrice?: PriceSource;
  bestBusinessPrice?: PriceSource;
  recommendations: string[];
}

export interface ComparisonQuery {
  productName: string;
  asin?: string;
  partNumber?: string;
  quantity?: number;
}

/**
 * Serviço de comparação de preços entre fornecedores
 */
export class PriceComparisonService {
  private amazonClient: AmazonBusinessClient;
  // Futuros clientes para outras plataformas
  // private digikeyClient?: DigikeyClient;
  // private mouserClient?: MouserClient;
  // private alibabaClient?: AlibabaClient;

  constructor(clients: [AmazonBusinessClient, ...unknown[]]) {
    this.amazonClient = clients[0];
  }

  /**
   * Comparar preços de um produto em diferentes fontes
   */
  async compare(query: ComparisonQuery): Promise<ComparisonResult> {
    const sources: PriceSource[] = [];
    const recommendations: string[] = [];

    // Buscar no Amazon Business
    if (query.asin) {
      try {
        const amazonPrice = await this.amazonClient.getPrice(query.asin, true);
        sources.push(this.formatAmazonPrice(amazonPrice));
      } catch (error) {
        recommendations.push(`Erro ao buscar Amazon: ${error}`);
      }
    } else {
      // Buscar por nome do produto
      try {
        const products = await this.amazonClient.searchProducts(
          query.productName,
          undefined,
          5
        );

        if (products.length > 0) {
          const prices = await Promise.all(
            products.slice(0, 3).map(async (product) => {
              const price = await this.amazonClient.getPrice(product.asin, true);
              return { ...price, title: product.title };
            })
          );

          prices.forEach((price, index) => {
            sources.push({
              ...this.formatAmazonPrice(price),
              name: `Amazon - ${(price as PriceInfo & { title?: string }).title || `Opção ${index + 1}`}`,
            });
          });
        }
      } catch (error) {
        recommendations.push(`Erro ao buscar Amazon: ${error}`);
      }
    }

    // TODO: Adicionar outras fontes (DigiKey, Mouser, Alibaba, etc.)
    // Por enquanto, simular dados de outras fontes para demonstração
    if (process.env.NODE_ENV === "development" || sources.length > 0) {
      sources.push(...this.getMockCompetitorPrices(query));
    }

    // Encontrar melhores preços
    const bestPrice = this.findBestPrice(sources, "price");
    const bestBusinessPrice = this.findBestPrice(sources, "businessPrice");

    // Gerar recomendações
    if (bestPrice && bestBusinessPrice && bestPrice !== bestBusinessPrice) {
      const savings =
        ((bestPrice.price - (bestBusinessPrice.businessPrice || bestBusinessPrice.price)) /
          bestPrice.price) *
        100;

      if (savings > 5) {
        recommendations.push(
          `Economia de ${savings.toFixed(1)}% usando preço Business em ${bestBusinessPrice.name}`
        );
      }
    }

    if (sources.length > 1) {
      const priceDiff = this.calculatePriceSpread(sources);
      if (priceDiff > 20) {
        recommendations.push(
          `Grande variação de preços (${priceDiff.toFixed(0)}%) - vale a pena comparar`
        );
      }
    }

    // Verificar descontos por quantidade
    const quantityDiscountSources = sources.filter(
      (s) => s.quantityDiscounts && s.quantityDiscounts.length > 0
    );
    if (quantityDiscountSources.length > 0) {
      recommendations.push(
        `${quantityDiscountSources.length} fornecedor(es) oferecem desconto por quantidade`
      );
    }

    return {
      productName: query.productName,
      searchedAt: new Date(),
      sources,
      bestPrice,
      bestBusinessPrice,
      recommendations,
    };
  }

  /**
   * Formatar preço do Amazon para formato padrão
   */
  private formatAmazonPrice(price: PriceInfo): PriceSource {
    return {
      name: "Amazon Business",
      price: price.currentPrice,
      currency: price.currency,
      availability: price.availability,
      businessPrice: price.businessPrice,
      quantityDiscounts: price.quantityDiscounts,
      url: `https://www.amazon.com.br/dp/${price.asin}`,
    };
  }

  /**
   * Encontrar melhor preço
   */
  private findBestPrice(
    sources: PriceSource[],
    priceField: "price" | "businessPrice"
  ): PriceSource | undefined {
    const availableSources = sources.filter(
      (s) => s.availability !== "Indisponível" && s[priceField]
    );

    if (availableSources.length === 0) return undefined;

    return availableSources.reduce((best, current) => {
      const bestVal = priceField === "businessPrice" ? best.businessPrice || best.price : best.price;
      const currVal = priceField === "businessPrice" ? current.businessPrice || current.price : current.price;
      return currVal < bestVal ? current : best;
    });
  }

  /**
   * Calcular variação de preços
   */
  private calculatePriceSpread(sources: PriceSource[]): number {
    const prices = sources.map((s) => s.price).filter((p) => p > 0);
    if (prices.length < 2) return 0;

    const min = Math.min(...prices);
    const max = Math.max(...prices);

    return ((max - min) / min) * 100;
  }

  /**
   * Dados mock de concorrentes para demonstração
   */
  private getMockCompetitorPrices(query: ComparisonQuery): PriceSource[] {
    // Estes seriam substituídos por chamadas reais às APIs
    // DigiKey, Mouser, Alibaba, AliExpress, etc.

    const mockSources: PriceSource[] = [
      {
        name: "DigiKey (próxima integração)",
        price: 185.50,
        currency: "BRL",
        availability: "Em estoque - 50 unidades",
        shippingCost: 45.00,
        deliveryEstimate: "5-7 dias úteis",
        quantityDiscounts: [
          { minQuantity: 10, price: 175.00 },
          { minQuantity: 25, price: 165.00 },
          { minQuantity: 100, price: 150.00 },
        ],
      },
      {
        name: "Mouser (próxima integração)",
        price: 192.30,
        currency: "BRL",
        availability: "Em estoque",
        shippingCost: 55.00,
        deliveryEstimate: "7-10 dias úteis",
        quantityDiscounts: [
          { minQuantity: 10, price: 182.00 },
          { minQuantity: 50, price: 170.00 },
        ],
      },
      {
        name: "Alibaba (próxima integração)",
        price: 95.00,
        currency: "BRL",
        availability: "MOQ: 100 unidades",
        shippingCost: 250.00,
        deliveryEstimate: "30-45 dias",
        quantityDiscounts: [
          { minQuantity: 500, price: 75.00 },
          { minQuantity: 1000, price: 60.00 },
        ],
      },
    ];

    return mockSources;
  }

  /**
   * Calcular custo total incluindo frete
   */
  calculateTotalCost(
    source: PriceSource,
    quantity: number
  ): {
    unitPrice: number;
    totalProducts: number;
    shipping: number;
    total: number;
  } {
    let unitPrice = source.price;

    // Aplicar desconto por quantidade se disponível
    if (source.quantityDiscounts) {
      const applicableDiscount = source.quantityDiscounts
        .filter((d) => quantity >= d.minQuantity)
        .sort((a, b) => b.minQuantity - a.minQuantity)[0];

      if (applicableDiscount) {
        unitPrice = applicableDiscount.price;
      }
    }

    const totalProducts = unitPrice * quantity;
    const shipping = source.shippingCost || 0;

    return {
      unitPrice,
      totalProducts,
      shipping,
      total: totalProducts + shipping,
    };
  }
}
