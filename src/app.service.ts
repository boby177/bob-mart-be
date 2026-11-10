import { Injectable } from '@nestjs/common';
import { Neo4jService } from './database/neo4j.service.js';

@Injectable()
export class AppService {
  constructor(private readonly neo4j: Neo4jService) {}

  getHello(): string {
    return 'Hello World!';
  }

  getAllProducts(): Promise<any> {
    return this.neo4j.read('MATCH (p:Product) RETURN p');
  }
}
