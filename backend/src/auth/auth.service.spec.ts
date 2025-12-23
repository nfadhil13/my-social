import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { DeepMockProxy, mockDeep } from 'jest-mock-extended';
import { RegisterRequest } from './dto/request/RegisterRequest';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { DomainException } from '../common/messages/domain.exception';
import { AUTH_ERRORS } from './auth.messages';
import { UserService } from '../user/user.service';
import { USER_ERRORS } from '../user/user.messages';
import { LoginRequest } from './dto/request/LoginRequest';

describe('AuthService', () => {
  let service: AuthService;
  let jwtService: DeepMockProxy<JwtService>;
  let userService: DeepMockProxy<UserService>;

  beforeEach(async () => {
    userService = mockDeep<UserService>();
    jwtService = mockDeep<JwtService>();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: UserService,
          useValue: userService,
        },
        {
          provide: JwtService,
          useValue: jwtService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  describe('register', () => {
    it('should register a new user', async () => {
      const userId = '123';
      const registerDto: RegisterRequest = {
        email: 'test@test.com',
        password: 'test123',
        name: 'test',
        username: 'test',
      };
      userService.createUser.mockResolvedValue({
        id: userId,
        email: registerDto.email,
        username: registerDto.username,
        role: 'USER',
      });
      const user = await service.register(registerDto);
      expect(user).toBeDefined();
      expect(user).toBe(userId);
    });

    it('should throw an error if the email already exists', async () => {
      const registerDto: RegisterRequest = {
        email: 'test@test.com',
        password: 'test123',
        name: 'test',
        username: 'test',
      };
      userService.createUser.mockRejectedValue(
        new DomainException(USER_ERRORS.EMAIL_ALREADY_EXISTS),
      );
      try {
        await service.register(registerDto);
      } catch (error) {
        expect(error).toBeInstanceOf(DomainException);
        expect((error as DomainException).error).toBe(
          USER_ERRORS.EMAIL_ALREADY_EXISTS,
        );
      }
    });

    it('should throw an error if the username already exists', async () => {
      const registerDto: RegisterRequest = {
        email: 'test@test.com',
        password: 'test123',
        name: 'test',
        username: 'test',
      };
      userService.createUser.mockRejectedValue(
        new DomainException(USER_ERRORS.USERNAME_ALREADY_EXISTS),
      );
      try {
        await service.register(registerDto);
      } catch (error) {
        expect(error).toBeInstanceOf(DomainException);
        expect((error as DomainException).error).toBe(
          USER_ERRORS.USERNAME_ALREADY_EXISTS,
        );
      }
    });
  });

  describe('login', () => {
    it('should login a user', async () => {
      const accessToken = 'ACCESS_TOKEN';
      const loginDto: LoginRequest = {
        email: 'test@test.com',
        password: 'test123',
      };
      const hashedPassword = await bcrypt.hash('test123', 10);
      userService.findByEmail.mockResolvedValue({
        id: '123',
        email: loginDto.email,
        password_hash: hashedPassword,
        role: 'USER',
        username: 'test',
      });
      jwtService.signAsync.mockResolvedValue(accessToken);
      const user = await service.login(loginDto);
      expect(user).toBeDefined();
      expect(user.user.id).toBe('123');
      expect(user.user.email).toBe(loginDto.email);
      expect(user.user.role).toBe('USER');
      expect(user.accessToken).toBe(accessToken);
    });

    it('should throw an error if the user does not exist', async () => {
      const loginDto: LoginRequest = {
        email: 'test@test.com',
        password: 'test123',
      };
      userService.findByEmail.mockResolvedValue(null);
      try {
        await service.login(loginDto);
      } catch (error) {
        expect(error).toBeInstanceOf(DomainException);
        expect((error as DomainException).error).toBe(
          AUTH_ERRORS.INVALID_CREDENTIALS,
        );
      }
    });

    it('should throw an error if the password is incorrect', async () => {
      const loginDto: LoginRequest = {
        email: 'test@test.com',
        password: 'test123',
      };
      userService.findByEmail.mockResolvedValue({
        id: '123',
        email: loginDto.email,
        password_hash: 'test123',
        role: 'USER',
        username: 'test',
      });
      try {
        await service.login(loginDto);
      } catch (error) {
        expect(error).toBeInstanceOf(DomainException);
        expect((error as DomainException).error).toBe(
          AUTH_ERRORS.INVALID_CREDENTIALS,
        );
      }
    });
  });
});
