export class ResponseModel<T = unknown> {
  message: string;
  data: T;
  success: boolean;
  errors?: {
    [key: string]: string;
  };
}

Promise.prototype.toSuccessResponse = async function <T>(
  message: string,
): Promise<ResponseModel<T>> {
  const result = (await this) as T;
  return {
    message,
    data: result,
    success: true,
  };
};
