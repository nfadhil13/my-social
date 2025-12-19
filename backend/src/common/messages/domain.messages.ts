type DomainMessageType = {
  key: string;
  value: number;
};

export const DomainMessageTypes = {
  SUCCESS: { key: 'SUCCESS', value: 200 },
  NOT_FOUND: { key: 'NOT_FOUND', value: 404 },
  CONFLICT: { key: 'CONFLICT', value: 409 },
  UNAUTHORIZED: { key: 'UNAUTHORIZED', value: 401 },
  FORBIDDEN: { key: 'FORBIDDEN', value: 403 },
  VALIDATION: { key: 'VALIDATION', value: 400 },
  INTERNAL: { key: 'INTERNAL', value: 500 },
} satisfies Record<string, DomainMessageType>;

export interface DomainMessage {
  code: string;
  type: DomainMessageType;
}
