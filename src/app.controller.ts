import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service.js';
import { Neo4jService } from './database/neo4j.service.js';
import { ApiTags } from '@nestjs/swagger';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly neo4j: Neo4jService,
  ) {}

  @Get('health')
  health() {
    return this.neo4j.read('RETURN 1 AS ok');
  }

  @ApiTags('products')
  @Get('products')
  products() {
    return this.appService.getAllProducts();
  }
}
