declare global {
  interface Promise<T> {
    toSuccessResponse(message: string): Promise<{
      message: string;
      data: T;
      success: boolean;
      errors?: {
        [key: string]: string;
      };
    }>;
  }
}

export {};
