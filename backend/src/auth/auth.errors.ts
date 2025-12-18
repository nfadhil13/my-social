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
