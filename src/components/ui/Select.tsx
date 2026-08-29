import { forwardRef, SelectHTMLAttributes } from 'react';
import { cn } from './Button';

export interface SelectProps extends SelectHTMLAttributes<HTMLSelectElement> {
  label?: string;
  error?: string;
  options: { value: string; label: string }[];
}

export const Select = forwardRef<HTMLSelectElement, SelectProps>(
  ({ className, label, error, options, ...props }, ref) => {
    return (
      <div className="w-full">
        {label && (
          <label className="block text-sm font-semibold mb-1 text-tinta2">
            {label}
          </label>
        )}
        <select
          ref={ref}
          className={cn(
            'flex h-10 w-full rounded-raio-s border border-borda bg-card px-3 py-2 text-sm text-tinta focus:outline-none focus:ring-2 focus:ring-acento/50 disabled:cursor-not-allowed disabled:opacity-50 appearance-none',
            error && 'border-fem focus:ring-fem/50',
            className
          )}
          {...props}
        >
          {options.map((opt) => (
            <option key={opt.value} value={opt.value}>
              {opt.label}
            </option>
          ))}
        </select>
        {error && <p className="mt-1 text-xs text-fem">{error}</p>}
      </div>
    );
  }
);
Select.displayName = 'Select';
