import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types';
import { AuthModule } from '../../src/auth/auth.module';
import { ConfigModule } from '@nestjs/config';
import { CommonModule } from '../../src/common/common.module';
import { RegisterDto } from '../../src/model/user/register.model';
import { ResponseModel } from '../../src/model/response.model';
import { AuthTestModule } from './auth_test.module';
import { AuthTestService } from './auth_test.service';

describe('AuthController (e2e)', () => {
  let app: INestApplication<App>;
  let authTestService: AuthTestService;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          isGlobal: true,
          envFilePath: '.env',
        }),
        AuthModule,
        CommonModule,
        AuthTestModule,
      ],
    }).compile();

    app = moduleFixture.createNestApplication();
    authTestService = moduleFixture.get<AuthTestService>(AuthTestService);
    await app.init();
  });

  describe('/register (POST)', () => {
    beforeEach(async () => {});

    it('Should be registered successfully', async () => {
      await authTestService.deleteAllUsers();
      const result = await request(app.getHttpServer())
        .post('/register')
        .send(<RegisterDto>{
          email: 'test@test.com',
          password: 'P@ssw0rd41',
          name: 'test',
          username: 'test',
        });
      console.log(result.body);
      expect(result.status).toBe(201);
      const { message, data, success } =
        result.body as unknown as ResponseModel<string>;
      expect(message).toBe('USER_REGISTERED_SUCCESSFULLY');
      expect(data).toBeDefined();
      expect(success).toBe(true);
    });
  });
});
