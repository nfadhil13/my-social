import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma/prisma.service';
import { JwtModule } from '@nestjs/jwt';

@Global()
@Module({
  providers: [PrismaService],
  imports: [
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: '1h' },
    }),
  ],
  exports: [
    PrismaService,
    JwtModule.register({
      global: true,
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: '1h' },
    }),
  ],
})
export class CommonModule {}
