import {
  DomainMessage,
  DomainMessageTypes,
} from '../common/messages/domain.messages';

export const AUTH_MESSAGES = {
  USER_LOGGED_IN_SUCCESSFULLY: 'USER_LOGGED_IN_SUCCESSFULLY',
  USER_REGISTERED_SUCCESSFULLY: 'USER_REGISTERED_SUCCESSFULLY',
} satisfies Record<string, string>;

export const AUTH_ERRORS = {
  INVALID_CREDENTIALS: {
    code: 'INVALID_CREDENTIALS',
    type: DomainMessageTypes.UNAUTHORIZED,
  },
} satisfies Record<string, DomainMessage>;

export const AUTH_VALIDATION_ERRORS = {
  TOO_LONG_PASSWORD: {
    code: 'TOO_LONG_PASSWORD',
    type: DomainMessageTypes.VALIDATION,
  },
  TOO_SHORT_PASSWORD: {
    code: 'TOO_SHORT_PASSWORD',
    type: DomainMessageTypes.VALIDATION,
  },
  PASSWORD_RULES: {
    code: 'PASSWORD_RULES',
    type: DomainMessageTypes.VALIDATION,
  },
} satisfies Record<string, DomainMessage>;
