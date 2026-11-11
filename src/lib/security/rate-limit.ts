const attempts = new Map<string,{count:number;start:number}>();
const WINDOW_MS=15*60*1000;
export function rateLimit(key:string,limit=8){
 const now=Date.now(); const entry=attempts.get(key);
 if(!entry||now-entry.start>=WINDOW_MS){attempts.set(key,{count:1,start:now});return {allowed:true,retryAfter:0}}
 if(entry.count>=limit)return {allowed:false,retryAfter:Math.ceil((WINDOW_MS-(now-entry.start))/1000)};
 entry.count++;return {allowed:true,retryAfter:0};
}
export function clientAddress(request:Request){return request.headers.get('x-forwarded-for')?.split(',')[0]?.trim()||request.headers.get('x-real-ip')||'unknown'}
