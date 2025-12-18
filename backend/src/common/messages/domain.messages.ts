export enum DomainMessageType {
  SUCCESS = 'SUCCESS',
  NOT_FOUND = 'NOT_FOUND',
  CONFLICT = 'CONFLICT',
  UNAUTHORIZED = 'UNAUTHORIZED',
  FORBIDDEN = 'FORBIDDEN',
  VALIDATION = 'VALIDATION',
  INTERNAL = 'INTERNAL',
}

export interface DomainMessage {
  code: string;
  type: DomainMessageType;
}
