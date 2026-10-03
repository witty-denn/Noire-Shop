'use client';
import {createContext,useContext,useEffect,useMemo,useState} from 'react';
export type CartItem={id:string;name:string;price:number;image_url:string;quantity:number};
const C=createContext<any>(null);
export function CartProvider({children}:{children:React.ReactNode}){const [items,setItems]=useState<CartItem[]>([]);useEffect(()=>{try{setItems(JSON.parse(localStorage.getItem('noire-cart')||'[]'))}catch{}},[]);useEffect(()=>{localStorage.setItem('noire-cart',JSON.stringify(items))},[items]);const add=(p:any)=>setItems(x=>{const e=x.find(i=>i.id===p.id);return e?x.map(i=>i.id===p.id?{...i,quantity:i.quantity+1}:i):[...x,{...p,quantity:1}]});const remove=(id:string)=>setItems(x=>x.filter(i=>i.id!==id));const update=(id:string,q:number)=>setItems(x=>q<1?x.filter(i=>i.id!==id):x.map(i=>i.id===id?{...i,quantity:q}:i));const total=items.reduce((s,i)=>s+i.price*i.quantity,0);const value=useMemo(()=>({items,add,remove,update,total}),[items,total]);return <C.Provider value={value}>{children}</C.Provider>}
export const useCart=()=>useContext(C);
