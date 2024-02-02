/******************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */
/* global Reflect, Promise, SuppressedError, Symbol */

var extendStatics = function(d, b) {
  extendStatics = Object.setPrototypeOf ||
      ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
      function (d, b) { for (var p in b) if (Object.prototype.hasOwnProperty.call(b, p)) d[p] = b[p]; };
  return extendStatics(d, b);
};

function __extends(d, b) {
  if (typeof b !== "function" && b !== null)
      throw new TypeError("Class extends value " + String(b) + " is not a constructor or null");
  extendStatics(d, b);
  function __() { this.constructor = d; }
  d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
}

function __decorate(decorators, target, key, desc) {
  var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
  if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
  else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
  return c > 3 && r && Object.defineProperty(target, key, r), r;
}

function __awaiter(thisArg, _arguments, P, generator) {
  function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
  return new (P || (P = Promise))(function (resolve, reject) {
      function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
      function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
      function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
      step((generator = generator.apply(thisArg, _arguments || [])).next());
  });
}

function __generator(thisArg, body) {
  var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
  return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
  function verb(n) { return function (v) { return step([n, v]); }; }
  function step(op) {
      if (f) throw new TypeError("Generator is already executing.");
      while (g && (g = 0, op[0] && (_ = 0)), _) try {
          if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
          if (y = 0, t) op = [op[0] & 2, t.value];
          switch (op[0]) {
              case 0: case 1: t = op; break;
              case 4: _.label++; return { value: op[1], done: false };
              case 5: _.label++; y = op[1]; op = [0]; continue;
              case 7: op = _.ops.pop(); _.trys.pop(); continue;
              default:
                  if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                  if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                  if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                  if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                  if (t[2]) _.ops.pop();
                  _.trys.pop(); continue;
          }
          op = body.call(thisArg, _);
      } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
      if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
  }
}

function __values(o) {
  var s = typeof Symbol === "function" && Symbol.iterator, m = s && o[s], i = 0;
  if (m) return m.call(o);
  if (o && typeof o.length === "number") return {
      next: function () {
          if (o && i >= o.length) o = void 0;
          return { value: o && o[i++], done: !o };
      }
  };
  throw new TypeError(s ? "Object is not iterable." : "Symbol.iterator is not defined.");
}

function __read(o, n) {
  var m = typeof Symbol === "function" && o[Symbol.iterator];
  if (!m) return o;
  var i = m.call(o), r, ar = [], e;
  try {
      while ((n === void 0 || n-- > 0) && !(r = i.next()).done) ar.push(r.value);
  }
  catch (error) { e = { error: error }; }
  finally {
      try {
          if (r && !r.done && (m = i["return"])) m.call(i);
      }
      finally { if (e) throw e.error; }
  }
  return ar;
}

function __spreadArray(to, from, pack) {
  if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
      if (ar || !(i in from)) {
          if (!ar) ar = Array.prototype.slice.call(from, 0, i);
          ar[i] = from[i];
      }
  }
  return to.concat(ar || Array.prototype.slice.call(from));
}

function __await(v) {
  return this instanceof __await ? (this.v = v, this) : new __await(v);
}

function __asyncGenerator(thisArg, _arguments, generator) {
  if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
  var g = generator.apply(thisArg, _arguments || []), i, q = [];
  return i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i;
  function verb(n) { if (g[n]) i[n] = function (v) { return new Promise(function (a, b) { q.push([n, v, a, b]) > 1 || resume(n, v); }); }; }
  function resume(n, v) { try { step(g[n](v)); } catch (e) { settle(q[0][3], e); } }
  function step(r) { r.value instanceof __await ? Promise.resolve(r.value.v).then(fulfill, reject) : settle(q[0][2], r); }
  function fulfill(value) { resume("next", value); }
  function reject(value) { resume("throw", value); }
  function settle(f, v) { if (f(v), q.shift(), q.length) resume(q[0][0], q[0][1]); }
}

function __asyncValues(o) {
  if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
  var m = o[Symbol.asyncIterator], i;
  return m ? m.call(o) : (o = typeof __values === "function" ? __values(o) : o[Symbol.iterator](), i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i);
  function verb(n) { i[n] = o[n] && function (v) { return new Promise(function (resolve, reject) { v = o[n](v), settle(resolve, reject, v.done, v.value); }); }; }
  function settle(resolve, reject, d, v) { Promise.resolve(v).then(function(v) { resolve({ value: v, done: d }); }, reject); }
}

typeof SuppressedError === "function" ? SuppressedError : function (error, suppressed, message) {
  var e = new Error(message);
  return e.name = "SuppressedError", e.error = error, e.suppressed = suppressed, e;
};

/**
 * @license
 * Copyright 2019 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */
const t$3=globalThis,e$3=t$3.ShadowRoot&&(void 0===t$3.ShadyCSS||t$3.ShadyCSS.nativeShadow)&&"adoptedStyleSheets"in Document.prototype&&"replace"in CSSStyleSheet.prototype,s$3=Symbol(),o$6=new WeakMap;let n$4 = class n{constructor(t,e,o){if(this._$cssResult$=!0,o!==s$3)throw Error("CSSResult is not constructable. Use `unsafeCSS` or `css` instead.");this.cssText=t,this.t=e;}get styleSheet(){let t=this.o;const s=this.t;if(e$3&&void 0===t){const e=void 0!==s&&1===s.length;e&&(t=o$6.get(s)),void 0===t&&((this.o=t=new CSSStyleSheet).replaceSync(this.cssText),e&&o$6.set(s,t));}return t}toString(){return this.cssText}};const r$5=t=>new n$4("string"==typeof t?t:t+"",void 0,s$3),i$3=(t,...e)=>{const o=1===t.length?t[0]:e.reduce(((e,s,o)=>e+(t=>{if(!0===t._$cssResult$)return t.cssText;if("number"==typeof t)return t;throw Error("Value passed to 'css' function must be a 'css' function result: "+t+". Use 'unsafeCSS' to pass non-literal values, but take care to ensure page security.")})(s)+t[o+1]),t[0]);return new n$4(o,t,s$3)},S$1=(s,o)=>{if(e$3)s.adoptedStyleSheets=o.map((t=>t instanceof CSSStyleSheet?t:t.styleSheet));else for(const e of o){const o=document.createElement("style"),n=t$3.litNonce;void 0!==n&&o.setAttribute("nonce",n),o.textContent=e.cssText,s.appendChild(o);}},c$3=e$3?t=>t:t=>t instanceof CSSStyleSheet?(t=>{let e="";for(const s of t.cssRules)e+=s.cssText;return r$5(e)})(t):t;

/**
 * @license
 * Copyright 2017 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */const {is:i$2,defineProperty:e$2,getOwnPropertyDescriptor:r$4,getOwnPropertyNames:h$2,getOwnPropertySymbols:o$5,getPrototypeOf:n$3}=Object,a$1=globalThis,c$2=a$1.trustedTypes,l$1=c$2?c$2.emptyScript:"",p$1=a$1.reactiveElementPolyfillSupport,d$1=(t,s)=>t,u$1={toAttribute(t,s){switch(s){case Boolean:t=t?l$1:null;break;case Object:case Array:t=null==t?t:JSON.stringify(t);}return t},fromAttribute(t,s){let i=t;switch(s){case Boolean:i=null!==t;break;case Number:i=null===t?null:Number(t);break;case Object:case Array:try{i=JSON.parse(t);}catch(t){i=null;}}return i}},f$3=(t,s)=>!i$2(t,s),y$1={attribute:!0,type:String,converter:u$1,reflect:!1,hasChanged:f$3};Symbol.metadata??=Symbol("metadata"),a$1.litPropertyMetadata??=new WeakMap;let b$1 = class b extends HTMLElement{static addInitializer(t){this._$Ei(),(this.l??=[]).push(t);}static get observedAttributes(){return this.finalize(),this._$Eh&&[...this._$Eh.keys()]}static createProperty(t,s=y$1){if(s.state&&(s.attribute=!1),this._$Ei(),this.elementProperties.set(t,s),!s.noAccessor){const i=Symbol(),r=this.getPropertyDescriptor(t,i,s);void 0!==r&&e$2(this.prototype,t,r);}}static getPropertyDescriptor(t,s,i){const{get:e,set:h}=r$4(this.prototype,t)??{get(){return this[s]},set(t){this[s]=t;}};return {get(){return e?.call(this)},set(s){const r=e?.call(this);h.call(this,s),this.requestUpdate(t,r,i);},configurable:!0,enumerable:!0}}static getPropertyOptions(t){return this.elementProperties.get(t)??y$1}static _$Ei(){if(this.hasOwnProperty(d$1("elementProperties")))return;const t=n$3(this);t.finalize(),void 0!==t.l&&(this.l=[...t.l]),this.elementProperties=new Map(t.elementProperties);}static finalize(){if(this.hasOwnProperty(d$1("finalized")))return;if(this.finalized=!0,this._$Ei(),this.hasOwnProperty(d$1("properties"))){const t=this.properties,s=[...h$2(t),...o$5(t)];for(const i of s)this.createProperty(i,t[i]);}const t=this[Symbol.metadata];if(null!==t){const s=litPropertyMetadata.get(t);if(void 0!==s)for(const[t,i]of s)this.elementProperties.set(t,i);}this._$Eh=new Map;for(const[t,s]of this.elementProperties){const i=this._$Eu(t,s);void 0!==i&&this._$Eh.set(i,t);}this.elementStyles=this.finalizeStyles(this.styles);}static finalizeStyles(s){const i=[];if(Array.isArray(s)){const e=new Set(s.flat(1/0).reverse());for(const s of e)i.unshift(c$3(s));}else void 0!==s&&i.push(c$3(s));return i}static _$Eu(t,s){const i=s.attribute;return !1===i?void 0:"string"==typeof i?i:"string"==typeof t?t.toLowerCase():void 0}constructor(){super(),this._$Ep=void 0,this.isUpdatePending=!1,this.hasUpdated=!1,this._$Em=null,this._$Ev();}_$Ev(){this._$Eg=new Promise((t=>this.enableUpdating=t)),this._$AL=new Map,this._$ES(),this.requestUpdate(),this.constructor.l?.forEach((t=>t(this)));}addController(t){(this._$E_??=new Set).add(t),void 0!==this.renderRoot&&this.isConnected&&t.hostConnected?.();}removeController(t){this._$E_?.delete(t);}_$ES(){const t=new Map,s=this.constructor.elementProperties;for(const i of s.keys())this.hasOwnProperty(i)&&(t.set(i,this[i]),delete this[i]);t.size>0&&(this._$Ep=t);}createRenderRoot(){const t=this.shadowRoot??this.attachShadow(this.constructor.shadowRootOptions);return S$1(t,this.constructor.elementStyles),t}connectedCallback(){this.renderRoot??=this.createRenderRoot(),this.enableUpdating(!0),this._$E_?.forEach((t=>t.hostConnected?.()));}enableUpdating(t){}disconnectedCallback(){this._$E_?.forEach((t=>t.hostDisconnected?.()));}attributeChangedCallback(t,s,i){this._$AK(t,i);}_$EO(t,s){const i=this.constructor.elementProperties.get(t),e=this.constructor._$Eu(t,i);if(void 0!==e&&!0===i.reflect){const r=(void 0!==i.converter?.toAttribute?i.converter:u$1).toAttribute(s,i.type);this._$Em=t,null==r?this.removeAttribute(e):this.setAttribute(e,r),this._$Em=null;}}_$AK(t,s){const i=this.constructor,e=i._$Eh.get(t);if(void 0!==e&&this._$Em!==e){const t=i.getPropertyOptions(e),r="function"==typeof t.converter?{fromAttribute:t.converter}:void 0!==t.converter?.fromAttribute?t.converter:u$1;this._$Em=e,this[e]=r.fromAttribute(s,t.type),this._$Em=null;}}requestUpdate(t,s,i){if(void 0!==t){if(i??=this.constructor.getPropertyOptions(t),!(i.hasChanged??f$3)(this[t],s))return;this.C(t,s,i);}!1===this.isUpdatePending&&(this._$Eg=this._$EP());}C(t,s,i){this._$AL.has(t)||this._$AL.set(t,s),!0===i.reflect&&this._$Em!==t&&(this._$ET??=new Set).add(t);}async _$EP(){this.isUpdatePending=!0;try{await this._$Eg;}catch(t){Promise.reject(t);}const t=this.scheduleUpdate();return null!=t&&await t,!this.isUpdatePending}scheduleUpdate(){return this.performUpdate()}performUpdate(){if(!this.isUpdatePending)return;if(!this.hasUpdated){if(this.renderRoot??=this.createRenderRoot(),this._$Ep){for(const[t,s]of this._$Ep)this[t]=s;this._$Ep=void 0;}const t=this.constructor.elementProperties;if(t.size>0)for(const[s,i]of t)!0!==i.wrapped||this._$AL.has(s)||void 0===this[s]||this.C(s,this[s],i);}let t=!1;const s=this._$AL;try{t=this.shouldUpdate(s),t?(this.willUpdate(s),this._$E_?.forEach((t=>t.hostUpdate?.())),this.update(s)):this._$Ej();}catch(s){throw t=!1,this._$Ej(),s}t&&this._$AE(s);}willUpdate(t){}_$AE(t){this._$E_?.forEach((t=>t.hostUpdated?.())),this.hasUpdated||(this.hasUpdated=!0,this.firstUpdated(t)),this.updated(t);}_$Ej(){this._$AL=new Map,this.isUpdatePending=!1;}get updateComplete(){return this.getUpdateComplete()}getUpdateComplete(){return this._$Eg}shouldUpdate(t){return !0}update(t){this._$ET&&=this._$ET.forEach((t=>this._$EO(t,this[t]))),this._$Ej();}updated(t){}firstUpdated(t){}};b$1.elementStyles=[],b$1.shadowRootOptions={mode:"open"},b$1[d$1("elementProperties")]=new Map,b$1[d$1("finalized")]=new Map,p$1?.({ReactiveElement:b$1}),(a$1.reactiveElementVersions??=[]).push("2.0.3");

/**
 * @license
 * Copyright 2017 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */
const t$2=globalThis,i$1=t$2.trustedTypes,s$2=i$1?i$1.createPolicy("lit-html",{createHTML:t=>t}):void 0,e$1="$lit$",h$1=`lit$${(Math.random()+"").slice(9)}$`,o$4="?"+h$1,n$2=`<${o$4}>`,r$3=document,l=()=>r$3.createComment(""),c$1=t=>null===t||"object"!=typeof t&&"function"!=typeof t,a=Array.isArray,u=t=>a(t)||"function"==typeof t?.[Symbol.iterator],d="[ \t\n\f\r]",f$2=/<(?:(!--|\/[^a-zA-Z])|(\/?[a-zA-Z][^>\s]*)|(\/?$))/g,v=/-->/g,_=/>/g,m=RegExp(`>|${d}(?:([^\\s"'>=/]+)(${d}*=${d}*(?:[^ \t\n\f\r"'\`<>=]|("|')|))|$)`,"g"),p=/'/g,g=/"/g,$=/^(?:script|style|textarea|title)$/i,y=t=>(i,...s)=>({_$litType$:t,strings:i,values:s}),x=y(1),b=y(2),w=Symbol.for("lit-noChange"),T=Symbol.for("lit-nothing"),A=new WeakMap,E=r$3.createTreeWalker(r$3,129);function C(t,i){if(!Array.isArray(t)||!t.hasOwnProperty("raw"))throw Error("invalid template strings array");return void 0!==s$2?s$2.createHTML(i):i}const P=(t,i)=>{const s=t.length-1,o=[];let r,l=2===i?"<svg>":"",c=f$2;for(let i=0;i<s;i++){const s=t[i];let a,u,d=-1,y=0;for(;y<s.length&&(c.lastIndex=y,u=c.exec(s),null!==u);)y=c.lastIndex,c===f$2?"!--"===u[1]?c=v:void 0!==u[1]?c=_:void 0!==u[2]?($.test(u[2])&&(r=RegExp("</"+u[2],"g")),c=m):void 0!==u[3]&&(c=m):c===m?">"===u[0]?(c=r??f$2,d=-1):void 0===u[1]?d=-2:(d=c.lastIndex-u[2].length,a=u[1],c=void 0===u[3]?m:'"'===u[3]?g:p):c===g||c===p?c=m:c===v||c===_?c=f$2:(c=m,r=void 0);const x=c===m&&t[i+1].startsWith("/>")?" ":"";l+=c===f$2?s+n$2:d>=0?(o.push(a),s.slice(0,d)+e$1+s.slice(d)+h$1+x):s+h$1+(-2===d?i:x);}return [C(t,l+(t[s]||"<?>")+(2===i?"</svg>":"")),o]};class V{constructor({strings:t,_$litType$:s},n){let r;this.parts=[];let c=0,a=0;const u=t.length-1,d=this.parts,[f,v]=P(t,s);if(this.el=V.createElement(f,n),E.currentNode=this.el.content,2===s){const t=this.el.content.firstChild;t.replaceWith(...t.childNodes);}for(;null!==(r=E.nextNode())&&d.length<u;){if(1===r.nodeType){if(r.hasAttributes())for(const t of r.getAttributeNames())if(t.endsWith(e$1)){const i=v[a++],s=r.getAttribute(t).split(h$1),e=/([.?@])?(.*)/.exec(i);d.push({type:1,index:c,name:e[2],strings:s,ctor:"."===e[1]?k:"?"===e[1]?H:"@"===e[1]?I:R}),r.removeAttribute(t);}else t.startsWith(h$1)&&(d.push({type:6,index:c}),r.removeAttribute(t));if($.test(r.tagName)){const t=r.textContent.split(h$1),s=t.length-1;if(s>0){r.textContent=i$1?i$1.emptyScript:"";for(let i=0;i<s;i++)r.append(t[i],l()),E.nextNode(),d.push({type:2,index:++c});r.append(t[s],l());}}}else if(8===r.nodeType)if(r.data===o$4)d.push({type:2,index:c});else {let t=-1;for(;-1!==(t=r.data.indexOf(h$1,t+1));)d.push({type:7,index:c}),t+=h$1.length-1;}c++;}}static createElement(t,i){const s=r$3.createElement("template");return s.innerHTML=t,s}}function N(t,i,s=t,e){if(i===w)return i;let h=void 0!==e?s._$Co?.[e]:s._$Cl;const o=c$1(i)?void 0:i._$litDirective$;return h?.constructor!==o&&(h?._$AO?.(!1),void 0===o?h=void 0:(h=new o(t),h._$AT(t,s,e)),void 0!==e?(s._$Co??=[])[e]=h:s._$Cl=h),void 0!==h&&(i=N(t,h._$AS(t,i.values),h,e)),i}class S{constructor(t,i){this._$AV=[],this._$AN=void 0,this._$AD=t,this._$AM=i;}get parentNode(){return this._$AM.parentNode}get _$AU(){return this._$AM._$AU}u(t){const{el:{content:i},parts:s}=this._$AD,e=(t?.creationScope??r$3).importNode(i,!0);E.currentNode=e;let h=E.nextNode(),o=0,n=0,l=s[0];for(;void 0!==l;){if(o===l.index){let i;2===l.type?i=new M(h,h.nextSibling,this,t):1===l.type?i=new l.ctor(h,l.name,l.strings,this,t):6===l.type&&(i=new L(h,this,t)),this._$AV.push(i),l=s[++n];}o!==l?.index&&(h=E.nextNode(),o++);}return E.currentNode=r$3,e}p(t){let i=0;for(const s of this._$AV)void 0!==s&&(void 0!==s.strings?(s._$AI(t,s,i),i+=s.strings.length-2):s._$AI(t[i])),i++;}}class M{get _$AU(){return this._$AM?._$AU??this._$Cv}constructor(t,i,s,e){this.type=2,this._$AH=T,this._$AN=void 0,this._$AA=t,this._$AB=i,this._$AM=s,this.options=e,this._$Cv=e?.isConnected??!0;}get parentNode(){let t=this._$AA.parentNode;const i=this._$AM;return void 0!==i&&11===t?.nodeType&&(t=i.parentNode),t}get startNode(){return this._$AA}get endNode(){return this._$AB}_$AI(t,i=this){t=N(this,t,i),c$1(t)?t===T||null==t||""===t?(this._$AH!==T&&this._$AR(),this._$AH=T):t!==this._$AH&&t!==w&&this._(t):void 0!==t._$litType$?this.g(t):void 0!==t.nodeType?this.$(t):u(t)?this.T(t):this._(t);}k(t){return this._$AA.parentNode.insertBefore(t,this._$AB)}$(t){this._$AH!==t&&(this._$AR(),this._$AH=this.k(t));}_(t){this._$AH!==T&&c$1(this._$AH)?this._$AA.nextSibling.data=t:this.$(r$3.createTextNode(t)),this._$AH=t;}g(t){const{values:i,_$litType$:s}=t,e="number"==typeof s?this._$AC(t):(void 0===s.el&&(s.el=V.createElement(C(s.h,s.h[0]),this.options)),s);if(this._$AH?._$AD===e)this._$AH.p(i);else {const t=new S(e,this),s=t.u(this.options);t.p(i),this.$(s),this._$AH=t;}}_$AC(t){let i=A.get(t.strings);return void 0===i&&A.set(t.strings,i=new V(t)),i}T(t){a(this._$AH)||(this._$AH=[],this._$AR());const i=this._$AH;let s,e=0;for(const h of t)e===i.length?i.push(s=new M(this.k(l()),this.k(l()),this,this.options)):s=i[e],s._$AI(h),e++;e<i.length&&(this._$AR(s&&s._$AB.nextSibling,e),i.length=e);}_$AR(t=this._$AA.nextSibling,i){for(this._$AP?.(!1,!0,i);t&&t!==this._$AB;){const i=t.nextSibling;t.remove(),t=i;}}setConnected(t){void 0===this._$AM&&(this._$Cv=t,this._$AP?.(t));}}class R{get tagName(){return this.element.tagName}get _$AU(){return this._$AM._$AU}constructor(t,i,s,e,h){this.type=1,this._$AH=T,this._$AN=void 0,this.element=t,this.name=i,this._$AM=e,this.options=h,s.length>2||""!==s[0]||""!==s[1]?(this._$AH=Array(s.length-1).fill(new String),this.strings=s):this._$AH=T;}_$AI(t,i=this,s,e){const h=this.strings;let o=!1;if(void 0===h)t=N(this,t,i,0),o=!c$1(t)||t!==this._$AH&&t!==w,o&&(this._$AH=t);else {const e=t;let n,r;for(t=h[0],n=0;n<h.length-1;n++)r=N(this,e[s+n],i,n),r===w&&(r=this._$AH[n]),o||=!c$1(r)||r!==this._$AH[n],r===T?t=T:t!==T&&(t+=(r??"")+h[n+1]),this._$AH[n]=r;}o&&!e&&this.O(t);}O(t){t===T?this.element.removeAttribute(this.name):this.element.setAttribute(this.name,t??"");}}class k extends R{constructor(){super(...arguments),this.type=3;}O(t){this.element[this.name]=t===T?void 0:t;}}class H extends R{constructor(){super(...arguments),this.type=4;}O(t){this.element.toggleAttribute(this.name,!!t&&t!==T);}}class I extends R{constructor(t,i,s,e,h){super(t,i,s,e,h),this.type=5;}_$AI(t,i=this){if((t=N(this,t,i,0)??T)===w)return;const s=this._$AH,e=t===T&&s!==T||t.capture!==s.capture||t.once!==s.once||t.passive!==s.passive,h=t!==T&&(s===T||e);e&&this.element.removeEventListener(this.name,this,s),h&&this.element.addEventListener(this.name,this,t),this._$AH=t;}handleEvent(t){"function"==typeof this._$AH?this._$AH.call(this.options?.host??this.element,t):this._$AH.handleEvent(t);}}class L{constructor(t,i,s){this.element=t,this.type=6,this._$AN=void 0,this._$AM=i,this.options=s;}get _$AU(){return this._$AM._$AU}_$AI(t){N(this,t);}}const z={j:e$1,P:h$1,A:o$4,C:1,M:P,L:S,R:u,V:N,D:M,I:R,H,N:I,U:k,B:L},Z=t$2.litHtmlPolyfillSupport;Z?.(V,M),(t$2.litHtmlVersions??=[]).push("3.1.1");const j=(t,i,s)=>{const e=s?.renderBefore??i;let h=e._$litPart$;if(void 0===h){const t=s?.renderBefore??null;e._$litPart$=h=new M(i.insertBefore(l(),t),t,void 0,s??{});}return h._$AI(t),h};

/**
 * @license
 * Copyright 2017 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */let s$1 = class s extends b$1{constructor(){super(...arguments),this.renderOptions={host:this},this._$Do=void 0;}createRenderRoot(){const t=super.createRenderRoot();return this.renderOptions.renderBefore??=t.firstChild,t}update(t){const i=this.render();this.hasUpdated||(this.renderOptions.isConnected=this.isConnected),super.update(t),this._$Do=j(i,this.renderRoot,this.renderOptions);}connectedCallback(){super.connectedCallback(),this._$Do?.setConnected(!0);}disconnectedCallback(){super.disconnectedCallback(),this._$Do?.setConnected(!1);}render(){return w}};s$1._$litElement$=!0,s$1[("finalized")]=!0,globalThis.litElementHydrateSupport?.({LitElement:s$1});const r$2=globalThis.litElementPolyfillSupport;r$2?.({LitElement:s$1});const o$3={_$AK:(t,e,i)=>{t._$AK(e,i);},_$AL:t=>t._$AL};(globalThis.litElementVersions??=[]).push("4.0.3");

/**
 * @license
 * Copyright 2022 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */
const o$2=!1;

/**
 * @license
 * Copyright 2017 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */
const t$1=t=>(e,o)=>{void 0!==o?o.addInitializer((()=>{customElements.define(t,e);})):customElements.define(t,e);};

/**
 * @license
 * Copyright 2017 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */const o$1={attribute:!0,type:String,converter:u$1,reflect:!1,hasChanged:f$3},r$1=(t=o$1,e,r)=>{const{kind:n,metadata:i}=r;let s=globalThis.litPropertyMetadata.get(i);if(void 0===s&&globalThis.litPropertyMetadata.set(i,s=new Map),s.set(r.name,t),"accessor"===n){const{name:o}=r;return {set(r){const n=e.get.call(this);e.set.call(this,r),this.requestUpdate(o,n,t);},init(e){return void 0!==e&&this.C(o,void 0,t),e}}}if("setter"===n){const{name:o}=r;return function(r){const n=this[o];e.call(this,r),this.requestUpdate(o,n,t);}}throw Error("Unsupported decorator location: "+n)};function n$1(t){return (e,o)=>"object"==typeof o?r$1(t,e,o):((t,e,o)=>{const r=e.hasOwnProperty(o);return e.constructor.createProperty(o,r?{...t,wrapped:!0}:t),r?Object.getOwnPropertyDescriptor(e,o):void 0})(t,e,o)}

function isFunction(value) {
    return typeof value === 'function';
}

function createErrorClass(createImpl) {
    var _super = function (instance) {
        Error.call(instance);
        instance.stack = new Error().stack;
    };
    var ctorFunc = createImpl(_super);
    ctorFunc.prototype = Object.create(Error.prototype);
    ctorFunc.prototype.constructor = ctorFunc;
    return ctorFunc;
}

var UnsubscriptionError = createErrorClass(function (_super) {
    return function UnsubscriptionErrorImpl(errors) {
        _super(this);
        this.message = errors
            ? errors.length + " errors occurred during unsubscription:\n" + errors.map(function (err, i) { return i + 1 + ") " + err.toString(); }).join('\n  ')
            : '';
        this.name = 'UnsubscriptionError';
        this.errors = errors;
    };
});

function arrRemove(arr, item) {
    if (arr) {
        var index = arr.indexOf(item);
        0 <= index && arr.splice(index, 1);
    }
}

var Subscription = (function () {
    function Subscription(initialTeardown) {
        this.initialTeardown = initialTeardown;
        this.closed = false;
        this._parentage = null;
        this._finalizers = null;
    }
    Subscription.prototype.unsubscribe = function () {
        var e_1, _a, e_2, _b;
        var errors;
        if (!this.closed) {
            this.closed = true;
            var _parentage = this._parentage;
            if (_parentage) {
                this._parentage = null;
                if (Array.isArray(_parentage)) {
                    try {
                        for (var _parentage_1 = __values(_parentage), _parentage_1_1 = _parentage_1.next(); !_parentage_1_1.done; _parentage_1_1 = _parentage_1.next()) {
                            var parent_1 = _parentage_1_1.value;
                            parent_1.remove(this);
                        }
                    }
                    catch (e_1_1) { e_1 = { error: e_1_1 }; }
                    finally {
                        try {
                            if (_parentage_1_1 && !_parentage_1_1.done && (_a = _parentage_1.return)) _a.call(_parentage_1);
                        }
                        finally { if (e_1) throw e_1.error; }
                    }
                }
                else {
                    _parentage.remove(this);
                }
            }
            var initialFinalizer = this.initialTeardown;
            if (isFunction(initialFinalizer)) {
                try {
                    initialFinalizer();
                }
                catch (e) {
                    errors = e instanceof UnsubscriptionError ? e.errors : [e];
                }
            }
            var _finalizers = this._finalizers;
            if (_finalizers) {
                this._finalizers = null;
                try {
                    for (var _finalizers_1 = __values(_finalizers), _finalizers_1_1 = _finalizers_1.next(); !_finalizers_1_1.done; _finalizers_1_1 = _finalizers_1.next()) {
                        var finalizer = _finalizers_1_1.value;
                        try {
                            execFinalizer(finalizer);
                        }
                        catch (err) {
                            errors = errors !== null && errors !== void 0 ? errors : [];
                            if (err instanceof UnsubscriptionError) {
                                errors = __spreadArray(__spreadArray([], __read(errors)), __read(err.errors));
                            }
                            else {
                                errors.push(err);
                            }
                        }
                    }
                }
                catch (e_2_1) { e_2 = { error: e_2_1 }; }
                finally {
                    try {
                        if (_finalizers_1_1 && !_finalizers_1_1.done && (_b = _finalizers_1.return)) _b.call(_finalizers_1);
                    }
                    finally { if (e_2) throw e_2.error; }
                }
            }
            if (errors) {
                throw new UnsubscriptionError(errors);
            }
        }
    };
    Subscription.prototype.add = function (teardown) {
        var _a;
        if (teardown && teardown !== this) {
            if (this.closed) {
                execFinalizer(teardown);
            }
            else {
                if (teardown instanceof Subscription) {
                    if (teardown.closed || teardown._hasParent(this)) {
                        return;
                    }
                    teardown._addParent(this);
                }
                (this._finalizers = (_a = this._finalizers) !== null && _a !== void 0 ? _a : []).push(teardown);
            }
        }
    };
    Subscription.prototype._hasParent = function (parent) {
        var _parentage = this._parentage;
        return _parentage === parent || (Array.isArray(_parentage) && _parentage.includes(parent));
    };
    Subscription.prototype._addParent = function (parent) {
        var _parentage = this._parentage;
        this._parentage = Array.isArray(_parentage) ? (_parentage.push(parent), _parentage) : _parentage ? [_parentage, parent] : parent;
    };
    Subscription.prototype._removeParent = function (parent) {
        var _parentage = this._parentage;
        if (_parentage === parent) {
            this._parentage = null;
        }
        else if (Array.isArray(_parentage)) {
            arrRemove(_parentage, parent);
        }
    };
    Subscription.prototype.remove = function (teardown) {
        var _finalizers = this._finalizers;
        _finalizers && arrRemove(_finalizers, teardown);
        if (teardown instanceof Subscription) {
            teardown._removeParent(this);
        }
    };
    Subscription.EMPTY = (function () {
        var empty = new Subscription();
        empty.closed = true;
        return empty;
    })();
    return Subscription;
}());
var EMPTY_SUBSCRIPTION = Subscription.EMPTY;
function isSubscription(value) {
    return (value instanceof Subscription ||
        (value && 'closed' in value && isFunction(value.remove) && isFunction(value.add) && isFunction(value.unsubscribe)));
}
function execFinalizer(finalizer) {
    if (isFunction(finalizer)) {
        finalizer();
    }
    else {
        finalizer.unsubscribe();
    }
}

var config = {
    onUnhandledError: null,
    onStoppedNotification: null,
    Promise: undefined,
    useDeprecatedSynchronousErrorHandling: false,
    useDeprecatedNextContext: false,
};

var timeoutProvider = {
    setTimeout: function (handler, timeout) {
        var args = [];
        for (var _i = 2; _i < arguments.length; _i++) {
            args[_i - 2] = arguments[_i];
        }
        return setTimeout.apply(void 0, __spreadArray([handler, timeout], __read(args)));
    },
    clearTimeout: function (handle) {
        var delegate = timeoutProvider.delegate;
        return ((delegate === null || delegate === void 0 ? void 0 : delegate.clearTimeout) || clearTimeout)(handle);
    },
    delegate: undefined,
};

function reportUnhandledError(err) {
    timeoutProvider.setTimeout(function () {
        {
            throw err;
        }
    });
}

function noop() { }

function errorContext(cb) {
    {
        cb();
    }
}

var Subscriber = (function (_super) {
    __extends(Subscriber, _super);
    function Subscriber(destination) {
        var _this = _super.call(this) || this;
        _this.isStopped = false;
        if (destination) {
            _this.destination = destination;
            if (isSubscription(destination)) {
                destination.add(_this);
            }
        }
        else {
            _this.destination = EMPTY_OBSERVER;
        }
        return _this;
    }
    Subscriber.create = function (next, error, complete) {
        return new SafeSubscriber(next, error, complete);
    };
    Subscriber.prototype.next = function (value) {
        if (this.isStopped) ;
        else {
            this._next(value);
        }
    };
    Subscriber.prototype.error = function (err) {
        if (this.isStopped) ;
        else {
            this.isStopped = true;
            this._error(err);
        }
    };
    Subscriber.prototype.complete = function () {
        if (this.isStopped) ;
        else {
            this.isStopped = true;
            this._complete();
        }
    };
    Subscriber.prototype.unsubscribe = function () {
        if (!this.closed) {
            this.isStopped = true;
            _super.prototype.unsubscribe.call(this);
            this.destination = null;
        }
    };
    Subscriber.prototype._next = function (value) {
        this.destination.next(value);
    };
    Subscriber.prototype._error = function (err) {
        try {
            this.destination.error(err);
        }
        finally {
            this.unsubscribe();
        }
    };
    Subscriber.prototype._complete = function () {
        try {
            this.destination.complete();
        }
        finally {
            this.unsubscribe();
        }
    };
    return Subscriber;
}(Subscription));
var _bind = Function.prototype.bind;
function bind(fn, thisArg) {
    return _bind.call(fn, thisArg);
}
var ConsumerObserver = (function () {
    function ConsumerObserver(partialObserver) {
        this.partialObserver = partialObserver;
    }
    ConsumerObserver.prototype.next = function (value) {
        var partialObserver = this.partialObserver;
        if (partialObserver.next) {
            try {
                partialObserver.next(value);
            }
            catch (error) {
                handleUnhandledError(error);
            }
        }
    };
    ConsumerObserver.prototype.error = function (err) {
        var partialObserver = this.partialObserver;
        if (partialObserver.error) {
            try {
                partialObserver.error(err);
            }
            catch (error) {
                handleUnhandledError(error);
            }
        }
        else {
            handleUnhandledError(err);
        }
    };
    ConsumerObserver.prototype.complete = function () {
        var partialObserver = this.partialObserver;
        if (partialObserver.complete) {
            try {
                partialObserver.complete();
            }
            catch (error) {
                handleUnhandledError(error);
            }
        }
    };
    return ConsumerObserver;
}());
var SafeSubscriber = (function (_super) {
    __extends(SafeSubscriber, _super);
    function SafeSubscriber(observerOrNext, error, complete) {
        var _this = _super.call(this) || this;
        var partialObserver;
        if (isFunction(observerOrNext) || !observerOrNext) {
            partialObserver = {
                next: (observerOrNext !== null && observerOrNext !== void 0 ? observerOrNext : undefined),
                error: error !== null && error !== void 0 ? error : undefined,
                complete: complete !== null && complete !== void 0 ? complete : undefined,
            };
        }
        else {
            var context_1;
            if (_this && config.useDeprecatedNextContext) {
                context_1 = Object.create(observerOrNext);
                context_1.unsubscribe = function () { return _this.unsubscribe(); };
                partialObserver = {
                    next: observerOrNext.next && bind(observerOrNext.next, context_1),
                    error: observerOrNext.error && bind(observerOrNext.error, context_1),
                    complete: observerOrNext.complete && bind(observerOrNext.complete, context_1),
                };
            }
            else {
                partialObserver = observerOrNext;
            }
        }
        _this.destination = new ConsumerObserver(partialObserver);
        return _this;
    }
    return SafeSubscriber;
}(Subscriber));
function handleUnhandledError(error) {
    {
        reportUnhandledError(error);
    }
}
function defaultErrorHandler(err) {
    throw err;
}
var EMPTY_OBSERVER = {
    closed: true,
    next: noop,
    error: defaultErrorHandler,
    complete: noop,
};

var observable = (function () { return (typeof Symbol === 'function' && Symbol.observable) || '@@observable'; })();

function identity(x) {
    return x;
}

function pipeFromArray(fns) {
    if (fns.length === 0) {
        return identity;
    }
    if (fns.length === 1) {
        return fns[0];
    }
    return function piped(input) {
        return fns.reduce(function (prev, fn) { return fn(prev); }, input);
    };
}

var Observable = (function () {
    function Observable(subscribe) {
        if (subscribe) {
            this._subscribe = subscribe;
        }
    }
    Observable.prototype.lift = function (operator) {
        var observable = new Observable();
        observable.source = this;
        observable.operator = operator;
        return observable;
    };
    Observable.prototype.subscribe = function (observerOrNext, error, complete) {
        var _this = this;
        var subscriber = isSubscriber(observerOrNext) ? observerOrNext : new SafeSubscriber(observerOrNext, error, complete);
        errorContext(function () {
            var _a = _this, operator = _a.operator, source = _a.source;
            subscriber.add(operator
                ?
                    operator.call(subscriber, source)
                : source
                    ?
                        _this._subscribe(subscriber)
                    :
                        _this._trySubscribe(subscriber));
        });
        return subscriber;
    };
    Observable.prototype._trySubscribe = function (sink) {
        try {
            return this._subscribe(sink);
        }
        catch (err) {
            sink.error(err);
        }
    };
    Observable.prototype.forEach = function (next, promiseCtor) {
        var _this = this;
        promiseCtor = getPromiseCtor(promiseCtor);
        return new promiseCtor(function (resolve, reject) {
            var subscriber = new SafeSubscriber({
                next: function (value) {
                    try {
                        next(value);
                    }
                    catch (err) {
                        reject(err);
                        subscriber.unsubscribe();
                    }
                },
                error: reject,
                complete: resolve,
            });
            _this.subscribe(subscriber);
        });
    };
    Observable.prototype._subscribe = function (subscriber) {
        var _a;
        return (_a = this.source) === null || _a === void 0 ? void 0 : _a.subscribe(subscriber);
    };
    Observable.prototype[observable] = function () {
        return this;
    };
    Observable.prototype.pipe = function () {
        var operations = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            operations[_i] = arguments[_i];
        }
        return pipeFromArray(operations)(this);
    };
    Observable.prototype.toPromise = function (promiseCtor) {
        var _this = this;
        promiseCtor = getPromiseCtor(promiseCtor);
        return new promiseCtor(function (resolve, reject) {
            var value;
            _this.subscribe(function (x) { return (value = x); }, function (err) { return reject(err); }, function () { return resolve(value); });
        });
    };
    Observable.create = function (subscribe) {
        return new Observable(subscribe);
    };
    return Observable;
}());
function getPromiseCtor(promiseCtor) {
    var _a;
    return (_a = promiseCtor !== null && promiseCtor !== void 0 ? promiseCtor : config.Promise) !== null && _a !== void 0 ? _a : Promise;
}
function isObserver(value) {
    return value && isFunction(value.next) && isFunction(value.error) && isFunction(value.complete);
}
function isSubscriber(value) {
    return (value && value instanceof Subscriber) || (isObserver(value) && isSubscription(value));
}

function hasLift(source) {
    return isFunction(source === null || source === void 0 ? void 0 : source.lift);
}
function operate(init) {
    return function (source) {
        if (hasLift(source)) {
            return source.lift(function (liftedSource) {
                try {
                    return init(liftedSource, this);
                }
                catch (err) {
                    this.error(err);
                }
            });
        }
        throw new TypeError('Unable to lift unknown Observable type');
    };
}

function createOperatorSubscriber(destination, onNext, onComplete, onError, onFinalize) {
    return new OperatorSubscriber(destination, onNext, onComplete, onError, onFinalize);
}
var OperatorSubscriber = (function (_super) {
    __extends(OperatorSubscriber, _super);
    function OperatorSubscriber(destination, onNext, onComplete, onError, onFinalize, shouldUnsubscribe) {
        var _this = _super.call(this, destination) || this;
        _this.onFinalize = onFinalize;
        _this.shouldUnsubscribe = shouldUnsubscribe;
        _this._next = onNext
            ? function (value) {
                try {
                    onNext(value);
                }
                catch (err) {
                    destination.error(err);
                }
            }
            : _super.prototype._next;
        _this._error = onError
            ? function (err) {
                try {
                    onError(err);
                }
                catch (err) {
                    destination.error(err);
                }
                finally {
                    this.unsubscribe();
                }
            }
            : _super.prototype._error;
        _this._complete = onComplete
            ? function () {
                try {
                    onComplete();
                }
                catch (err) {
                    destination.error(err);
                }
                finally {
                    this.unsubscribe();
                }
            }
            : _super.prototype._complete;
        return _this;
    }
    OperatorSubscriber.prototype.unsubscribe = function () {
        var _a;
        if (!this.shouldUnsubscribe || this.shouldUnsubscribe()) {
            var closed_1 = this.closed;
            _super.prototype.unsubscribe.call(this);
            !closed_1 && ((_a = this.onFinalize) === null || _a === void 0 ? void 0 : _a.call(this));
        }
    };
    return OperatorSubscriber;
}(Subscriber));

var ObjectUnsubscribedError = createErrorClass(function (_super) {
    return function ObjectUnsubscribedErrorImpl() {
        _super(this);
        this.name = 'ObjectUnsubscribedError';
        this.message = 'object unsubscribed';
    };
});

var Subject = (function (_super) {
    __extends(Subject, _super);
    function Subject() {
        var _this = _super.call(this) || this;
        _this.closed = false;
        _this.currentObservers = null;
        _this.observers = [];
        _this.isStopped = false;
        _this.hasError = false;
        _this.thrownError = null;
        return _this;
    }
    Subject.prototype.lift = function (operator) {
        var subject = new AnonymousSubject(this, this);
        subject.operator = operator;
        return subject;
    };
    Subject.prototype._throwIfClosed = function () {
        if (this.closed) {
            throw new ObjectUnsubscribedError();
        }
    };
    Subject.prototype.next = function (value) {
        var _this = this;
        errorContext(function () {
            var e_1, _a;
            _this._throwIfClosed();
            if (!_this.isStopped) {
                if (!_this.currentObservers) {
                    _this.currentObservers = Array.from(_this.observers);
                }
                try {
                    for (var _b = __values(_this.currentObservers), _c = _b.next(); !_c.done; _c = _b.next()) {
                        var observer = _c.value;
                        observer.next(value);
                    }
                }
                catch (e_1_1) { e_1 = { error: e_1_1 }; }
                finally {
                    try {
                        if (_c && !_c.done && (_a = _b.return)) _a.call(_b);
                    }
                    finally { if (e_1) throw e_1.error; }
                }
            }
        });
    };
    Subject.prototype.error = function (err) {
        var _this = this;
        errorContext(function () {
            _this._throwIfClosed();
            if (!_this.isStopped) {
                _this.hasError = _this.isStopped = true;
                _this.thrownError = err;
                var observers = _this.observers;
                while (observers.length) {
                    observers.shift().error(err);
                }
            }
        });
    };
    Subject.prototype.complete = function () {
        var _this = this;
        errorContext(function () {
            _this._throwIfClosed();
            if (!_this.isStopped) {
                _this.isStopped = true;
                var observers = _this.observers;
                while (observers.length) {
                    observers.shift().complete();
                }
            }
        });
    };
    Subject.prototype.unsubscribe = function () {
        this.isStopped = this.closed = true;
        this.observers = this.currentObservers = null;
    };
    Object.defineProperty(Subject.prototype, "observed", {
        get: function () {
            var _a;
            return ((_a = this.observers) === null || _a === void 0 ? void 0 : _a.length) > 0;
        },
        enumerable: false,
        configurable: true
    });
    Subject.prototype._trySubscribe = function (subscriber) {
        this._throwIfClosed();
        return _super.prototype._trySubscribe.call(this, subscriber);
    };
    Subject.prototype._subscribe = function (subscriber) {
        this._throwIfClosed();
        this._checkFinalizedStatuses(subscriber);
        return this._innerSubscribe(subscriber);
    };
    Subject.prototype._innerSubscribe = function (subscriber) {
        var _this = this;
        var _a = this, hasError = _a.hasError, isStopped = _a.isStopped, observers = _a.observers;
        if (hasError || isStopped) {
            return EMPTY_SUBSCRIPTION;
        }
        this.currentObservers = null;
        observers.push(subscriber);
        return new Subscription(function () {
            _this.currentObservers = null;
            arrRemove(observers, subscriber);
        });
    };
    Subject.prototype._checkFinalizedStatuses = function (subscriber) {
        var _a = this, hasError = _a.hasError, thrownError = _a.thrownError, isStopped = _a.isStopped;
        if (hasError) {
            subscriber.error(thrownError);
        }
        else if (isStopped) {
            subscriber.complete();
        }
    };
    Subject.prototype.asObservable = function () {
        var observable = new Observable();
        observable.source = this;
        return observable;
    };
    Subject.create = function (destination, source) {
        return new AnonymousSubject(destination, source);
    };
    return Subject;
}(Observable));
var AnonymousSubject = (function (_super) {
    __extends(AnonymousSubject, _super);
    function AnonymousSubject(destination, source) {
        var _this = _super.call(this) || this;
        _this.destination = destination;
        _this.source = source;
        return _this;
    }
    AnonymousSubject.prototype.next = function (value) {
        var _a, _b;
        (_b = (_a = this.destination) === null || _a === void 0 ? void 0 : _a.next) === null || _b === void 0 ? void 0 : _b.call(_a, value);
    };
    AnonymousSubject.prototype.error = function (err) {
        var _a, _b;
        (_b = (_a = this.destination) === null || _a === void 0 ? void 0 : _a.error) === null || _b === void 0 ? void 0 : _b.call(_a, err);
    };
    AnonymousSubject.prototype.complete = function () {
        var _a, _b;
        (_b = (_a = this.destination) === null || _a === void 0 ? void 0 : _a.complete) === null || _b === void 0 ? void 0 : _b.call(_a);
    };
    AnonymousSubject.prototype._subscribe = function (subscriber) {
        var _a, _b;
        return (_b = (_a = this.source) === null || _a === void 0 ? void 0 : _a.subscribe(subscriber)) !== null && _b !== void 0 ? _b : EMPTY_SUBSCRIPTION;
    };
    return AnonymousSubject;
}(Subject));

var dateTimestampProvider = {
    now: function () {
        return (dateTimestampProvider.delegate || Date).now();
    },
    delegate: undefined,
};

var ReplaySubject = (function (_super) {
    __extends(ReplaySubject, _super);
    function ReplaySubject(_bufferSize, _windowTime, _timestampProvider) {
        if (_bufferSize === void 0) { _bufferSize = Infinity; }
        if (_windowTime === void 0) { _windowTime = Infinity; }
        if (_timestampProvider === void 0) { _timestampProvider = dateTimestampProvider; }
        var _this = _super.call(this) || this;
        _this._bufferSize = _bufferSize;
        _this._windowTime = _windowTime;
        _this._timestampProvider = _timestampProvider;
        _this._buffer = [];
        _this._infiniteTimeWindow = true;
        _this._infiniteTimeWindow = _windowTime === Infinity;
        _this._bufferSize = Math.max(1, _bufferSize);
        _this._windowTime = Math.max(1, _windowTime);
        return _this;
    }
    ReplaySubject.prototype.next = function (value) {
        var _a = this, isStopped = _a.isStopped, _buffer = _a._buffer, _infiniteTimeWindow = _a._infiniteTimeWindow, _timestampProvider = _a._timestampProvider, _windowTime = _a._windowTime;
        if (!isStopped) {
            _buffer.push(value);
            !_infiniteTimeWindow && _buffer.push(_timestampProvider.now() + _windowTime);
        }
        this._trimBuffer();
        _super.prototype.next.call(this, value);
    };
    ReplaySubject.prototype._subscribe = function (subscriber) {
        this._throwIfClosed();
        this._trimBuffer();
        var subscription = this._innerSubscribe(subscriber);
        var _a = this, _infiniteTimeWindow = _a._infiniteTimeWindow, _buffer = _a._buffer;
        var copy = _buffer.slice();
        for (var i = 0; i < copy.length && !subscriber.closed; i += _infiniteTimeWindow ? 1 : 2) {
            subscriber.next(copy[i]);
        }
        this._checkFinalizedStatuses(subscriber);
        return subscription;
    };
    ReplaySubject.prototype._trimBuffer = function () {
        var _a = this, _bufferSize = _a._bufferSize, _timestampProvider = _a._timestampProvider, _buffer = _a._buffer, _infiniteTimeWindow = _a._infiniteTimeWindow;
        var adjustedBufferSize = (_infiniteTimeWindow ? 1 : 2) * _bufferSize;
        _bufferSize < Infinity && adjustedBufferSize < _buffer.length && _buffer.splice(0, _buffer.length - adjustedBufferSize);
        if (!_infiniteTimeWindow) {
            var now = _timestampProvider.now();
            var last = 0;
            for (var i = 1; i < _buffer.length && _buffer[i] <= now; i += 2) {
                last = i;
            }
            last && _buffer.splice(0, last + 1);
        }
    };
    return ReplaySubject;
}(Subject));

var EMPTY = new Observable(function (subscriber) { return subscriber.complete(); });

function isScheduler(value) {
    return value && isFunction(value.schedule);
}

function last(arr) {
    return arr[arr.length - 1];
}
function popResultSelector(args) {
    return isFunction(last(args)) ? args.pop() : undefined;
}
function popScheduler(args) {
    return isScheduler(last(args)) ? args.pop() : undefined;
}

var isArrayLike = (function (x) { return x && typeof x.length === 'number' && typeof x !== 'function'; });

function isPromise(value) {
    return isFunction(value === null || value === void 0 ? void 0 : value.then);
}

function isInteropObservable(input) {
    return isFunction(input[observable]);
}

function isAsyncIterable(obj) {
    return Symbol.asyncIterator && isFunction(obj === null || obj === void 0 ? void 0 : obj[Symbol.asyncIterator]);
}

function createInvalidObservableTypeError(input) {
    return new TypeError("You provided " + (input !== null && typeof input === 'object' ? 'an invalid object' : "'" + input + "'") + " where a stream was expected. You can provide an Observable, Promise, ReadableStream, Array, AsyncIterable, or Iterable.");
}

function getSymbolIterator() {
    if (typeof Symbol !== 'function' || !Symbol.iterator) {
        return '@@iterator';
    }
    return Symbol.iterator;
}
var iterator = getSymbolIterator();

function isIterable(input) {
    return isFunction(input === null || input === void 0 ? void 0 : input[iterator]);
}

function readableStreamLikeToAsyncGenerator(readableStream) {
    return __asyncGenerator(this, arguments, function readableStreamLikeToAsyncGenerator_1() {
        var reader, _a, value, done;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0:
                    reader = readableStream.getReader();
                    _b.label = 1;
                case 1:
                    _b.trys.push([1, , 9, 10]);
                    _b.label = 2;
                case 2:
                    return [4, __await(reader.read())];
                case 3:
                    _a = _b.sent(), value = _a.value, done = _a.done;
                    if (!done) return [3, 5];
                    return [4, __await(void 0)];
                case 4: return [2, _b.sent()];
                case 5: return [4, __await(value)];
                case 6: return [4, _b.sent()];
                case 7:
                    _b.sent();
                    return [3, 2];
                case 8: return [3, 10];
                case 9:
                    reader.releaseLock();
                    return [7];
                case 10: return [2];
            }
        });
    });
}
function isReadableStreamLike(obj) {
    return isFunction(obj === null || obj === void 0 ? void 0 : obj.getReader);
}

function innerFrom(input) {
    if (input instanceof Observable) {
        return input;
    }
    if (input != null) {
        if (isInteropObservable(input)) {
            return fromInteropObservable(input);
        }
        if (isArrayLike(input)) {
            return fromArrayLike(input);
        }
        if (isPromise(input)) {
            return fromPromise(input);
        }
        if (isAsyncIterable(input)) {
            return fromAsyncIterable(input);
        }
        if (isIterable(input)) {
            return fromIterable(input);
        }
        if (isReadableStreamLike(input)) {
            return fromReadableStreamLike(input);
        }
    }
    throw createInvalidObservableTypeError(input);
}
function fromInteropObservable(obj) {
    return new Observable(function (subscriber) {
        var obs = obj[observable]();
        if (isFunction(obs.subscribe)) {
            return obs.subscribe(subscriber);
        }
        throw new TypeError('Provided object does not correctly implement Symbol.observable');
    });
}
function fromArrayLike(array) {
    return new Observable(function (subscriber) {
        for (var i = 0; i < array.length && !subscriber.closed; i++) {
            subscriber.next(array[i]);
        }
        subscriber.complete();
    });
}
function fromPromise(promise) {
    return new Observable(function (subscriber) {
        promise
            .then(function (value) {
            if (!subscriber.closed) {
                subscriber.next(value);
                subscriber.complete();
            }
        }, function (err) { return subscriber.error(err); })
            .then(null, reportUnhandledError);
    });
}
function fromIterable(iterable) {
    return new Observable(function (subscriber) {
        var e_1, _a;
        try {
            for (var iterable_1 = __values(iterable), iterable_1_1 = iterable_1.next(); !iterable_1_1.done; iterable_1_1 = iterable_1.next()) {
                var value = iterable_1_1.value;
                subscriber.next(value);
                if (subscriber.closed) {
                    return;
                }
            }
        }
        catch (e_1_1) { e_1 = { error: e_1_1 }; }
        finally {
            try {
                if (iterable_1_1 && !iterable_1_1.done && (_a = iterable_1.return)) _a.call(iterable_1);
            }
            finally { if (e_1) throw e_1.error; }
        }
        subscriber.complete();
    });
}
function fromAsyncIterable(asyncIterable) {
    return new Observable(function (subscriber) {
        process(asyncIterable, subscriber).catch(function (err) { return subscriber.error(err); });
    });
}
function fromReadableStreamLike(readableStream) {
    return fromAsyncIterable(readableStreamLikeToAsyncGenerator(readableStream));
}
function process(asyncIterable, subscriber) {
    var asyncIterable_1, asyncIterable_1_1;
    var e_2, _a;
    return __awaiter(this, void 0, void 0, function () {
        var value, e_2_1;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0:
                    _b.trys.push([0, 5, 6, 11]);
                    asyncIterable_1 = __asyncValues(asyncIterable);
                    _b.label = 1;
                case 1: return [4, asyncIterable_1.next()];
                case 2:
                    if (!(asyncIterable_1_1 = _b.sent(), !asyncIterable_1_1.done)) return [3, 4];
                    value = asyncIterable_1_1.value;
                    subscriber.next(value);
                    if (subscriber.closed) {
                        return [2];
                    }
                    _b.label = 3;
                case 3: return [3, 1];
                case 4: return [3, 11];
                case 5:
                    e_2_1 = _b.sent();
                    e_2 = { error: e_2_1 };
                    return [3, 11];
                case 6:
                    _b.trys.push([6, , 9, 10]);
                    if (!(asyncIterable_1_1 && !asyncIterable_1_1.done && (_a = asyncIterable_1.return))) return [3, 8];
                    return [4, _a.call(asyncIterable_1)];
                case 7:
                    _b.sent();
                    _b.label = 8;
                case 8: return [3, 10];
                case 9:
                    if (e_2) throw e_2.error;
                    return [7];
                case 10: return [7];
                case 11:
                    subscriber.complete();
                    return [2];
            }
        });
    });
}

function executeSchedule(parentSubscription, scheduler, work, delay, repeat) {
    if (delay === void 0) { delay = 0; }
    if (repeat === void 0) { repeat = false; }
    var scheduleSubscription = scheduler.schedule(function () {
        work();
        if (repeat) {
            parentSubscription.add(this.schedule(null, delay));
        }
        else {
            this.unsubscribe();
        }
    }, delay);
    parentSubscription.add(scheduleSubscription);
    if (!repeat) {
        return scheduleSubscription;
    }
}

function observeOn(scheduler, delay) {
    if (delay === void 0) { delay = 0; }
    return operate(function (source, subscriber) {
        source.subscribe(createOperatorSubscriber(subscriber, function (value) { return executeSchedule(subscriber, scheduler, function () { return subscriber.next(value); }, delay); }, function () { return executeSchedule(subscriber, scheduler, function () { return subscriber.complete(); }, delay); }, function (err) { return executeSchedule(subscriber, scheduler, function () { return subscriber.error(err); }, delay); }));
    });
}

function subscribeOn(scheduler, delay) {
    if (delay === void 0) { delay = 0; }
    return operate(function (source, subscriber) {
        subscriber.add(scheduler.schedule(function () { return source.subscribe(subscriber); }, delay));
    });
}

function scheduleObservable(input, scheduler) {
    return innerFrom(input).pipe(subscribeOn(scheduler), observeOn(scheduler));
}

function schedulePromise(input, scheduler) {
    return innerFrom(input).pipe(subscribeOn(scheduler), observeOn(scheduler));
}

function scheduleArray(input, scheduler) {
    return new Observable(function (subscriber) {
        var i = 0;
        return scheduler.schedule(function () {
            if (i === input.length) {
                subscriber.complete();
            }
            else {
                subscriber.next(input[i++]);
                if (!subscriber.closed) {
                    this.schedule();
                }
            }
        });
    });
}

function scheduleIterable(input, scheduler) {
    return new Observable(function (subscriber) {
        var iterator$1;
        executeSchedule(subscriber, scheduler, function () {
            iterator$1 = input[iterator]();
            executeSchedule(subscriber, scheduler, function () {
                var _a;
                var value;
                var done;
                try {
                    (_a = iterator$1.next(), value = _a.value, done = _a.done);
                }
                catch (err) {
                    subscriber.error(err);
                    return;
                }
                if (done) {
                    subscriber.complete();
                }
                else {
                    subscriber.next(value);
                }
            }, 0, true);
        });
        return function () { return isFunction(iterator$1 === null || iterator$1 === void 0 ? void 0 : iterator$1.return) && iterator$1.return(); };
    });
}

function scheduleAsyncIterable(input, scheduler) {
    if (!input) {
        throw new Error('Iterable cannot be null');
    }
    return new Observable(function (subscriber) {
        executeSchedule(subscriber, scheduler, function () {
            var iterator = input[Symbol.asyncIterator]();
            executeSchedule(subscriber, scheduler, function () {
                iterator.next().then(function (result) {
                    if (result.done) {
                        subscriber.complete();
                    }
                    else {
                        subscriber.next(result.value);
                    }
                });
            }, 0, true);
        });
    });
}

function scheduleReadableStreamLike(input, scheduler) {
    return scheduleAsyncIterable(readableStreamLikeToAsyncGenerator(input), scheduler);
}

function scheduled(input, scheduler) {
    if (input != null) {
        if (isInteropObservable(input)) {
            return scheduleObservable(input, scheduler);
        }
        if (isArrayLike(input)) {
            return scheduleArray(input, scheduler);
        }
        if (isPromise(input)) {
            return schedulePromise(input, scheduler);
        }
        if (isAsyncIterable(input)) {
            return scheduleAsyncIterable(input, scheduler);
        }
        if (isIterable(input)) {
            return scheduleIterable(input, scheduler);
        }
        if (isReadableStreamLike(input)) {
            return scheduleReadableStreamLike(input, scheduler);
        }
    }
    throw createInvalidObservableTypeError(input);
}

function from(input, scheduler) {
    return scheduler ? scheduled(input, scheduler) : innerFrom(input);
}

function map(project, thisArg) {
    return operate(function (source, subscriber) {
        var index = 0;
        source.subscribe(createOperatorSubscriber(subscriber, function (value) {
            subscriber.next(project.call(thisArg, value, index++));
        }));
    });
}

var isArray$1 = Array.isArray;
function callOrApply(fn, args) {
    return isArray$1(args) ? fn.apply(void 0, __spreadArray([], __read(args))) : fn(args);
}
function mapOneOrManyArgs(fn) {
    return map(function (args) { return callOrApply(fn, args); });
}

var isArray = Array.isArray;
var getPrototypeOf = Object.getPrototypeOf, objectProto = Object.prototype, getKeys = Object.keys;
function argsArgArrayOrObject(args) {
    if (args.length === 1) {
        var first_1 = args[0];
        if (isArray(first_1)) {
            return { args: first_1, keys: null };
        }
        if (isPOJO(first_1)) {
            var keys = getKeys(first_1);
            return {
                args: keys.map(function (key) { return first_1[key]; }),
                keys: keys,
            };
        }
    }
    return { args: args, keys: null };
}
function isPOJO(obj) {
    return obj && typeof obj === 'object' && getPrototypeOf(obj) === objectProto;
}

function createObject(keys, values) {
    return keys.reduce(function (result, key, i) { return ((result[key] = values[i]), result); }, {});
}

function combineLatest() {
    var args = [];
    for (var _i = 0; _i < arguments.length; _i++) {
        args[_i] = arguments[_i];
    }
    var scheduler = popScheduler(args);
    var resultSelector = popResultSelector(args);
    var _a = argsArgArrayOrObject(args), observables = _a.args, keys = _a.keys;
    if (observables.length === 0) {
        return from([], scheduler);
    }
    var result = new Observable(combineLatestInit(observables, scheduler, keys
        ?
            function (values) { return createObject(keys, values); }
        :
            identity));
    return resultSelector ? result.pipe(mapOneOrManyArgs(resultSelector)) : result;
}
function combineLatestInit(observables, scheduler, valueTransform) {
    if (valueTransform === void 0) { valueTransform = identity; }
    return function (subscriber) {
        maybeSchedule(scheduler, function () {
            var length = observables.length;
            var values = new Array(length);
            var active = length;
            var remainingFirstValues = length;
            var _loop_1 = function (i) {
                maybeSchedule(scheduler, function () {
                    var source = from(observables[i], scheduler);
                    var hasFirstValue = false;
                    source.subscribe(createOperatorSubscriber(subscriber, function (value) {
                        values[i] = value;
                        if (!hasFirstValue) {
                            hasFirstValue = true;
                            remainingFirstValues--;
                        }
                        if (!remainingFirstValues) {
                            subscriber.next(valueTransform(values.slice()));
                        }
                    }, function () {
                        if (!--active) {
                            subscriber.complete();
                        }
                    }));
                }, subscriber);
            };
            for (var i = 0; i < length; i++) {
                _loop_1(i);
            }
        }, subscriber);
    };
}
function maybeSchedule(scheduler, execute, subscription) {
    if (scheduler) {
        executeSchedule(subscription, scheduler, execute);
    }
    else {
        execute();
    }
}

function filter(predicate, thisArg) {
    return operate(function (source, subscriber) {
        var index = 0;
        source.subscribe(createOperatorSubscriber(subscriber, function (value) { return predicate.call(thisArg, value, index++) && subscriber.next(value); }));
    });
}

function take(count) {
    return count <= 0
        ?
            function () { return EMPTY; }
        : operate(function (source, subscriber) {
            var seen = 0;
            source.subscribe(createOperatorSubscriber(subscriber, function (value) {
                if (++seen <= count) {
                    subscriber.next(value);
                    if (count <= seen) {
                        subscriber.complete();
                    }
                }
            }));
        });
}

function distinctUntilChanged(comparator, keySelector) {
    if (keySelector === void 0) { keySelector = identity; }
    comparator = comparator !== null && comparator !== void 0 ? comparator : defaultCompare;
    return operate(function (source, subscriber) {
        var previousKey;
        var first = true;
        source.subscribe(createOperatorSubscriber(subscriber, function (value) {
            var currentKey = keySelector(value);
            if (first || !comparator(previousKey, currentKey)) {
                first = false;
                previousKey = currentKey;
                subscriber.next(value);
            }
        }));
    });
}
function defaultCompare(a, b) {
    return a === b;
}

function tap(observerOrNext, error, complete) {
    var tapObserver = isFunction(observerOrNext) || error || complete
        ?
            { next: observerOrNext, error: error, complete: complete }
        : observerOrNext;
    return tapObserver
        ? operate(function (source, subscriber) {
            var _a;
            (_a = tapObserver.subscribe) === null || _a === void 0 ? void 0 : _a.call(tapObserver);
            var isUnsub = true;
            source.subscribe(createOperatorSubscriber(subscriber, function (value) {
                var _a;
                (_a = tapObserver.next) === null || _a === void 0 ? void 0 : _a.call(tapObserver, value);
                subscriber.next(value);
            }, function () {
                var _a;
                isUnsub = false;
                (_a = tapObserver.complete) === null || _a === void 0 ? void 0 : _a.call(tapObserver);
                subscriber.complete();
            }, function (err) {
                var _a;
                isUnsub = false;
                (_a = tapObserver.error) === null || _a === void 0 ? void 0 : _a.call(tapObserver, err);
                subscriber.error(err);
            }, function () {
                var _a, _b;
                if (isUnsub) {
                    (_a = tapObserver.unsubscribe) === null || _a === void 0 ? void 0 : _a.call(tapObserver);
                }
                (_b = tapObserver.finalize) === null || _b === void 0 ? void 0 : _b.call(tapObserver);
            }));
        })
        :
            identity;
}

/** Log levels */
var LogLevel;
(function (LogLevel) {
    LogLevel[LogLevel["trace"] = 1] = "trace";
    LogLevel[LogLevel["debug"] = 2] = "debug";
    LogLevel[LogLevel["info"] = 3] = "info";
    LogLevel[LogLevel["warn"] = 4] = "warn";
    LogLevel[LogLevel["error"] = 5] = "error";
    LogLevel[LogLevel["fatal"] = 6] = "fatal";
    LogLevel[LogLevel["default"] = 3] = "default";
})(LogLevel || (LogLevel = {}));
/**
 * Converts a log level to its string value and handles the default name.
 * @param {LogLevel} level The level to convert to string
 * @return {String} The string representation of the log level.
 */
function logLevelToString(level) {
    if (level === LogLevel.default) {
        return 'info';
    }
    return LogLevel[level];
}

/**
 * Noop Logger. Can be ued to disable a Logger of for a temporarly initialization.
 * @date 01/02/2024 - 16:28:19
 * @author A. Deman
 *
 * @export
 * @class NoopLogger
 * @typedef {NoopLogger}
 * @implements {Logger}
 */
class NoopLogger {
    /**
     * Singleton constructor.
     */
    constructor() {
        /** Disabled flag. */
        this.disabled = false;
        /** Name of the logger. */
        this.name = 'nohop';
        /** Level of the logger. */
        this.level = LogLevel.trace;
        if (!NoopLogger._INSTANCE) {
            NoopLogger._INSTANCE = this;
        }
        return NoopLogger._INSTANCE;
    }
    /**
     * Logs a message for a specific level.
     * @param level The level of the message.
     * @param {any[]} messageParts Parts of the message to log.
     * @return {Logger} this instance of Logger.
     *
     */
    log(level, ...messageParts) {
        return this;
    }
    /**
    * Logs a trace message.
    * @param {any[]} messageParts Parts of the message to log.
    * @return {Logger} this instance of Logger.
    */
    trace(...messageParts) {
        return this.log(LogLevel.trace, messageParts);
    }
    /**
     * Logs a debug message.
     * @param {any[]} messageParts Parts of the message to log.
     * @return {Logger} this instance of Logger.
     */
    debug(...messageParts) {
        return this.log(LogLevel.debug, messageParts);
    }
    /**
     * Logs an info message.
     * @param {any[]} messageParts Parts of the message to log.
     * @return {Logger} this instance of Logger.
     */
    info(...messageParts) {
        return this.log(LogLevel.info, messageParts);
    }
    /**
    * Logs a warn message.
    * @param {any[]} messageParts Parts of the message to log.
    * @return {Logger} this instance of Logger.
    */
    warn(...messageParts) {
        return this.log(LogLevel.warn, messageParts);
    }
    /**
    * Logs an error message.
    * @param {any[]} messageParts Parts of the message to log.
    * @return {Logger} this instance of Logger.
    */
    error(...messageParts) {
        return this.log(LogLevel.error, messageParts);
    }
    /**
    * Logs a fatal message.
    * @param {any[]} messageParts Parts of the message to log.
    * @return {Logger} this instance of Logger.
    */
    fatal(...messageParts) {
        return this.log(LogLevel.fatal, messageParts);
    }
    /**
     * Helper method to process or ignore a message based on a predicate.
     * Not the level of logger / message still apply.
     * Does nothing in this implementation.
     * @param predicate The predicate to determine if the log should be processed.
     */
    if(predicate) {
        return this;
    }
    /**
     * Enter into a context.
     * @param {LoggingContext | string }context A logging context.
     * @returns this instance.
     */
    enter(context) {
        return this;
    }
    /**
     * Leave a context.
     * @returns This instance.
     */
    leave() {
        return this;
    }
}

/**
 * Console appender.
 * @date 01/02/2024 - 16:13:35
 * @author A. Deman
 *
 * @export
 * @class ConsoleAppender
 * @typedef {ConsoleAppender}
 * @implements {LogAppender}
 */
class ConsoleAppender {
    /**
     * Appends a message to the console.
     * @param message The message to append.
     * @returns True if the message has been processed, false if ignored.
     */
    append(message) {
        switch (message.level) {
            case LogLevel.debug:
            case LogLevel.trace: {
                console.debug(message.prefix, ...message.parts);
                return true;
            }
            case LogLevel.info: {
                console.info(message.prefix, ...message.parts);
                return true;
            }
            case LogLevel.warn: {
                console.warn(message.prefix, ...message.parts);
                return true;
            }
            case LogLevel.error:
            case LogLevel.fatal: {
                console.error(message.prefix, ...message.parts);
                return true;
            }
            default: {
                return false;
            }
        }
    }
}

/**
 * Deffault formatter.
 * @date 01/02/2024 - 16:16:31
 * @author A. Deman
 *
 * @export
 * @class DefaultLogFormatter
 * @type {DefaultLogFormatter}
 * @implements {LogFormatter}
 */
class DefaultLogFormatter {
    /**
     * Format the message.
     * @date 01/02/2024 - 16:17:54
     * @author A. Deman
     *
     * @param {string} name The name of the logger.
     * @param {LogLevel} level Level from which messages are processed by this logger.
     * @param {any[]} messageParts Parts of the message.
     * @param {?LoggingContext} context The context of the log.
     * @returns {LogMessage} An instance of LogMessage.
     */
    format(name, level, messageParts, context) {
        const date = new Date();
        const message = {
            level,
            date,
            prefix: `[${logLevelToString(level)}::${name}${context?.source ? '::' + context.source : ''}]`,
            parts: messageParts,
            context
        };
        return message;
    }
}

/**
 * Default implementation of a Logger.
 * @date 01/02/2024 - 16:21:47
 * @author A. Deman
 *
 * @export
 * @class DefaultLogger
 * @type {DefaultLogger}
 * @implements {Logger}
 */
class DefaultLogger {
    /**
     * Builds an instance of logger.
     * @param name  The name of the logger.
     * @param level The level of the logger.
     * @param _formatter  the formatter to use.
     * @param _appender The appender to use.
     */
    constructor(name, level, _formatter, _appender) {
        this.name = name;
        this.level = level;
        this._formatter = _formatter;
        this._appender = _appender;
        /** Flag to determine if the logger is disabled. */
        this.disabled = false;
    }
    /**
     * Logs a message for a specific level.
     * @param level The level of the message.
     * @param {any[]} messageParts Parts of the message to log.
     * @return {Logger} this instance of Logger.
     */
    log(level, messageParts) {
        if (level >= this.level && !this.disabled) {
            this._appender.append(this._formatter.format(this.name, level, messageParts, this._context));
        }
        return this;
    }
    /**
    * Logs a trace message.
    * @param {any[]} messageParts Parts of the message to log.
    * @return {Logger} this instance of Logger.
    */
    trace(...messageParts) {
        return this.log(LogLevel.trace, messageParts);
    }
    /**
     * Logs a debug message.
     * @param {any[]} messageParts Parts of the message to log.
     * @return {Logger} this instance of Logger.
     */
    debug(...messageParts) {
        return this.log(LogLevel.debug, messageParts);
    }
    /**
     * Logs an info message.
     * @param {any[]} messageParts Parts of the message to log.
     * @return {Logger} this instance of Logger.
     */
    info(...messageParts) {
        return this.log(LogLevel.info, messageParts);
    }
    /**
    * Logs a warn message.
    * @param {any[]} messageParts Parts of the message to log.
    * @return {Logger} this instance of Logger.
    */
    warn(...messageParts) {
        return this.log(LogLevel.warn, messageParts);
    }
    /**
    * Logs an error message.
    * @param {any[]} messageParts Parts of the message to log.
    * @return {Logger} this instance of Logger.
    */
    error(...messageParts) {
        return this.log(LogLevel.error, messageParts);
    }
    /**
    * Logs a fatal message.
    * @param {any[]} messageParts Parts of the message to log.
    * @return {Logger} this instance of Logger.
    */
    fatal(...messageParts) {
        return this.log(LogLevel.fatal, messageParts);
    }
    /**
     * Helper method to process or ignore a message based on a predicate.
     * Note that the level of logger / message still apply if the predicate is true.
     * @param predicate The predicate to determine if the log should be processed.
     * @return this instance if the predicate is true, a noop logger otherwise.
     */
    if(predicate) {
        return predicate ? this : new NoopLogger();
    }
    /**
     * Enter into a logging context.
     * @param {LoggingContext | string }context The new current context or the source (equivalent to {source:...}).
     */
    enter(context) {
        this._context = typeof context === "string" ? { source: context } : context;
        return this;
    }
    /**
     * Leave a logging context.
     */
    leave() {
        this._context = undefined;
        return this;
    }
}

/**
 * Factory for a console logger.
 * @date 01/02/2024 - 12:56:36
 * @author A. Deman
 *
 * @export {ConsoleLoggerFactory}
 * @class ConsoleLoggerFactory
 * @type {ConsoleLoggerFactory}
 * @implements {LoggerFactory}
 */
class ConsoleLoggerFactory {
    /**
     * Creates an instance of Logger that logs in the console.
     * @param {string} name The name of the logger.
     * @param {LogLevel} level The level of the logger.
      * @returns {Logger} The instance of ConsoleLogger.
     */
    createLogger(name, level, formatter) {
        return new DefaultLogger(name, level, formatter || new DefaultLogFormatter(), new ConsoleAppender());
    }
}

/**
 * ogging manager.
 * Handles the initialization of the logging and the creation managment of Loggers.
 * @date 01/02/2024 - 16:29:02
 * @author A. Deman
 *
 * @export
 * @class LoggingManager
 * @type {LoggingManager}
 */
class LoggingManager {
    /**
     * Creates an instance of LoggingManager.
     * @date 01/02/2024 - 15:48:36
     *
     * @constructor
     * @param {?LoggingSettings} [settings] The settings to use. Optional if an instance has already been created.
     */
    constructor(settings) {
        /** The loggers registry. */
        this._loggers = {};
        if (!LoggingManager._INSTANCE) {
            if (!settings) {
                throw new Error('Missing settings. The settings are optional only if they have been set previously via the constructor or initialize static method.');
            }
            LoggingManager._INSTANCE = this;
            this._settings = settings;
        }
        return LoggingManager._INSTANCE;
    }
    /**
     * Initilization of the singleton instance.
     * @date 01/02/2024 - 15:53:01
     *
     * @static
     * @param {LoggingSettings} settings
     */
    static initialize(settings) {
        new LoggingManager(settings);
    }
    /**
     *
     * @param name The name of the logger to create.
     * @returns The new created logger, using the factory, level and appender specified in settings.
     */
    createLogger(name) {
        const level = this.settings.levels?.[name] || this.settings.levels.default;
        const factory = this.settings.factories?.[name] || this.settings?.factories?.default;
        return factory?.createLogger(name, level);
    }
    /**
     * Gives a logger associated to a name. If the logger does not exist it is created.
     * @param name The name of the logger to retrieve.
     * @returns The logger.
     */
    getLogger(name = LoggingManager._ROOT_LOGGER_NAME) {
        // Creates the logger if it does not exist.
        if (!this._loggers[name]) {
            this._loggers[name] = this.createLogger(name);
        }
        return this._loggers[name];
    }
    /**
     * Hack to get a not undefined instance of settings.
     * @date 01/02/2024 - 16:29:53
     * @author A. Deman
     *
     * @private
     * @readonly
     * @type {LoggingSettings}
     */
    get settings() {
        return this._settings;
    }
}
/** The name of the root logger (which is the default logger) */
LoggingManager._ROOT_LOGGER_NAME = 'root';

/**
 * Default settings.
 * @date 01/02/2024 - 16:31:26
 * @author A. Deman
 *
 * @type {LoggingSettings}
 */
const DEFAULT_LOGGING_SETTINGS = {
    factories: {
        default: new ConsoleLoggerFactory(),
    },
    levels: {
        default: LogLevel.default,
    }
};

/**
 * Authentication settings provider service.
 * Provides an instance of Settings and helper functions.
 * It also initialize the logging system.
 * @date 01/02/2024 - 16:33:40
 * @author A. Deman
 *
 * @export
 * @class AuthSettingsService
 * @type {AuthSettingsService}
 */
class AuthSettingsService {
    /**
    * Singleton constructor.
    * @param settings: The initial instance of settings (optional)
    * @returns the unique instance of this class.
    */
    constructor(settings) {
        /** The logger for this instance. */
        this._logger = new NoopLogger();
        /** settings. */
        this.settings$ = new ReplaySubject(1);
        if (!AuthSettingsService._INSTANCE) {
            AuthSettingsService._INSTANCE = this;
        }
        if (settings) {
            LoggingManager.initialize(settings.logging);
            this._logger = new LoggingManager().getLogger('AuthSettingsService');
            AuthSettingsService._INSTANCE.settings$.next(settings);
        }
        return AuthSettingsService._INSTANCE;
    }
    /**
     * Updates the setttings.
     * @date 01/02/2024 - 16:38:10
     *
     * @param {AuthSettings} settings
     */
    update(settings) {
        this.settings$.next(settings);
    }
    /**
     * Helper function to select the endpoint (local, dev, prod) based on the hostname.
     * @param settings The instance of settings.
     * @param hostname The current hostname.
     * @returns  An the end points to use for the current hostname.
     */
    selectEndPointsForHost(settings, hostname) {
        this._logger
            .enter('selectEndPointsForHost')
            .debug('selectEndPointsForHost hostname', hostname)
            .leave();
        if (hostname === 'localhost' || hostname === '127.0.0.1') {
            return settings?.routes?.local;
        }
        if (hostname.includes('srv-dev-avenir')) {
            return settings.routes.dev;
        }
        return settings?.routes?.prod;
    }
}

/**
 * Authentication service.
 * This class is a singleton, the constructor will return the same instance.
 * 1. Try to retrieve the jwt from the URL.
 *       * If found: it is registered in the session storage.
 *       * If not found: try to find it in session storage.
 * 2. If there is a jwt it is validated.
 * 3. If there is a valid jwt, the user is authenticated.
 * 4. If not redirect to the oidc provider to retrieve a jwt.
 * @date 01/02/2024 - 16:32:26
 * @author A. Deman
 *
 * @export
 * @class AuthService
 * @typedef {AuthService}
 */
class AuthService {
    /**
     * Singleton constructor.
     * @returns the unique instance of this class.
     */
    constructor() {
        /** Authentication settings service. */
        this._settingsService = new AuthSettingsService();
        /** Authenticated status observable. */
        this.authenticated$ = new ReplaySubject(1);
        /** The active jwt  observable. */
        this.jwt$ = new ReplaySubject(1);
        /** Authentication data */
        this.authenticationData$ = new ReplaySubject(1);
        /** Flag to determine if the authentication service is initialized, i.e.: the authenticatio nstatus is known.  */
        this.authenticationStatusKnown = false;
        /** Loger for this class. */
        this._logger = new NoopLogger();
        if (!AuthService._INSTANCE) {
            this._initializeJWT();
            AuthService._INSTANCE = this;
        }
        return AuthService._INSTANCE;
    }
    /**
     * Tries to fetch a JWT.
     * @param onlySessionStorage Flag to determine if the JWT can be retrieved from the location.
     */
    _initializeJWT(onlySessionStorage = false) {
        this._settingsService.settings$.pipe(filter(settings => !!settings?.jwtStorageKey), take(1)).subscribe(settings => {
            this._logger = new LoggingManager(settings.logging).getLogger('AuthService').enter('_initializeJWT');
            this._logger.info('Initialization of JWT');
            let authenticated = false;
            // Flag to determine if an invalid jwk has to be removed from storage.
            let cleanStorageFlag = false;
            let jwt = '';
            let authenticationData = null;
            if (!onlySessionStorage) {
                const urlTokens = window.location.href.split('#');
                this._logger.debug('ObserveDirective AuthService _initializeJWT urlTokens', urlTokens);
                const newLocation = urlTokens?.[0];
                if (newLocation !== window.location.href) {
                    this._logger.trace('AuthService _initializeJWT newLocation', newLocation);
                    history.replaceState({}, '', newLocation);
                }
                const urlParams = new URLSearchParams(urlTokens?.[1]);
                jwt = urlParams.get('access_token') || '';
                this._logger.debug('AuthService _initializeJWT jwt', jwt);
            }
            if (!jwt) {
                jwt = sessionStorage.getItem(settings.jwtStorageKey) || '';
                cleanStorageFlag = true; // If the jwt is not valid it has to be removed from session storage.
            }
            if (jwt) {
                const validationEndpoint = this._settingsService.selectEndPointsForHost(settings, window.location.hostname)?.validation;
                this._introspect(validationEndpoint, jwt)
                    .then(data => {
                    this._logger.trace('_initializeJWT data', authenticationData);
                    authenticationData = data?.profile;
                    this._logger.trace('_initializeJWT authenticationData', authenticationData);
                    authenticated = data?.active;
                    this._logger.trace('_initializeJWT data', authenticationData);
                    this._logger.trace('_initializeJWT authenticated', authenticated);
                })
                    .catch(err => this._logger.error('AuthService _initializeJWT err', err))
                    .finally(() => {
                    if (authenticated) {
                        sessionStorage.setItem(settings.jwtStorageKey, jwt);
                    }
                    else if (cleanStorageFlag) {
                        sessionStorage.removeItem(settings.jwtStorageKey);
                    }
                    this._logger.trace('ObserveDirective AuthService _initializeJWT authenticated$ emetting', authenticated);
                    this.authenticated$.next(authenticated);
                    this.jwt$.next(jwt);
                    this._logger.trace('ObserveDirective AuthService _initializeJWT authenticationData$ emetting', authenticationData);
                    this.authenticationStatusKnown = true;
                    this.authenticationData$.next(authenticationData);
                });
            }
            else {
                this._logger.trace('ObserveDirective AuthService _initializeJWT (no jwt) authenticated$ emetting', authenticated);
                this.authenticated$.next(authenticated);
                this.jwt$.next('');
                this._logger.trace('AuthService _initializeJWT authenticationData$ emetting null');
                this.authenticationStatusKnown = true;
                this.authenticationData$.next(null);
            }
            this._logger.leave();
        });
    }
    /**
     * Introspects a JWT.
     * @param url The introspection end point.
     * @param jwt The JWT to introspect.
     * @returns The introspection data.
     */
    async _introspect(url, jwt) {
        this._logger.enter('_introspect').debug('_introspect url', url);
        const response = await fetch(url, {
            headers: {
                "Content-Type": "application/json",
                "x-authorization": jwt
            },
            method: "post",
        });
        const status = response.status;
        this._logger.debug('_introspect status', status);
        if (status !== 200) {
            this._logger.error('Error status', status);
            return null;
        }
        const data = response.json();
        this._logger.debug('_introspect data', data).leave();
        return data;
    }
    /**
     * Performs the login action.
     */
    login() {
        this._settingsService.settings$.pipe(filter(settings => !!settings?.jwtStorageKey), take(1)).subscribe(settings => {
            const loginEndPoint = this._settingsService.selectEndPointsForHost(settings, window.location.hostname)?.login;
            this._logger.enter('login').debug('AuthService login, loginEndPoint', loginEndPoint);
            this._logger.debug('AuthService login, settings', settings).leave();
            window.location.href = loginEndPoint;
        });
    }
    /**
    * Performs the logout action.
    */
    logout() {
        this._settingsService.settings$.pipe(filter(settings => !!settings.jwtStorageKey), take(1)).subscribe(settings => {
            const logoutEndPoint = this._settingsService.selectEndPointsForHost(settings, window.location.hostname)?.logout;
            this._logger.enter('logout')
                .debug('AuthService login, logoutEndPoint', logoutEndPoint)
                .leave();
            sessionStorage.removeItem(settings.jwtStorageKey);
            window.location.href = logoutEndPoint;
        });
    }
}

/**
 * Test query service.
 * Performs a query to check the oidc integration.
 * @date 01/02/2024 - 16:38:57
 * @author A. Deman.
 *
 * @export
 * @class TestQueryService
 * @typedef {TestQueryService}
 */
class TestQueryService {
    /**
     * Singleton constructor.
     * @returns the unique instance of this class.
     */
    constructor() {
        /** Authentication service. */
        this._authService = new AuthService();
        /** Authentication settings service. */
        this._settingsService = new AuthSettingsService();
        /** Observable for the responses */
        this.responseData$ = new ReplaySubject(1);
        if (!TestQueryService._INSTANCE) {
            TestQueryService._INSTANCE = this;
        }
        return TestQueryService._INSTANCE;
    }
    /**
    * Performs a test query with the jwt in the header.
    * @returns The returned data.
    */
    async performAuthenticatedQuery() {
        console.log("performAuthenticatedQuery");
        combineLatest([
            this._authService.jwt$,
            this._settingsService.settings$
        ]).pipe(take(1), tap(([jwt, settings]) => console.log('performAuthenticatedQuery jwt', jwt, 'settings', settings)), filter(([jwt, settings]) => !!settings && !!jwt), map(async ([jwt, settings]) => {
            const testEndPoint = this._settingsService.selectEndPointsForHost(settings, window.location.hostname)?.test;
            if (testEndPoint) {
                const response = await fetch(testEndPoint, {
                    headers: {
                        "Content-Type": "application/json",
                        "Authorization": `Bearer ${jwt}`
                    },
                    method: "get",
                });
                const status = response.status;
                console.log('performAuthenticatedQuery status', status);
                if (status !== 200) {
                    console.log('Error status', status);
                    this.responseData$.next({ status, error: true });
                    return null;
                }
                const data = await response.json();
                console.log('performAuthenticatedQuery data', data);
                this.responseData$.next(data);
                return data;
            }
        })).subscribe();
    }
    /**
     * Performs a test query without jwt in the header.
     * @returns The returned data.
     */
    async performUnauthenticatedQuery() {
        console.log("performUnauthenticatedQuery");
        this._settingsService.settings$.pipe(take(1), tap((settings) => console.log('performUnauthenticatedQuery settings', settings)), filter(settings => !!settings), map(async (settings) => {
            const testEndPoint = this._settingsService.selectEndPointsForHost(settings, window.location.hostname)?.validation;
            const response = await fetch(testEndPoint, {
                headers: {
                    "Content-Type": "application/json",
                },
                method: "get",
            });
            const status = response.status;
            console.log('performUnauthenticatedQuery status', status);
            if (status !== 200) {
                console.log('Error status', status);
                this.responseData$.next({ status, error: true });
                return null;
            }
            const data = await response.json();
            console.log('performUnauthenticatedQuery data', data);
            this.responseData$.next(data);
            return data;
        })).subscribe();
    }
}

/**
 * Authentication controller.
 * Makes the junction between the ui component and the service.
 * @date 01/02/2024 - 16:08:48
 * @author A. Deman
 *
 * @export
 * @class AuthController
 * @typedef {AuthController}
 * @implements {ReactiveController}
 */
class AuthController {
    /**
     * Creates an instance of AuthController.
     * @date 01/02/2024 - 15:43:10
     *
     * @constructor
     * @param {ReactiveControllerHost} host The host connected this controller.
     */
    constructor(host) {
        /** Logger associated to this class. */
        this._logger = new NoopLogger();
        (this.host = host).addController(this);
        this.authService = new AuthService();
        this._logger = new LoggingManager().getLogger('AuthController');
    }
    hostConnected() {
    }
    hostDisconnected() {
    }
    /**
     * Observable of authentication state.
     * @date 01/02/2024 - 15:43:56
     *
     * @readonly
     * @type {Observable<boolean>}
     */
    get authenticated$() {
        return this.authService.authenticated$;
    }
    /**
     * Login action.
     * @date 01/02/2024 - 15:44:18
     */
    login() {
        this._logger.debug('login');
        this.authService.login();
    }
    /**
     * Logout action.
     * @date 01/02/2024 - 16:03:53
     */
    logout() {
        this._logger.debug('logout');
        this.authService.logout();
    }
}

/**
 * Controller for the user profile widgets.
 * @date 01/02/2024 - 16:10:21
 * @author A. Deman
 *
 * @export
 * @class UserProfileController
 * @typedef {UserProfileController}
 * @implements {ReactiveController}
 */
class UserProfileController {
    /**
     * Creates an instance of UserProfileController.
     * @date 01/02/2024 - 16:53:52
     *
     * @constructor
     * @param {ReactiveControllerHost} host The ui element controlled by this instance.
     */
    constructor(host) {
        /** Logger for this instance. */
        this._logger = new NoopLogger();
        (this.host = host).addController(this);
        this._logger = new LoggingManager().getLogger('UserProfileController');
        this.authService = new AuthService();
        this.profile$ = this.authService.authenticationData$.pipe(tap(authenticationData => this._logger.debug('UserProfileController authenticationData', authenticationData)), map(authenticationData => {
            let userProfil = null;
            if (authenticationData) {
                userProfil = {
                    uid: authenticationData.id,
                    givenName: authenticationData.attributes?.given_name,
                    familyName: authenticationData.attributes?.family_name,
                    email: authenticationData.attributes?.email
                };
            }
            return userProfil;
        }));
    }
    /**
     * Lit method.
     * @date 01/02/2024 - 16:54:20
     */
    hostConnected() {
    }
    /**
     * Lit method.
     * @date 01/02/2024 - 16:54:33
     */
    hostDisconnected() {
    }
}

/**
 * Test query controler.
 * Used to check the oidc integration.
 */
/**
 * Description placeholder
 * @date 01/02/2024 - 16:07:29
 * @author A. Deman
 *
 * @export
 * @class TestQueryController
 * @type {TestQueryController}
 * @implements {ReactiveController}
 */
class TestQueryController {
    /**
     * Builds an instance of controler.
     * @param host The widget handled by this controler. It should implement the TestQueryResultDisplayerHost interface
     * to handle the results of test queries.
     */
    constructor(host) {
        /** The underlying service used to perform the test queries. */
        this._testQueryService = new TestQueryService();
        /** Subscription for the response data. */
        this._subscription = null;
        /** Authentication service. */
        this._authService = new AuthService();
        (this.host = host).addController(this);
        this._testQueryService = new TestQueryService();
    }
    /**
     * ReactiveController method.
     */
    hostConnected() {
        this._subscription = this._testQueryService.responseData$.subscribe(data => this.host.notifyTestQueryResponse(data));
    }
    /**
     * ReactiveController method.
     */
    hostDisconnected() {
        if (this._subscription) {
            this._subscription.unsubscribe();
            this._subscription = null;
        }
    }
    /**
     * Performs an authenticated query (i.e.: with jwt).
     * @returns The result of the query.
     */
    performAuthenticatedQuery() {
        return this._testQueryService.performAuthenticatedQuery();
    }
    /**
     * Performs an unauthenticated query (i.e.: with jwt).
     * @returns The result of the query.
     */
    performUnauthenticatedQuery() {
        return this._testQueryService.performUnauthenticatedQuery();
    }
    /**
     * Observable for the authentication status.
     * @return An observable of the authentication status.
     */
    get authenticated$() {
        return this._authService.authenticated$;
    }
}

/**
 * Login / logout button.
 * @date 25/01/2024 - 16:13:49
 * @author A. Deman
 *
 * @export {AuthButton}
 * @class AuthButton
 * @type {AuthButton}
 * @extends {LitElement}
 */
let AuthButton = class AuthButton extends s$1 {
    constructor() {
        super(...arguments);
        /** Logger for this instance. */
        this._logger = new LoggingManager().getLogger('AuthButton');
        /** Controller associated to this UI element */
        this._authController = new AuthController(this);
        /** Subscription to authenticated status Observable. */
        this._subscription = null;
        /** Initialization flag. */
        this._initialized = false;
        /** Authenticated flag. */
        this._authenticated = false;
    }
    /**
     * Logout callback.
     */
    _onLogout() {
        console.log('AuthButton _onLogout');
        this._authController.logout();
    }
    /**
     * Loggin callback.
     */
    _onLogin() {
        console.log('AuthButton _onLogin');
        this._authController.login();
    }
    /**
     * Lit callback.
     */
    connectedCallback() {
        super.connectedCallback();
        if (!this._subscription) {
            this._subscription = this._authController.authenticated$.pipe(tap(authenticated => this._logger
                .enter('connectedCallback')
                .debug('AuthButton authenticated ', authenticated)
                .leave())).subscribe(authenticated => {
                this.authenticated = authenticated;
                this.initialized = true;
                this._logger.enter('connectedCallback').debug('this.authenticated', this.authenticated, 'initialized', this.initialized);
            });
        }
    }
    /**
     * Lit callback.
     */
    disconnectedCallback() {
        console.log('AuthButton disconnectedCallback');
        super.disconnectedCallback();
        if (this._subscription) {
            this._subscription.unsubscribe();
            this._subscription = null;
        }
    }
    /**
     * Lit callback.
     */
    render() {
        console.log('AuthButton render');
        this._logger.enter('render').debug('this_initialized', this._initialized);
        if (this._initialized) {
            console.log('AuthButton Render');
            return this.authenticated ? x `<button @click="${this._onLogout}">logout</button>` : x `<button @click="${this._onLogin}">login</button>`;
        }
    }
    get initialized() {
        return this._initialized;
    }
    set initialized(initialized) {
        this._logger.enter('set initialized').debug('initialized', initialized);
        if (!!initialized != !!this._initialized) {
            this._initialized = !!initialized;
            this._logger.debug('this._initialized', this._initialized);
            if (this._initialized) {
                this._logger.debug('beefore this.requestUpdate').leave();
                this.requestUpdate();
            }
        }
    }
    get authenticated() {
        return this._authenticated;
    }
    set authenticated(authenticated) {
        if (this._authenticated !== authenticated) {
            this._authenticated = authenticated;
        }
    }
};
AuthButton.styles = i$3 `
    :host {
      display: block;
      color: var(--auth-button-text-color, #000);
    }
    button {
      cursor: pointer;
     }
    `;
AuthButton = __decorate([
    t$1('auth-button')
], AuthButton);

/**
 * @license
 * Copyright 2020 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */const f$1=o=>void 0===o.strings;

/**
 * @license
 * Copyright 2017 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */
const t={ATTRIBUTE:1,CHILD:2,PROPERTY:3,BOOLEAN_ATTRIBUTE:4,EVENT:5,ELEMENT:6},e=t=>(...e)=>({_$litDirective$:t,values:e});class i{constructor(t){}get _$AU(){return this._$AM._$AU}_$AT(t,e,i){this._$Ct=t,this._$AM=e,this._$Ci=i;}_$AS(t,e){return this.update(t,e)}update(t,e){return this.render(...e)}}

/**
 * @license
 * Copyright 2017 Google LLC
 * SPDX-License-Identifier: BSD-3-Clause
 */const s=(i,t)=>{const e=i._$AN;if(void 0===e)return !1;for(const i of e)i._$AO?.(t,!1),s(i,t);return !0},o=i=>{let t,e;do{if(void 0===(t=i._$AM))break;e=t._$AN,e.delete(i),i=t;}while(0===e?.size)},r=i=>{for(let t;t=i._$AM;i=t){let e=t._$AN;if(void 0===e)t._$AN=e=new Set;else if(e.has(i))break;e.add(i),c(t);}};function h(i){void 0!==this._$AN?(o(this),this._$AM=i,r(this)):this._$AM=i;}function n(i,t=!1,e=0){const r=this._$AH,h=this._$AN;if(void 0!==h&&0!==h.size)if(t)if(Array.isArray(r))for(let i=e;i<r.length;i++)s(r[i],!1),o(r[i]);else null!=r&&(s(r,!1),o(r));else s(this,i);}const c=i=>{i.type==t.CHILD&&(i._$AP??=n,i._$AQ??=h);};class f extends i{constructor(){super(...arguments),this._$AN=void 0;}_$AT(i,t,e){super._$AT(i,t,e),r(this),this.isConnected=i._$AU;}_$AO(i,t=!0){i!==this.isConnected&&(this.isConnected=i,i?this.reconnected?.():this.disconnected?.()),t&&(s(this,i),o(this));}setValue(t){if(f$1(this._$Ct))this._$Ct._$AI(t,this);else {const i=[...this._$Ct._$AH];i[this._$Ci]=t,this._$Ct._$AI(i,this,0);}}disconnected(){}reconnected(){}}

/**
 * Directive to handle the disable attribute based on an Observable.
 * @date 01/02/2024 - 16:12:41
 * @author A. Deman
 *
 * @class ReactiveDisableAttributeDirective
 * @typedef {ReactiveDisableAttributeDirective}
 * @extends {AsyncDirective}
 */
class ReactiveDisableAttributeDirective extends f {
    /**
      * Creates an instance of ReactiveDisableAttributeDirective.
      * @date 01/02/2024 - 17:09:41
      *
      * @constructor
      * @param {PartInfo} partInfo The PartInfo attached to the directive.
      */
    constructor(partInfo) {
        super(partInfo);
        /** Logger for this instance. */
        this._logger = new NoopLogger();
        /** The underlying Observable. */
        this._observable = undefined;
        /** The subscription to the observable. */
        this._subscription = undefined;
        /** The last emitted value */
        this._value = false;
        /** The instance used to update the DOM.  */
        this._part = undefined;
        this._logger = new LoggingManager().getLogger('ReactiveDisableAttributeDirective');
        this._logger.trace('Constructor partInfo.type', partInfo.type, 'PartType.ATTRIBUTE', t.BOOLEAN_ATTRIBUTE);
        // Checks that the partInfo instance is associated to an element.
        if (partInfo.type !== t.ELEMENT) {
            this._logger.fatal('The directive ReactiveDisableAttributeDirective is not used correctly. It should be applyed to an element (e.g. <button>) not to an attribute.');
            throw new Error('The directive ReactiveDisableAttributeDirective shoud be applied to an element');
        }
    }
    /**
     * Lit method.
     * @param observable The underlying observable
     * @param reverse If true the attribute disabled is true if the emitted value is false.
     */
    render(observable, reverse) {
        this._logger.trace('ReactiveDisableAttributeDirective render');
        if (this._observable !== observable) {
            this._subscription?.unsubscribe();
            this._observable = observable;
            this._subscription = observable.pipe(distinctUntilChanged(), map(value => {
                this._logger.trace('In subscription value', value, 'reverse', reverse);
                return reverse ? !value : value;
            })).subscribe(value => {
                this._value = !!value;
                this._logger.trace('ReactiveDisableAttributeDirective render this._value', this._value, 'value', value);
                this._updateDOM();
            });
        }
        return w;
    }
    /**
     * Updates the DOM.
     */
    _updateDOM() {
        if (this.isConnected) {
            this._logger.trace('ReactiveDisableAttributeDirective _updateDOM this._part', this._part);
            this._logger.trace('ReactiveDisableAttributeDirective _updateDOM this._part?.element', this._part?.element);
            this._logger.trace('ReactiveDisableAttributeDirective _updateDOM this._value', this._value);
            if (!this._value) {
                this._logger.trace('ReactiveDisableAttributeDirective _updateDOM remove attribute');
                this._part?.element?.removeAttribute('disabled');
            }
            else if (this._part?.element?.getAttribute('disabled') !== 'true') {
                const value = this._part?.element?.getAttribute('disabled');
                this._logger.trace('ReactiveDisableAttributeDirective _updateDOM setAttribute disabled initial value', typeof value);
                this._logger.trace('ReactiveDisableAttributeDirective _updateDOM setAttribute disabled');
                this._part?.element?.setAttribute('disabled', 'true');
            }
        }
    }
    /**
     *
     * @param part The AttributePart associated to the directive that can be used to update the DOM.
     */
    update(part, props) {
        this._logger.trace('ReactiveDisableAttributeDirective this.update part', part.element);
        this._logger.trace('ReactiveDisableAttributeDirective this.update this._value', this._value);
        this._part = part;
        this._updateDOM();
        //part?.element?.setAttribute('disabled', String(!this._value));
        this._logger.trace('ReactiveDisableAttributeDirective super.update');
        super.update(part, props);
    }
    disconnected() {
        this._logger.trace('ReactiveDisableAttributeDirective disconnected');
        this._subscription?.unsubscribe();
        this._subscription = undefined;
    }
    reconnected() {
        this._logger.trace('ReactiveDisableAttributeDirective reconnected');
        this._subscription?.unsubscribe();
    }
}
const rxDisable = e(ReactiveDisableAttributeDirective);

/**
 * Query tester to check oidc integration.
 * @date 29/01/2024 - 14:07:04
 * @author A. Deman.
 *
 * @export {QueryTester}
 * @class QueryTester
 * @type {QueryTester}
 * @extends {LitElement}
 */
let QueryTester = class QueryTester extends s$1 {
    constructor() {
        super(...arguments);
        /** The controler associated to this widget. */
        this._testQueryController = new TestQueryController(this);
        // get initialized(): boolean {
        //   return this._initialized;
        // }
        // set initialized(initialized: boolean) {
        //   if (!!initialized != !!this._initialized) {
        //     this._initialized = !!initialized;
        //     if (this._initialized) {
        //       this.requestUpdate();
        //     }
        //   }
        // }
        // get authenticated(): boolean {
        //   return this._authenticated
        // }
        // set authenticated(authenticated: boolean) {
        //   if (this._authenticated !== authenticated) {
        //     this._authenticated = authenticated;
        //   }
        // }
    }
    /**
     * Triggers an authenticated test query.
     */
    _onTestAuthenticatedQuery() {
        console.log('QueryTester _onTestAuthenticatedQuery');
        this._testQueryController.performAuthenticatedQuery();
    }
    /**
     * Triggers an unauthenticated test query.
     */
    _onTestUnauthenticatedQuery() {
        console.log('QueryTester _onTestUnauthenticatedQuery');
        this._testQueryController.performUnauthenticatedQuery();
    }
    /**
     * Notification for a new test query result.
     * @param data The response data to handle.
     */
    notifyTestQueryResponse(data) {
        console.log('QueryTester notifyQueryResponse data', data);
        this._responseData = data;
        this.requestUpdate();
    }
    connectedCallback() {
        console.log('QueryTester connectedCallback');
        super.connectedCallback();
    }
    disconnectedCallback() {
        console.log('QueryTester disconnectedCallback');
        super.disconnectedCallback();
    }
    render() {
        console.log('ObserveDirective QueryTester Render');
        const queryFragment = x `
      <div>
        <button @click="${this._onTestAuthenticatedQuery}"  ${rxDisable(this._testQueryController.authenticated$, true)} >Test query with jwt</button>
        <button @click="${this._onTestUnauthenticatedQuery}">Test query without jwt</button>
      </div>`;
        const responseFragment = this._responseData ? x `
       <div>
        ${JSON.stringify(this._responseData)}
      </div> 
      ` : '';
        return x `
     <br/>
      
     <br/>
      ${queryFragment}
      <!-- <div>
        QT
        <button @click="${this._onTestAuthenticatedQuery}">Test query with jwt</button>
        <button @click="${this._onTestUnauthenticatedQuery}">Test query without jwt</button>
      </div> -->
     ${responseFragment}
     <br/>
     
        `;
    }
};
QueryTester.styles = i$3 `
    :host {
      display: block;
      color: var(--query-tester-text-color, #000);
    }
    button:not(:disabled) {
      cursor: pointer;
     }
    `;
QueryTester = __decorate([
    t$1('query-tester')
], QueryTester);

/**
 * Display the user information.
 * @date 01/02/2024 - 16:46:26
 * @author A. Deman
 *
 * @export
 * @class UserProfilePanel
 * @typedef {UserProfilePanel}
 * @extends {LitElement}
 */
let UserProfilePanel = class UserProfilePanel extends s$1 {
    constructor() {
        super(...arguments);
        /** Controller associated to this UI component. */
        this._userProfileController = new UserProfileController(this);
        /** Subscription to the user profile observable. */
        this._subscription = null;
        /** Initialization flag. */
        this._initialized = false;
        /** User profile instance. */
        this._userProfile = null;
    }
    /**
     * Lit connected callback
     * @date 01/02/2024 - 16:49:10
     */
    connectedCallback() {
        console.log('UserProfilePanel connectedCallback');
        super.connectedCallback();
        if (!this._subscription) {
            this._subscription = this._userProfileController.profile$.pipe(tap(authenticationData => console.log('UserProfilePanel  authenticationData', authenticationData))).subscribe(userProfile => {
                this.initialized = true;
                this._userProfile = userProfile;
            });
        }
    }
    /**
     * Lit disconnected callback.
     * @date 01/02/2024 - 16:49:28
     */
    disconnectedCallback() {
        console.log('UserProfilePanel disconnectedCallback');
        if (this._subscription) {
            this._subscription.unsubscribe();
            this._subscription = null;
        }
    }
    /**
     * Lit render method.
     * @date 01/02/2024 - 16:49:57
     *
     * @returns {*}
     */
    render() {
        console.log('UserProfilePanel Render _initialized', this._initialized);
        if (this._initialized) {
            console.log('UserProfilePanel Render');
            return x `<div>${this._userProfile ? this._userProfile.givenName : 'Not authenticated'}</div>`;
        }
    }
    get initialized() {
        return this._initialized;
    }
    set initialized(initialized) {
        if (!!initialized != !!this._initialized) {
            this._initialized = !!initialized;
            if (this._initialized) {
                this.requestUpdate();
            }
        }
    }
};
UserProfilePanel.styles = i$3 `
   :host {  
      display: flex;
      align-items: center;
      color: #474747;
  `;
UserProfilePanel = __decorate([
    t$1('user-profile-panel')
], UserProfilePanel);

/**
 * Web component for the authentication.
 * As the root of this web component it handles the settings initialization.
 * @date 01/02/2024 - 16:42:10
 * @author A. Deman.
 *
 * @export
 * @class AuthenticationWebcomp
 * @type {AuthenticationWebcomp}
 * @extends {LitElement}
 */
let AuthenticationWebcomp = class AuthenticationWebcomp extends s$1 {
    /**
     * Render method.
     * @date 01/02/2024 - 16:42:57
     *
     * @returns {*}
     */
    render() {
        this.logger.enter('render').debug('before render').leave();
        return x `
    <div class="main-container">
      <user-profile-panel></user-profile-panel>
      <auth-button></auth-button>
    </div>
    `;
    }
    get logger() {
        if (!this._logger) {
            this._logger = new LoggingManager().getLogger('AuthenticationWebcomp');
        }
        return this._logger;
    }
    set logger(logger) {
        this._logger = logger;
    }
};
AuthenticationWebcomp.styles = i$3 `
      .main-container {
      display:flex;
      gap: 1em;
      padding: 1em;
    }
    `;
__decorate([
    n$1({
        attribute: false,
        hasChanged: (newVal, oldVal) => {
            if (newVal === oldVal) {
                return false;
            }
            new AuthSettingsService().update(newVal);
            return true;
        }
    })
], AuthenticationWebcomp.prototype, "settings", void 0);
AuthenticationWebcomp = __decorate([
    t$1('authentication-webcomp')
], AuthenticationWebcomp);

/**
 * Default settings for the authentication.
 * storage key for the jwt and end points: login, logout, etc.
 * @date 01/02/2024 - 16:41:21
 * @author A. Deman.
 *
 * @type {AuthSettings}
 */
const DEFAULT_AUTH_SETTINGS = {
    jwtStorageKey: 'avenirs-jwt',
    routes: {
        local: {
            login: 'https://localhost/cas/oidc/oidcAuthorize?client_id=APIMClientId&redirect_uri=https://localhost/node-api/cas-auth-callback&response_type=code&scope=openid%20email%20profile',
            logout: 'https://localhost/cas/oidc/oidcLogout?service=https://localhost/node-api/cas-auth-callback',
            validation: 'http://localhost/node-api/cas-auth-validate',
            test: 'http://localhost/apisix-gw/ipoidc'
        },
        dev: {
            login: 'https://srv-dev-avenir.srv-avenir.brgm.recia.net/cas/oidc/oidcAuthorize?client_id=APIMClientId&redirect_uri=https://srv-dev-avenir.srv-avenir.brgm.recia.net/node-api/cas-auth-callback&response_type=code&scope=openid%20email%20profile',
            logout: 'https://srv-dev-avenir.srv-avenir.brgm.recia.net/cas/oidc/oidcLogout?service=https://srv-dev-avenir.srv-avenir.brgm.recia.net/node-api/cas-auth-callback',
            validation: 'https://srv-dev-avenir.srv-avenir.brgm.recia.net/node-api/cas-auth-validate',
            test: 'http://srv-dev-avenir.srv-avenir.brgm.recia.net/apisix-gw/ipoidc'
        },
        prod: {
            login: '',
            logout: '',
            validation: ''
        },
    },
    logging: {
        ...DEFAULT_LOGGING_SETTINGS,
        levels: {
            ...DEFAULT_LOGGING_SETTINGS.levels,
            default: LogLevel.trace
        }
    }
};

export { AuthButton, AuthenticationWebcomp, n$4 as CSSResult, DEFAULT_AUTH_SETTINGS, s$1 as LitElement, QueryTester, b$1 as ReactiveElement, UserProfilePanel, o$3 as _$LE, z as _$LH, S$1 as adoptStyles, i$3 as css, u$1 as defaultConverter, c$3 as getCompatibleStyle, x as html, o$2 as isServer, w as noChange, f$3 as notEqual, T as nothing, j as render, e$3 as supportsAdoptingStyleSheets, b as svg, r$5 as unsafeCSS };
