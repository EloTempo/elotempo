import { InputHTMLAttributes, forwardRef } from 'react';
import { cn } from './Button';

export interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
}

export const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ className, label, error, ...props }, ref) => {
    return (
      <div className="w-full">
        {label && (
          <label className="block text-sm font-semibold mb-1 text-tinta2">
            {label}
          </label>
        )}
        <input
          ref={ref}
          className={cn(
            'flex h-10 w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta placeholder:text-tinta3 focus:outline-none focus:ring-2 focus:ring-acento/50 disabled:cursor-not-allowed disabled:opacity-50',
            error && 'border-fem focus:ring-fem/50',
            className
          )}
          {...props}
        />
        {error && <p className="mt-1 text-xs text-fem">{error}</p>}
      </div>
    );
  }
);
Input.displayName = 'Input';
