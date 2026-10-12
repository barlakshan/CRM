import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title: 'CRM UAT Manager', description: 'CRM pilot-run test case and execution management' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="en"><body>{children}</body></html>; }
