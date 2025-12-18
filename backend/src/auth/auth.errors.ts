import {
  DomainErrorDefinition,
  DomainErrorType,
} from '../common/error/domain.error';

export const AUTH_ERRORS = {
  EMAIL_ALREADY_EXISTS: {
    code: 'EMAIL_ALREADY_EXISTS',
    type: DomainErrorType.CONFLICT,
  },
  USERNAME_ALREADY_EXISTS: {
    code: 'USERNAME_ALREADY_EXISTS',
    type: DomainErrorType.CONFLICT,
  },
  INVALID_CREDENTIALS: {
    code: 'INVALID_CREDENTIALS',
    type: DomainErrorType.UNAUTHORIZED,
  },
} satisfies Record<string, DomainErrorDefinition>;

export const AUTH_VALIDATION_ERRORS = {
  TOO_LONG_PASSWORD: {
    code: 'TOO_LONG_PASSWORD',
    type: DomainErrorType.VALIDATION,
  },
  TOO_SHORT_PASSWORD: {
    code: 'TOO_SHORT_PASSWORD',
    type: DomainErrorType.VALIDATION,
  },
  PASSWORD_RULES: {
    code: 'PASSWORD_RULES',
    type: DomainErrorType.VALIDATION,
  },
} satisfies Record<string, DomainErrorDefinition>;
