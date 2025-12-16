import { Module } from '@nestjs/common';

import { ConfigModule } from '@nestjs/config';
import { CommonModule } from './common/common.module';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [CommonModule, ConfigModule.forRoot({ isGlobal: true }), AuthModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
