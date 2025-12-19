import {
  DomainMessage,
  DomainMessageTypes,
} from '../common/messages/domain.messages';

export const USER_ERRORS = {
  EMAIL_ALREADY_EXISTS: {
    code: 'EMAIL_ALREADY_EXISTS',
    type: DomainMessageTypes.CONFLICT,
  },
  USERNAME_ALREADY_EXISTS: {
    code: 'USERNAME_ALREADY_EXISTS',
    type: DomainMessageTypes.CONFLICT,
  },
  INVALID_CREDENTIALS: {
    code: 'INVALID_CREDENTIALS',
    type: DomainMessageTypes.UNAUTHORIZED,
  },
} satisfies Record<string, DomainMessage>;
