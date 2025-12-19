import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { App } from 'supertest/types';
import { RegisterDto } from '../../src/model/user/register.model';
import { ResponseModel } from '../../src/model/response.model';
import { AuthTestService } from './auth_test.service';
import { AppModule } from '../../src/app.module';
import { AuthTestModule } from './auth_test.module';
import { DomainMessageTypes } from '../../src/common/messages/domain.messages';
import { VALIDATION_ERRORS } from '../../src/common/validation/validation.error';
import { extractValidationErrors } from '../validation_error_extractor';
import { Profile, User } from '../../src/common/prisma/client/client';
import { AUTH_ERRORS } from '../../src/auth/auth.messages';

describe('AuthController (e2e)', () => {
  let app: INestApplication<App>;
  let authTestService: AuthTestService;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule, AuthTestModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    authTestService = moduleFixture.get<AuthTestService>(AuthTestService);
    await app.init();
  });

  describe('/register (POST)', () => {
    beforeEach(async () => {
      await authTestService.deleteAllUsers();
    });

    const user = <User>{
      email: 'test@test.com',
      username: 'test',
      password_hash: 'P@ssw0rd41',
      role: 'USER',
      created_at: new Date(),
      updated_at: new Date(),
    };

    const profile = <Profile>{
      name: 'test',
      bio: null,
      avatar_file_id: null,
      thumbnail_file_id: null,
      created_at: new Date(),
      updated_at: new Date(),
    };

    it('Should be registered successfully', async () => {
      const result = await request(app.getHttpServer())
        .post('/register')
        .send(<RegisterDto>{
          email: 'test@test.com',
          password: 'P@ssw0rd41',
          name: 'test',
          username: 'test',
        });
      expect(result.status).toBe(201);
      const { message, data, success } =
        result.body as unknown as ResponseModel<string>;
      expect(message).toBe('USER_REGISTERED_SUCCESSFULLY');
      expect(data).toBeDefined();
      expect(success).toBe(true);
    });

    it('Should return validation errors', async () => {
      const requestBody = <RegisterDto>{
        email: 'testtest.com',
        password: 'P@ssw0rd41',
        username: 'InvaDlidUsername123',
      };
      const result = await request(app.getHttpServer())
        .post('/register')
        .send(requestBody);
      expect(result.status).toBe(DomainMessageTypes.VALIDATION.value);
      const { message, data, success, errors } =
        result.body as unknown as ResponseModel<string>;
      expect(message).toBe(DomainMessageTypes.VALIDATION.key);
      expect(data).toBeNull();
      expect(success).toBe(false);
      expect(errors).toBeDefined();
      if (!errors) fail('Errors are not defined');
      // Check Email erros
      const emailErrors = extractValidationErrors(errors, 'email');
      expect(emailErrors).toBeDefined();
      expect(emailErrors?.length).toBe(1);
      expect(emailErrors?.[0]?.code).toBe(VALIDATION_ERRORS.EMAIL_INVALID);

      // Check Username errors
      const usernameErrors = extractValidationErrors(errors, 'username');
      expect(usernameErrors).toBeDefined();
      expect(usernameErrors?.length).toBe(1);
      expect(usernameErrors?.[0]?.code).toBe(VALIDATION_ERRORS.REGEX);

      // Check Fullname errors
      const fullnameErrors = extractValidationErrors(errors, 'name');
      expect(fullnameErrors).toBeDefined();
      expect(fullnameErrors?.length).toBe(1);
      expect(fullnameErrors?.[0]?.code).toBe(VALIDATION_ERRORS.REQUIRED);
    });

    it('Should Return Conflict Error when email already exists', async () => {
      await authTestService.createUser(user, profile);
      const result = await request(app.getHttpServer())
        .post('/register')
        .send(<RegisterDto>{
          email: user.email,
          password: user.password_hash,
          name: 'NAME',
          username: 'mynewusername',
        });
      expect(result.status).toBe(DomainMessageTypes.CONFLICT.value);
      const { message, data, success, errors } =
        result.body as unknown as ResponseModel<string>;
      expect(message).toBe(AUTH_ERRORS.EMAIL_ALREADY_EXISTS.code);
      expect(data).toBeNull();
      expect(success).toBe(false);
      expect(errors).toBeUndefined();
    });

    it('Should Return Conflict Error when username already exists', async () => {
      await authTestService.createUser(user, profile);
      const result = await request(app.getHttpServer())
        .post('/register')
        .send(<RegisterDto>{
          email: 'newemail@test.com',
          password: 'P@ssw0rd41',
          name: 'NAME',
          username: user.username,
        });
      expect(result.status).toBe(DomainMessageTypes.CONFLICT.value);
      const { message, data, success, errors } =
        result.body as unknown as ResponseModel<string>;
      expect(message).toBe(AUTH_ERRORS.USERNAME_ALREADY_EXISTS.code);
      expect(data).toBeNull();
      expect(success).toBe(false);
      expect(errors).toBeUndefined();
    });
  });
});
