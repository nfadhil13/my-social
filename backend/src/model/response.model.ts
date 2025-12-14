export class ResponseModel<T = unknown> {
  message: string;
  data: T;
  success: boolean;
  errors?: {
    [key: string]: string;
  };
}
