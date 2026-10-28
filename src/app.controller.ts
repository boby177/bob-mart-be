import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service.js';
import { Neo4jService } from './database/neo4j.service.js';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly neo4j: Neo4jService,
  ) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('health')
  health() {
    return this.neo4j.read('RETURN 1 AS ok');
  }

  @Get('products')
  products() {
    return this.neo4j.read('MATCH (p:Product) RETURN p');
  }
}
