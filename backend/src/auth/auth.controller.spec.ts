import { Test, TestingModule } from '@nestjs/testing';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { DeepMockProxy, mockDeep } from 'jest-mock-extended';
import { RegisterDto } from './dto/register.dto';
import { LoginDto, LoginResponse } from './dto/login.dto';
import { AUTH_MESSAGES } from './auth.messages';

describe('AuthController', () => {
  let authService: DeepMockProxy<AuthService>;
  let controller: AuthController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuthController],
      providers: [
        {
          provide: AuthService,
          useValue: mockDeep<AuthService>(),
        },
      ],
    }).compile();
    authService = module.get<DeepMockProxy<AuthService>>(AuthService);
    controller = module.get<AuthController>(AuthController);
  });

  describe('register', () => {
    it('should register a new user', async () => {
      const userId = '123';
      const registerDto: RegisterDto = {
        email: 'test@test.com',
        password: 'test123',
        name: 'test',
        username: 'test',
      };
      authService.register.mockResolvedValue(userId);
      const result = await controller.register(registerDto);
      expect(result.message).toBe(AUTH_MESSAGES.USER_REGISTERED_SUCCESSFULLY);
      expect(result.data).toBe(userId);
      expect(result.success).toBe(true);
    });
  });

  describe('login', () => {
    it('should login a user', async () => {
      const userId = '123';
      const accessToken = 'ACCESS_TOKEN';
      const loginDto: LoginDto = {
        email: 'test@test.com',
        password: 'P@ssw0rd41',
      };
      authService.login.mockResolvedValue(<LoginResponse>{
        user: {
          id: userId,
          email: 'test@test.com',
          username: 'test',
          role: 'USER',
        },
        accessToken: accessToken,
      });
      const result = await controller.login(loginDto);
      expect(result.data.user.id).toBe(userId);
      expect(result.data.accessToken).toBe(accessToken);
    });
  });
});
