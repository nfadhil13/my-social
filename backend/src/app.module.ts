import { Module } from '@nestjs/common';

import { ConfigModule } from '@nestjs/config';
import { CommonModule } from './common/common.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { APP_FILTER } from '@nestjs/core';
import { DomainExceptionFilter } from './common/messages/domain-exception.filter';

@Module({
  imports: [
    CommonModule,
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: `.env${process.env.NODE_ENV === undefined ? '' : `.${process.env.NODE_ENV}`}`,
    }),
    AuthModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_FILTER,
      useClass: DomainExceptionFilter,
    },
  ],
})
export class AppModule {}
