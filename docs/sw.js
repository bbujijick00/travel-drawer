// Network-first service worker: always tries to fetch the latest file from
// the network first, and only falls back to the cache when offline. This
// exists specifically so the "Add to Home Screen" standalone app doesn't get
// stuck showing an old cached version after an update is deployed.
var CACHE = "travel-drawer-v1";

self.addEventListener("install", function(e){
  self.skipWaiting();
});

self.addEventListener("activate", function(e){
  e.waitUntil(self.clients.claim());
});

self.addEventListener("fetch", function(e){
  if (e.request.method !== "GET") return;
  e.respondWith(
    fetch(e.request, {cache:"no-store"}).then(function(res){
      var copy = res.clone();
      caches.open(CACHE).then(function(c){ c.put(e.request, copy); });
      return res;
    }).catch(function(){
      return caches.match(e.request);
    })
  );
});
