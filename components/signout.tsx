'use client';
import {createClient} from '@/lib/supabase';
export default function SignOut(){return <button className="btn alt" onClick={async()=>{await createClient().auth.signOut();location.href='/'}}>Sign out</button>}
