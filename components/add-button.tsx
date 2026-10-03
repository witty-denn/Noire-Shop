'use client';
import {useCart} from './cart-provider';
export default function AddButton({product}:{product:any}){const {add}=useCart();return <button className="btn" onClick={()=>add(product)}>Add to bag</button>}
