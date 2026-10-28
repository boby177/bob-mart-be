import { Inject, Injectable, OnApplicationShutdown } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import neo4j, { Driver } from "neo4j-driver";
import { NEO4J_DRIVER } from "./neo4j.constants.js";

@Injectable()
export class Neo4jService implements OnApplicationShutdown {
  constructor(
    @Inject(NEO4J_DRIVER) private readonly driver: Driver,
    private readonly config: ConfigService,
  ) {}

  async read(cypher: string, params: Record<string, any> = {}) {
    const { records } = await this.driver.executeQuery(cypher, params, {
      database: this.config.get('NEO4J_DATABASE'),
      routing: neo4j.routing.READ,
    });
    return records.map((r) => r.toObject());
  }

  async onApplicationShutdown() {
    await this.driver.close();
  }
}
