import { Module } from '@nestjs/common';
import { AuthTestService } from './auth_test.service';

@Module({
  imports: [],
  providers: [AuthTestService],
})
export class AuthTestModule {}
