const CACHE_NAME = "food4less-cache-v1";
const urlsToCache = [
  "/",
  "/manifest.json",
  "/assets/application-f5b19ed0.css",
  "/icons/icon-192x192.png",
  "/icons/icon-512x512.png",
  // Removed slick.woff, slick.ttf, ajax-loader.gif because they do not exist
];

// Installing the Service Worker
self.addEventListener("install", (event) => {
  console.log("👍 Service Worker installed");
  event.waitUntil(
    (async () => {
      const cache = await caches.open(CACHE_NAME);
      await Promise.all(
        urlsToCache.map(async (url) => {
          try {
            const res = await fetch(url, { cache: "reload" }).catch((err) => {
              console.warn("❌ Network error while fetching", url, err);
              return null;
            });
            if (res && res.ok) {
              await cache.put(url, res);
            } else if (res) {
              console.warn("❌ Failed to fetch", url, res.status);
            }
          } catch (err) {
            console.warn("❌ Could not cache", url, err);
          }
        })
      );
    })()
  );
});

// Activating the Service Worker
self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME) {
            return caches.delete(cache);
          }
        })
      );
      })
    );
  });
