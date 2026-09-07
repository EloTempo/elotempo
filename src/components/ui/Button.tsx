import { ButtonHTMLAttributes, forwardRef } from 'react';
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = 'primary', size = 'md', ...props }, ref) => {
    const baseStyles = 'inline-flex items-center justify-center font-semibold rounded-raio-s transition-colors focus:outline-none focus:ring-2 focus:ring-acento/50 disabled:opacity-50 disabled:pointer-events-none whitespace-nowrap flex-none';
    
    const variants = {
      primary: 'bg-acento text-acento-tinta hover:bg-acento/90',
      secondary: 'bg-chip text-tinta hover:bg-sup border border-borda2',
      outline: 'border border-borda bg-transparent hover:bg-chip text-tinta',
      ghost: 'bg-transparent hover:bg-chip text-tinta',
    };
    
    const sizes = {
      sm: 'h-8 px-3 text-sm',
      md: 'h-10 px-4 py-2',
      lg: 'h-12 px-6 text-lg',
    };

    return (
      <button
        ref={ref}
        className={cn(baseStyles, variants[variant], sizes[size], className)}
        {...props}
      />
    );
  }
);
Button.displayName = 'Button';
