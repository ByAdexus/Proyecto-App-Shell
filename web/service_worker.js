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

      // Si no está en cache, realizar la solicitud de red
      return fetch(event.request).then(function(networkResponse) {
        if (!networkResponse || networkResponse.status !== 200) {
          return networkResponse; // Si la respuesta no es 200, devolver la respuesta de red
        }

        // Almacenar en la cache la nueva respuesta de la red, solo si es un GET
        if (event.request.method === 'GET') {
          return caches.open(CACHE_NAME).then(function(cache) {
            cache.put(event.request, networkResponse.clone());
            return networkResponse;
          });
        } else {
          return networkResponse; // Si no es un GET, simplemente devolver la respuesta
        }
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

// Sincronizar likes pendientes cuando haya conexión
self.addEventListener('sync', event => {
  if (event.tag === 'sync-likes') {
    event.waitUntil(syncLikes());
  }
});

// Función para sincronizar likes pendientes
async function syncLikes() {
  const pendingLikes = JSON.parse(localStorage.getItem('pendingLikes')) || [];

  for (const likeAction of pendingLikes) {
    const { postId, likes } = likeAction;
    await fetch(`https://red-social-961f9-default-rtdb.firebaseio.com/posts/${postId}.json`, {
      method: 'PATCH',
      body: JSON.stringify({ likes: likes }),
      headers: {
        'Content-Type': 'application/json'
      }
    });
  }
  // Limpiar likes pendientes después de sincronizar
  localStorage.removeItem('pendingLikes');
}
