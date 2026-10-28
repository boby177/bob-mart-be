import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import neo4j from 'neo4j-driver';
import { NEO4J_DRIVER } from './neo4j.constants.js';
import { Neo4jService } from './neo4j.service.js';

@Global()
@Module({
  providers: [
    {
      provide: NEO4J_DRIVER,
      inject: [ConfigService],
      useFactory: async (config: ConfigService) => {
        const driver = neo4j.driver(
          config.getOrThrow<string>('NEO4J_URI'),
          neo4j.auth.basic(
            config.getOrThrow<string>('NEO4J_USERNAME'),
            config.getOrThrow<string>('NEO4J_PASSWORD'),
          ),
          { disableLosslessIntegers: true },
        );
        await driver.verifyConnectivity(); // gagal start kalau kredensial salah
        return driver;
      },
    },
    Neo4jService,
  ],
  exports: [NEO4J_DRIVER, Neo4jService],
})
export class Neo4jModule {}
