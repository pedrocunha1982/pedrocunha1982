import { randomUUID } from "crypto";

export interface ShoppingItem {
  id: string;
  name: string;
  asin?: string;
  partNumber?: string;
  quantity: number;
  notes?: string;
  addedAt: Date;
  priceSnapshot?: {
    price: number;
    currency: string;
    source: string;
    fetchedAt: Date;
  };
}

export interface ShoppingList {
  name: string;
  items: ShoppingItem[];
  createdAt: Date;
  updatedAt: Date;
  totalEstimated?: number;
}

/**
 * Gerenciador de listas de compras
 */
export class ShoppingListManager {
  private lists: Map<string, ShoppingList> = new Map();

  /**
   * Criar ou obter uma lista
   */
  getList(listName: string): ShoppingList {
    if (!this.lists.has(listName)) {
      this.lists.set(listName, {
        name: listName,
        items: [],
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    }
    return this.lists.get(listName)!;
  }

  /**
   * Listar todas as listas disponíveis
   */
  getAllLists(): string[] {
    return Array.from(this.lists.keys());
  }

  /**
   * Adicionar item à lista
   */
  addItem(
    listName: string,
    item: Omit<ShoppingItem, "id" | "addedAt">
  ): ShoppingItem {
    const list = this.getList(listName);

    const newItem: ShoppingItem = {
      ...item,
      id: randomUUID(),
      addedAt: new Date(),
    };

    list.items.push(newItem);
    list.updatedAt = new Date();
    this.updateTotal(list);

    return newItem;
  }

  /**
   * Atualizar item existente
   */
  updateItem(
    listName: string,
    itemId: string,
    updates: Partial<Omit<ShoppingItem, "id" | "addedAt">>
  ): ShoppingItem | null {
    const list = this.getList(listName);
    const itemIndex = list.items.findIndex((item) => item.id === itemId);

    if (itemIndex === -1) {
      return null;
    }

    list.items[itemIndex] = {
      ...list.items[itemIndex],
      ...updates,
    };
    list.updatedAt = new Date();
    this.updateTotal(list);

    return list.items[itemIndex];
  }

  /**
   * Remover item da lista
   */
  removeItem(listName: string, itemId: string): boolean {
    const list = this.getList(listName);
    const initialLength = list.items.length;

    list.items = list.items.filter((item) => item.id !== itemId);

    if (list.items.length !== initialLength) {
      list.updatedAt = new Date();
      this.updateTotal(list);
      return true;
    }

    return false;
  }

  /**
   * Limpar todos os itens de uma lista
   */
  clearList(listName: string): void {
    const list = this.getList(listName);
    list.items = [];
    list.updatedAt = new Date();
    list.totalEstimated = 0;
  }

  /**
   * Deletar uma lista completamente
   */
  deleteList(listName: string): boolean {
    return this.lists.delete(listName);
  }

  /**
   * Buscar item por ID em qualquer lista
   */
  findItem(itemId: string): { list: string; item: ShoppingItem } | null {
    for (const [listName, list] of this.lists.entries()) {
      const item = list.items.find((i) => i.id === itemId);
      if (item) {
        return { list: listName, item };
      }
    }
    return null;
  }

  /**
   * Atualizar preço de um item
   */
  updateItemPrice(
    listName: string,
    itemId: string,
    price: number,
    currency: string,
    source: string
  ): boolean {
    const list = this.getList(listName);
    const item = list.items.find((i) => i.id === itemId);

    if (!item) {
      return false;
    }

    item.priceSnapshot = {
      price,
      currency,
      source,
      fetchedAt: new Date(),
    };

    list.updatedAt = new Date();
    this.updateTotal(list);

    return true;
  }

  /**
   * Atualizar total estimado da lista
   */
  private updateTotal(list: ShoppingList): void {
    list.totalEstimated = list.items.reduce((total, item) => {
      if (item.priceSnapshot) {
        return total + item.priceSnapshot.price * item.quantity;
      }
      return total;
    }, 0);
  }

  /**
   * Exportar lista para formato JSON
   */
  exportList(listName: string): string {
    const list = this.getList(listName);
    return JSON.stringify(list, null, 2);
  }

  /**
   * Importar lista de JSON
   */
  importList(listName: string, jsonData: string): ShoppingList {
    const data = JSON.parse(jsonData) as ShoppingList;

    const list: ShoppingList = {
      name: listName,
      items: data.items.map((item) => ({
        ...item,
        id: item.id || randomUUID(),
        addedAt: new Date(item.addedAt),
      })),
      createdAt: new Date(data.createdAt),
      updatedAt: new Date(),
    };

    this.lists.set(listName, list);
    this.updateTotal(list);

    return list;
  }

  /**
   * Gerar resumo da lista
   */
  getSummary(listName: string): {
    totalItems: number;
    totalQuantity: number;
    totalEstimated: number;
    itemsWithPrice: number;
    itemsWithoutPrice: number;
  } {
    const list = this.getList(listName);

    const itemsWithPrice = list.items.filter((i) => i.priceSnapshot).length;

    return {
      totalItems: list.items.length,
      totalQuantity: list.items.reduce((sum, i) => sum + i.quantity, 0),
      totalEstimated: list.totalEstimated || 0,
      itemsWithPrice,
      itemsWithoutPrice: list.items.length - itemsWithPrice,
    };
  }
}
