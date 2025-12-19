export class ResponseModel<T = unknown> {
  message: string;
  data: T;
  success: boolean;
  errors?: Record<string, any>;
}

export function successResponse<T>(data: T, message: string): ResponseModel<T> {
  return {
    message,
    data,
    success: true,
  };
}
