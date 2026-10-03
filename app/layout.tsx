import './globals.css';
import Link from 'next/link';
import { createClient } from '@/lib/supabase-server';
import { CartProvider } from '@/components/cart-provider';
export const metadata={title:'NOIRÉ — Modern essentials',description:'A contemporary fashion shop built for HNG15 Lesson 2'};
export default async function RootLayout({children}:{children:React.ReactNode}){const supabase=await createClient();const {data:{user}}=await supabase.auth.getUser();return <CartProvider><header className="nav"><div className="container" style={{display:'flex',alignItems:'center',justifyContent:'space-between'}}><Link className="brand" href="/">NOIRÉ</Link><nav className="navlinks"><Link href="/">Shop</Link><Link href="/#collection">Collection</Link><Link href="/orders">Orders</Link></nav><div className="navright"><Link className="pill" href="/cart">Bag</Link>{user?<Link className="pill" href="/orders">Account</Link>:<Link className="pill" href="/login">Sign in</Link>}</div></div></header>{children}<footer className="footer"><div className="container row"><span>© {new Date().getFullYear()} NOIRÉ</span><span>Built for HNG15 Lesson 2</span></div></footer></CartProvider>}
