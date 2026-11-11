import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateProductDto } from './dto/create-product.dto.js';
import { UpdateProductDto } from './dto/update-product.dto.js';
import { Neo4jService } from '../../database/neo4j.service.js';
import {
  FIND_ALL_PRODUCTS,
  FIND_PRODUCT_BY_ID,
  CREATE_PRODUCT,
} from './entities/product.queries.js';
import { Product } from './entities/product.entity.js';

@Injectable()
export class ProductsService {
  constructor(private readonly neo4j: Neo4jService) {}

  async create(createProductDto: CreateProductDto) {
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
    return data[0].product;
  }

  update(id: number, updateProductDto: UpdateProductDto) {
    return `This action updates a #${id} product`;
  }

  remove(id: number) {
    return `This action removes a #${id} product`;
  }
}
