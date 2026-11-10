import { Injectable } from '@nestjs/common';
import { CreateProductDto } from './dto/create-product.dto.js';
import { UpdateProductDto } from './dto/update-product.dto.js';
import { Neo4jService } from '../../database/neo4j.service.js';
import {
  FIND_ALL_PRODUCTS,
  FIND_PRODUCT_BY_ID,
} from './entities/product.queries.js';
import { Product } from './entities/product.entity.js';

@Injectable()
export class ProductsService {
  constructor(private readonly neo4j: Neo4jService) {}

  create(createProductDto: CreateProductDto) {
    return 'This action adds a new product';
  }

  async findAllProducts(): Promise<Product[]> {
    const data = await this.neo4j.read(FIND_ALL_PRODUCTS);
    return data.map((r) => r.product);
  }

  async findOne(id: number): Promise<Product> {
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
