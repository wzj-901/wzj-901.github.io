const CACHE_NAME = 'my-app-cache';
const urlsToCache = [
  '/',
  '/index.html',
  '/supabase.js',
  '/icon.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(urlsToCache);
    })
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.url.includes('supabase.co')) {
    return event.respondWith(fetch(event.request));
  }
  event.respondWith(
    caches.match(event.request).then((response) => response || fetch(event.request))
  );
});