import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../src/common/prisma/prisma.service';

@Injectable()
export class AuthTestService {
  constructor(private readonly prisma: PrismaService) {}

  async deleteAllUsers(): Promise<void> {
    await this.prisma.profile.deleteMany();
    await this.prisma.user.deleteMany();
  }
}
