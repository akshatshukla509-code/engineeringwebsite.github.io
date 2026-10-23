[index (2).html](https://github.com/user-attachments/files/33889590/index.2.html)
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover"><script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.min.js"></script><script src="config.js"></script><title>EngiHub</title>
<style>
:root{--bg:#f6f7fb;--sf:#fff;--tx:#1b1d2a;--mu:#6b7084;--ac:#5b3fd9;--ab:#ece8fd;--bd:#e3e5ee;--ok:#16a34a;box-sizing:border-box;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px);color-scheme:light}
@media(prefers-color-scheme:dark){:root:not([data-theme=light]){--bg:#12131a;--sf:#1b1d29;--tx:#eceef7;--mu:#9a9fb5;--ac:#9b87ff;--ab:#2a2547;--bd:#2c2f40;color-scheme:dark}}
html{scroll-padding-top:env(safe-area-inset-top,0px)}*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--tx);font:15px/1.5 Inter,system-ui,-apple-system,"Segoe UI",sans-serif}
header{position:sticky;top:0;z-index:5;background:var(--sf);border-bottom:1px solid var(--bd);display:flex;align-items:center;gap:12px;padding:10px 16px}
.logo{font-weight:800;font-size:19px;color:var(--ac);cursor:pointer}.sp{flex:1}
.app{display:flex;max-width:1200px;margin:0 auto}
nav{width:250px;flex:none;padding:14px 10px;position:sticky;top:56px;align-self:flex-start;max-height:calc(100vh - 56px);overflow:auto}
nav a{display:flex;gap:8px;padding:9px 12px;border-radius:10px;cursor:pointer;color:var(--mu);font-weight:500}
nav a:hover{background:var(--ab)}nav a.on{background:var(--ab);color:var(--ac);font-weight:700}
nav hr{border:0;border-top:1px solid var(--bd);margin:8px 0}
main{flex:1;min-width:0;padding:18px 16px 60px}
h1{font-size:24px;margin:0 0 4px}.mu{color:var(--mu);font-size:13px}
.tabs{display:flex;gap:6px;margin:14px 0;border-bottom:1px solid var(--bd);overflow-x:auto}
.tabs b{padding:9px 14px;cursor:pointer;color:var(--mu);border-bottom:3px solid transparent;white-space:nowrap}.tabs b.on{color:var(--ac);border-color:var(--ac)}
.card{background:var(--sf);border:1px solid var(--bd);border-radius:14px;padding:14px;margin:10px 0}
.row{display:flex;gap:12px;align-items:center}.row>.g{flex:1;min-width:0}
.vote{display:flex;flex-direction:column;align-items:center;min-width:44px;border:1px solid var(--bd);border-radius:10px;padding:4px;cursor:pointer;background:var(--sf);color:var(--mu);font-weight:700}
.vote.on{background:var(--ab);color:var(--ac);border-color:var(--ac)}
button,input,select,textarea{font:inherit;color:var(--tx)}
.btn{background:var(--ac);color:#fff;border:0;border-radius:10px;padding:9px 16px;font-weight:600;cursor:pointer}.btn.o{background:none;color:var(--ac);border:1px solid var(--ac)}
input,select,textarea{width:100%;background:var(--sf);border:1px solid var(--bd);border-radius:10px;padding:9px 12px;margin:4px 0 10px}
label{font-size:13px;font-weight:600}
.chips{display:flex;gap:6px;flex-wrap:wrap;margin-bottom:8px}.chips span{padding:4px 12px;border:1px solid var(--bd);border-radius:99px;cursor:pointer;font-size:13px;background:var(--sf)}.chips span.on{background:var(--ac);color:#fff;border-color:var(--ac)}
.tag{background:var(--ab);color:var(--ac);border-radius:6px;padding:1px 8px;font-size:12px;font-weight:600}
.auth{max-width:400px;margin:30px auto}.err{color:#dc2626;font-size:13px;min-height:18px}.okm{color:var(--ok);font-size:13px}
a.l{color:var(--ac);cursor:pointer;font-weight:600}
.rep{margin-left:22px;border-left:2px solid var(--bd);padding-left:12px}
@media(max-width:760px){.app{display:block}nav{width:auto;position:static;display:flex;overflow-x:auto;max-height:none;padding:8px}nav a{white-space:nowrap}nav hr{display:none}}
</style></head><body>
<header><span class="logo" onclick="go('home')">🎓 EngiHub</span><span class="sp"></span><span id="me"></span></header>
<div class="app"><nav id="nav"></nav><main id="main"></main></div>
<script>
const SUBS=["Basic Civil Engineering","Basic Electrical Engineering","Basic Mechanical Engineering","Basic Industrial & Production Engineering","Basic Mechatronics Engineering","Basic Computer Engineering","Basic Engineering Physics","Basic Engineering Chemistry","Basic Engineering Mathematics"];
const ICO=["🏗️","⚡","⚙️","🏭","🤖","💻","🔭","🧪","📐"];
const S={view:"home",tab:0,year:"All",sess:null,papers:[],votes:[],events:[],threads:[],db:null,uid:null,msg:"",ok:"",rec:""};
const $=id=>document.getElementById(id);
const esc=s=>String(s??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
const enc=new TextEncoder(),hex=b=>[...new Uint8Array(b)].map(x=>x.toString(16).padStart(2,"0")).join("");
async function hash(p,salt){const k=await crypto.subtle.importKey("raw",enc.encode(p),"PBKDF2",false,["deriveBits"]);return hex(await crypto.subtle.deriveBits({name:"PBKDF2",salt:enc.encode(salt),iterations:100000,hash:"SHA-256"},k,256))}
const rnd=n=>hex(crypto.getRandomValues(new Uint8Array(n)));
const day=d=>new Date().toISOString().slice(0,10)>d?1:0;
function go(v,sub){S.view=v;S.tab=0;S.year="All";S.msg=S.ok="";R();scrollTo(0,0)}
function R(){
 $("me").innerHTML=S.sess?`<span class="tag">@${esc(S.sess)}</span> <a class="l" onclick="out()">Log out</a>`:`<button class="btn" onclick="go('profile')">Log in</button>`;
 let n=`<a class="${S.view=="home"?"on":""}" onclick="go('home')">🏠 Home</a><hr>`;
 SUBS.forEach((s,i)=>n+=`<a class="${S.view==i?"on":""}" onclick="go(${i})">${ICO[i]} ${s.replace("Basic ","")}</a>`);
 n+=`<hr><a class="${S.view=="disc"?"on":""}" onclick="go('disc')">💬 Discussion</a><a class="${S.view=="ev"?"on":""}" onclick="go('ev')">📅 Events</a><a class="${S.view=="profile"?"on":""}" onclick="go('profile')">👤 Profile</a>`;
 $("nav").innerHTML=n;
 const v=S.view;$("main").innerHTML=v=="home"?home():v=="disc"?disc():v=="ev"?evs():v=="profile"?prof():subj(+v);
}
function home(){return`<h1>Welcome to EngiHub</h1><p class="mu">Previous-year question papers & solutions for first-year engineering. Browse freely — log in to upload, vote and post.</p>`+SUBS.map((s,i)=>`<div class="card row" style="cursor:pointer" onclick="go(${i})"><span style="font-size:26px">${ICO[i]}</span><div class="g"><b>${s}</b><div class="mu">${S.papers.filter(p=>p.sub==s).length} uploads</div></div>›</div>`).join("")}
function cnt(id){return S.votes.filter(v=>v.pid==id).length}
function subj(i){
 const s=SUBS[i],T=["Question Papers","Solutions","Upload"];
 let h=`<h1>${ICO[i]} ${s}</h1><div class="tabs">${T.map((t,k)=>`<b class="${S.tab==k?"on":""}" onclick="S.tab=${k};R()">${t}</b>`).join("")}</div>`;
 if(S.tab==2)return h+upl(s);
 const kind=S.tab==0?"paper":"sol",all=S.papers.filter(p=>p.sub==s&&p.kind==kind),ys=[...new Set(all.map(p=>p.year))].sort().reverse();
 h+=`<div class="chips">${["All",...ys].map(y=>`<span class="${S.year==y?"on":""}" onclick="S.year='${y}';R()">${y}</span>`).join("")}</div>`;
 const l=all.filter(p=>S.year=="All"||p.year==S.year).sort((a,b)=>cnt(b.id)-cnt(a.id)||b.t-a.t);
 if(!l.length)return h+`<div class="card mu">Nothing here yet. Be the first to upload!</div>`;
 return h+l.map(p=>{const my=S.votes.some(v=>v.pid==p.id&&v.user==S.sess);return`<div class="card row"><div class="vote ${my?"on":""}" onclick="vote('${p.id}')">▲<span>${cnt(p.id)}</span></div><div class="g"><b>${esc(p.title)}</b> <span class="tag">${esc(p.year)}</span><div class="mu">Uploaded by @${esc(p.by)}</div></div><a class="btn o" href="${esc(p.url)}" target="_blank" rel="noopener">View PDF</a></div>`}).join("")}
function upl(s){
 if(!S.sess)return`<div class="card">Please <a class="l" onclick="go('profile')">log in or create an account</a> to upload.</div>`;
 const yr=new Date().getFullYear();
 return`<div class="card"><label>Subject name</label><input id="u_s" value="${s}"><label>Type</label><select id="u_k"><option value="paper">Question paper</option><option value="sol">Solution</option></select><label>Year published</label><select id="u_y">${Array.from({length:20},(_,i)=>`<option>${yr-i}</option>`).join("")}</select><label>Title (e.g. End-Sem, Set A)</label><input id="u_t"><label>Uploader username</label><input value="${esc(S.sess)}" disabled><label>PDF file (max 20 MB)</label><input type="file" id="u_f" accept="application/pdf"><div class="err" id="u_e"></div><button class="btn" onclick="upload()">Upload</button></div>`}
async function vote(pid){
 if(!S.sess)return go("profile");
 const d=S.db.collection("votes").doc(pid+"_"+S.sess);
 try{S.votes.some(v=>v.pid==pid&&v.user==S.sess)?await d.delete():await d.set({pid,user:S.sess})}catch(e){}}
function disc(){
 const top=S.threads.filter(t=>!t.parent).sort((a,b)=>b.t-a.t);
 const box=(p)=>S.sess?`<textarea id="d_${p||"x"}" rows="2" placeholder="${p?"Reply…":"Share a thought with everyone…"}"></textarea><button class="btn" onclick="post('${p}')">${p?"Reply":"Post"}</button>`:`<span class="mu">Log in to post.</span>`;
 const node=t=>`<div class="card"><b>@${esc(t.by)}</b> <span class="mu">${new Date(t.t).toLocaleString()}</span><div style="white-space:pre-wrap">${esc(t.text)}</div><div class="rep">${S.threads.filter(r=>r.parent==t.id).sort((a,b)=>a.t-b.t).map(r=>`<div style="margin:8px 0"><b>@${esc(r.by)}</b> <span class="mu">${new Date(r.t).toLocaleString()}</span><div style="white-space:pre-wrap">${esc(r.text)}</div></div>`).join("")}${box(t.id)}</div></div>`;
 return`<h1>💬 Mega Thread</h1><p class="mu">One open thread for everything — doubts, tips, study groups.</p><div class="card">${box("")}</div>${top.map(node).join("")||'<div class="card mu">No posts yet.</div>'}`}
async function post(p){
 const el=$("d_"+(p||"x")),text=el.value.trim();if(!text)return;
 await S.db.collection("threads").doc(rnd(8)).set({text,by:S.sess,parent:p||"",t:Date.now()})}
function evs(){
 const td=new Date().toISOString().slice(0,10),live=S.events.filter(e=>e.end>=td);
 const up=live.filter(e=>e.start>td).sort((a,b)=>a.start<b.start?-1:1),on=live.filter(e=>e.start<=td).sort((a,b)=>a.end<b.end?-1:1);
 const c=e=>`<div class="card"><b>${esc(e.title)}</b><div>${esc(e.desc)}</div><div class="mu">${e.start} → ${e.end} · posted by @${esc(e.by)}</div></div>`;
 const form=S.sess?`<div class="card"><label>Event title</label><input id="e_t"><label>Description</label><textarea id="e_d" rows="2"></textarea><label>Start date</label><input type="date" id="e_s"><label>End date</label><input type="date" id="e_e"><div class="err" id="e_er"></div><button class="btn" onclick="addEv()">Publish event</button></div>`:`<div class="card">Log in to publish an event.</div>`;
 return`<h1>📅 Events</h1><h3>🟢 Ongoing</h3>${on.map(c).join("")||'<div class="card mu">None right now.</div>'}<h3>🕒 Upcoming</h3>${up.map(c).join("")||'<div class="card mu">None scheduled.</div>'}<h3>➕ Add an event</h3>${form}`}
async function addEv(){
 const t=$("e_t").value.trim(),s=$("e_s").value,e=$("e_e").value,er=$("e_er");
 if(!t||!s||!e)return er.textContent="Title, start and end dates are required.";if(e<s)return er.textContent="End date must be after start.";
 await S.db.collection("events").doc(rnd(8)).set({title:t,desc:$("e_d").value,start:s,end:e,by:S.sess,t:Date.now()})}
let mode="in";
function prof(){
 if(S.sess){const mine=S.papers.filter(p=>p.by==S.sess).length;return`<div class="card"><h1>@${esc(S.sess)}</h1><p class="mu">Only your username is visible to others; your email stays private.</p><p>${mine} uploads · ${S.votes.filter(v=>v.user==S.sess).length} votes given</p><button class="btn o" onclick="out()">Log out</button></div>`}
 if(S.rec)return`<div class="auth card"><h2>Account created 🎉</h2><p>Save this recovery code — it is the only way to reset your password:</p><h3 style="letter-spacing:2px">${S.rec}</h3><button class="btn" onclick="S.rec='';R()">I saved it</button></div>`;
 const f={in:`<label>Username</label><input id="a_u" autocomplete="username"><label>Password</label><input id="a_p" type="password" autocomplete="current-password"><div class="err">${S.msg}</div><button class="btn" style="width:100%" onclick="login()">Log in</button><p><a class="l" onclick="mode='fp';S.msg='';R()">Forgot password?</a> · <a class="l" onclick="mode='up';S.msg='';R()">Create account</a></p>`,
 up:`<label>Email</label><input id="a_e" type="email" autocomplete="email"><label>Username (unique, public)</label><input id="a_u" autocomplete="username"><label>Password (min 8)</label><input id="a_p" type="password" autocomplete="new-password"><div class="err">${S.msg}</div><button class="btn" style="width:100%" onclick="signup()">Sign up</button><p>Have an account? <a class="l" onclick="mode='in';S.msg='';R()">Log in</a></p>`,
 fp:`<p class="mu">Enter your username, the recovery code you got at sign-up, and a new password.</p><label>Username</label><input id="a_u"><label>Recovery code</label><input id="a_r"><label>New password</label><input id="a_p" type="password" autocomplete="new-password"><div class="err">${S.msg}</div><div class="okm">${S.ok}</div><button class="btn" style="width:100%" onclick="reset()">Reset password</button><p><a class="l" onclick="mode='in';S.msg='';R()">Back to log in</a></p>`}[mode];
 return`<div class="auth card"><h2>${{in:"Log in",up:"Create your account",fp:"Reset password"}[mode]}</h2>${f}</div>`}
function out(){S.sess=null;try{localStorage.removeItem("eh_sess")}catch(e){}go("home")}

const sb=supabase.createClient(CFG.URL,CFG.KEY);
const busy=()=>/INPUT|TEXTAREA|SELECT/.test(document.activeElement?.tagName),ts=s=>Date.parse(s);
async function load(force){try{
 const q=t=>sb.from(t).select("*"),[p,v,e,t]=await Promise.all([q("papers"),q("votes"),q("events"),q("threads")]);
 S.papers=(p.data||[]).map(r=>({id:r.id,sub:r.sub,kind:r.kind,year:r.year,title:r.title,by:r.username,url:sb.storage.from("papers").getPublicUrl(r.file_path).data.publicUrl,t:ts(r.created_at)}));
 S.votes=(v.data||[]).map(r=>({pid:r.pid,user:r.username}));
 S.events=(e.data||[]).map(r=>({id:r.id,title:r.title,desc:r.description,start:r.start_date,end:r.end_date,by:r.username,t:ts(r.created_at)}));
 S.threads=(t.data||[]).map(r=>({id:r.id,text:r.body,by:r.username,parent:r.parent_id||0,t:ts(r.created_at)}));
 if(force||!busy())R()}catch(x){}}
async function upload(){const f=$("u_f").files[0],e=$("u_e");if(!f||f.type!="application/pdf")return e.textContent="Choose a PDF file.";if(!$("u_t").value.trim())return e.textContent="Enter a title.";
 e.textContent="Uploading…";const path=S.uid+"/"+crypto.randomUUID()+".pdf";
 let r=await sb.storage.from("papers").upload(path,f,{contentType:"application/pdf"});if(r.error)return e.textContent=r.error.message;
 r=await sb.from("papers").insert({sub:$("u_s").value,kind:$("u_k").value,year:$("u_y").value,title:$("u_t").value.trim(),file_path:path});
 if(r.error)return e.textContent=r.error.message;S.tab=$("u_k").value=="paper"?0:1;await load(1)}
async function vote(id){if(!S.sess)return go("profile");const mine=S.votes.some(v=>v.pid==id&&v.user==S.sess);
 await (mine?sb.from("votes").delete().eq("pid",id).eq("user_id",S.uid):sb.from("votes").insert({pid:+id}));load(1)}
async function post(p){const el=$("d_"+(p||"x")),body=el.value.trim();if(!body)return;const r=await sb.from("threads").insert({body,parent_id:p?+p:null});r.error?alert(r.error.message):load(1)}
async function addEv(){const er=$("e_er"),t=$("e_t").value.trim(),s=$("e_s").value,e=$("e_e").value;if(!t||!s||!e)return er.textContent="Title, start and end dates are required.";if(e<s)return er.textContent="End date must be after start.";
 const r=await sb.from("events").insert({title:t,description:$("e_d").value,start_date:s,end_date:e});r.error?er.textContent=r.error.message:load(1)}
const val=id=>$(id).value.trim(),bad=m=>{S.msg=m;S.ok="";R()};
async function setUser(session){S.uid=session?.user.id||null;S.sess=null;
 if(S.uid){const r=await sb.from("profiles").select("username").eq("id",S.uid).single();S.sess=r.data?.username||null}R()}
async function signup(){const u=val("a_u"),email=val("a_e"),password=$("a_p").value;
 if(!/^[A-Za-z0-9_]{3,20}$/.test(u))return bad("Username: 3–20 letters, numbers or _");if(!/^\S+@\S+\.\S+$/.test(email))return bad("Enter a valid email");if(password.length<8)return bad("Password must be 8+ characters");
 if(!(await sb.rpc("username_available",{n:u})).data)return bad("That username is taken");
 const r=await sb.auth.signUp({email,password,options:{data:{username:u},emailRedirectTo:location.origin+location.pathname}});
 if(r.error)return bad(r.error.message);if(!r.data.session){mode="in";S.msg="";S.ok="Account created — confirm the link we emailed you, then log in.";R()}else go("home")}
async function login(){const r=await sb.auth.signInWithPassword({email:val("a_e"),password:$("a_p").value});r.error?bad("Wrong email or password"):go("home")}
async function forgot(){const r=await sb.auth.resetPasswordForEmail(val("a_e"),{redirectTo:location.origin+location.pathname});
 r.error?bad(r.error.message):(S.msg="",S.ok="If that email is registered, a reset link is on its way.",R())}
async function reset(){const p=$("a_p").value;if(p.length<8)return bad("Password must be 8+ characters");const r=await sb.auth.updateUser({password:p});
 if(r.error)return bad(r.error.message);S.recover=false;S.ok="Password updated.";go("home")}
async function out(){await sb.auth.signOut();go("home")}
function prof(){
 if(S.sess){const mine=S.papers.filter(p=>p.by==S.sess).length;return`<div class="card"><h1>@${esc(S.sess)}</h1><p class="mu">Only your username is visible to others; your email stays private.</p><p>${mine} uploads · ${S.votes.filter(v=>v.user==S.sess).length} votes given</p><button class="btn o" onclick="out()">Log out</button></div>`}
 const m=S.recover?"rs":mode,ok=S.ok?`<div class="okm">${S.ok}</div>`:"",er=`<div class="err">${S.msg}</div>`;
 const f={in:`<label>Email</label><input id="a_e" type="email" autocomplete="email"><label>Password</label><input id="a_p" type="password" autocomplete="current-password">${er}${ok}<button class="btn" style="width:100%" onclick="login()">Log in</button><p><a class="l" onclick="mode='fp';S.msg=S.ok='';R()">Forgot password?</a> · <a class="l" onclick="mode='up';S.msg=S.ok='';R()">Create account</a></p>`,
 up:`<label>Email (private)</label><input id="a_e" type="email" autocomplete="email"><label>Username (unique, public)</label><input id="a_u" autocomplete="username"><label>Password (min 8)</label><input id="a_p" type="password" autocomplete="new-password">${er}<button class="btn" style="width:100%" onclick="signup()">Sign up</button><p>Have an account? <a class="l" onclick="mode='in';S.msg='';R()">Log in</a></p>`,
 fp:`<p class="mu">Enter your account email and we'll send a reset link.</p><label>Email</label><input id="a_e" type="email">${er}${ok}<button class="btn" style="width:100%" onclick="forgot()">Send reset link</button><p><a class="l" onclick="mode='in';S.msg=S.ok='';R()">Back to log in</a></p>`,
 rs:`<label>New password (min 8)</label><input id="a_p" type="password" autocomplete="new-password">${er}<button class="btn" style="width:100%" onclick="reset()">Set new password</button>`}[m];
 return`<div class="auth card"><h2>${{in:"Log in",up:"Create your account",fp:"Forgot password",rs:"Choose a new password"}[m]}</h2>${f}</div>`}
sb.auth.onAuthStateChange((ev,s)=>{if(ev=="PASSWORD_RECOVERY"){S.recover=true;S.view="profile"}setTimeout(()=>setUser(s),0)});
(async()=>{R();await load(1);setInterval(()=>load(),15000)})();
</script></body></html>
