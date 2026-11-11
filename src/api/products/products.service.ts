import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateProductDto } from './dto/create-product.dto.js';
import { UpdateProductDto } from './dto/update-product.dto.js';
import { Neo4jService } from '../../database/neo4j.service.js';
import {
  FIND_ALL_PRODUCTS,
  FIND_PRODUCT_BY_ID,
  CREATE_PRODUCT,
  DELETE_PRODUCT,
} from './entities/product.queries.js';
import { Product } from './entities/product.entity.js';

@Injectable()
export class ProductsService {
  constructor(private readonly neo4j: Neo4jService) {}

  async createProduct(createProductDto: CreateProductDto) {
    const { name, description, price, stock, categoryId } = createProductDto;
    const id = crypto.randomUUID();

    const newProduct = await this.neo4j.write(CREATE_PRODUCT, {
      id,
      name,
      description,
      price,
      stock,
      categoryId,
    });

    if (!newProduct.length) throw new NotFoundException('Category not found');
    return newProduct[0].newProduct;
  }

  async findAllProducts(): Promise<Product[]> {
    const data = await this.neo4j.read(FIND_ALL_PRODUCTS);
    return data.map((r) => r.product);
  }

  async findOne(id: string): Promise<Product> {
    const data = await this.neo4j.read(FIND_PRODUCT_BY_ID, { id });

    if (!data.length) {
      throw new NotFoundException(`Product not found`);
    }
    return data[0].product;
  }

  update(id: number, updateProductDto: UpdateProductDto) {
    return `This action updates a #${id} product`;
  }

  async deleteProduct(id: string) {
    // Check if the product exists before attempting to delete
    const product = await this.findOne(id.toString());

    await this.neo4j.write(DELETE_PRODUCT, { id: product.id });
    return { message: `Product ${product.name} has been deleted successfully` };
  }
}
