// web/service_worker.js
const CACHE_NAME = 'kerudos-cache-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  '/manifest.json',
];

// Instalación del Service Worker y cacheo de los archivos esenciales
self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function(cache) {
      console.log('Cache abierta');
      return cache.addAll(urlsToCache);
    })
  );
});

// Intercepta las solicitudes de red y responde desde la cache o red
self.addEventListener('fetch', function(event) {
  event.respondWith(
    caches.match(event.request).then(function(response) {
      // Si está en cache, devolver la respuesta cacheada
      if (response) {
        return response;
      }

      // Si no está en cache, realizar la solicitud de red y cachear la respuesta
      return fetch(event.request).then(function(networkResponse) {
        if (!networkResponse || networkResponse.status !== 200) {
          return networkResponse;
        }

        // Almacenar en la cache la nueva respuesta de la red
        return caches.open(CACHE_NAME).then(function(cache) {
          cache.put(event.request, networkResponse.clone());
          return networkResponse;
        });
      });
    })
  );
});

// Limpiar caches antiguas y activar el nuevo Service Worker
self.addEventListener('activate', function(event) {
  const cacheWhitelist = [CACHE_NAME];

  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.map(function(cacheName) {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            console.log('Eliminando cache antigua:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );

  // Activar el Service Worker de inmediato en todas las pestañas
  return self.clients.claim();
});
