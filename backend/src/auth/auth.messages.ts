import {
  DomainMessage,
  DomainMessageType,
} from '../common/messages/domain.messages';

export const AUTH_MESSAGES = {
  USER_LOGGED_IN_SUCCESSFULLY: 'USER_LOGGED_IN_SUCCESSFULLY',
  USER_REGISTERED_SUCCESSFULLY: 'USER_REGISTERED_SUCCESSFULLY',
} satisfies Record<string, string>;

export const AUTH_ERRORS = {
  SUCCESS: {
    code: 'SUCCESS',
    type: DomainMessageType.SUCCESS,
  },
  EMAIL_ALREADY_EXISTS: {
    code: 'EMAIL_ALREADY_EXISTS',
    type: DomainMessageType.CONFLICT,
  },
  USERNAME_ALREADY_EXISTS: {
    code: 'USERNAME_ALREADY_EXISTS',
    type: DomainMessageType.CONFLICT,
  },
  INVALID_CREDENTIALS: {
    code: 'INVALID_CREDENTIALS',
    type: DomainMessageType.UNAUTHORIZED,
  },
} satisfies Record<string, DomainMessage>;

export const AUTH_VALIDATION_ERRORS = {
  TOO_LONG_PASSWORD: {
    code: 'TOO_LONG_PASSWORD',
    type: DomainMessageType.VALIDATION,
  },
  TOO_SHORT_PASSWORD: {
    code: 'TOO_SHORT_PASSWORD',
    type: DomainMessageType.VALIDATION,
  },
  PASSWORD_RULES: {
    code: 'PASSWORD_RULES',
    type: DomainMessageType.VALIDATION,
  },
} satisfies Record<string, DomainMessage>;
