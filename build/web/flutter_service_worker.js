'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "ea0e07f6a46573e55d89633c5456c10b",
"version.json": "07adb36add9c276c092acf9b5c2a8d14",
"index.html": "6e5461294a6860f59d6cfbd18b62c8fe",
"/": "6e5461294a6860f59d6cfbd18b62c8fe",
"main.dart.js": "9ee7909e1c172be226c1dd85bdb11080",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"logo.png": "d844100f2d49dbc597818c4fd98c9330",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "dbd4025da782ced1cd732bf9c0225601",
"sitemap.xml": "c42e7f15c3a22cbe60abfa3f624d9366",
"robots.txt": "0a7660135e10de97c10c47c72a03ac6c",
"assets/dealership_video.mp4": "a77cf619b4a69bc0a6503fd6f6494b4a",
"assets/NOTICES": "2e6907ecb1528546907b0490458986e2",
"assets/FontManifest.json": "c75f7af11fb9919e042ad2ee704db319",
"assets/AssetManifest.bin.json": "cffd6fffe26799595e10f5fa774a183f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "86a8d5ed42add1f617cb39988d2354eb",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/AssetManifest.bin": "a0428e8596a66785f7cce063b7a6780d",
"assets/fonts/MaterialIcons-Regular.otf": "6b6b2fc7d78f11f7d3efde9ec65b0247",
"assets/assets/images/service_diagnostics.png": "9b804660fbc38c931bea77032b97f80c",
"assets/assets/images/ckd2.jpeg": "aeea55ffd4c0e745e607dce6aa4f088e",
"assets/assets/images/about_impact.png": "38d34ef050970ff5656b2d6d708d8d10",
"assets/assets/images/about_hero.png": "138be4c6362239f1140a0edbd2f3e38c",
"assets/assets/images/brand_ola_new.png": "d0d586cb1f27b2324bd35681c9578073",
"assets/assets/images/why_fixx_ev.png": "cea4083e367ab64ab1a58055c980cb15",
"assets/assets/images/franchise_service.png": "16967bdbe44d3be7d3bc44812b00d8c5",
"assets/assets/images/service_battery.png": "dde2956411303f02ae7234a36171d9b7",
"assets/assets/images/fixx_community_v3.png": "9ac1f3f7702cc00727c27b76f3d3302d",
"assets/assets/images/fixx_community_v2.png": "6611886b2baae61cdd81cebf733377ea",
"assets/assets/images/service_repair.png": "f16f81cc7000f071c2022649c2f65d48",
"assets/assets/images/about_infrastructure.png": "8da5f3b155152ace9fa471e6197db950",
"assets/assets/images/your_ev_brand_v3.png": "ac0af483b57cf8906c7bf40b93b792e1",
"assets/assets/images/service_roadside.png": "abaa4141931232d748e2afc8d068dcac",
"assets/assets/images/franchise_mission.png": "1a91c435b37f5193f8884563f05f256c",
"assets/assets/images/brand_ola.png": "98b3d8f3a52e02eb2201c89ac5c81cbe",
"assets/assets/images/your_ev_brand_v2.png": "05dd5b1b2ea06a59566a61569c6a3755",
"assets/assets/images/franchise_parts.png": "a40cd06988c93112cf096a7414a25d76",
"assets/assets/images/your_ev_brand.png": "1a26584f764990a098094a85029193f6",
"assets/assets/images/fixx_community.png": "82fa0a3cb377e4ed86fe9f6141924889",
"assets/assets/images/urban_s.png": "8eed380ed330e2d00638b97f685c8023",
"assets/assets/images/brand_tvs.png": "3058f23682a206a36e46808ec2049201",
"assets/assets/images/service_motor_repair.png": "6149404aa57803b3e45fd1fa1b82f36f",
"assets/assets/images/why_fixx_ev_v3.png": "cf878f2ea8c4d2e09e967d3691f911f9",
"assets/assets/images/metro_glide.png": "619ef7c4d832d8c6b7fc5c3cbe537ef0",
"assets/assets/images/service_maintenance_new.png": "9ac2ee43f329bb4d2f51c88e9e6269a7",
"assets/assets/images/why_fixx_ev_v2.png": "9c8f93d11e23a6e7426cd8ca172786bd",
"assets/assets/images/vector_x.png": "7847dd00828bb4b5d9aefd0550e23316",
"assets/assets/images/c12.jpg": "7041b4f2adcdf96af7ed8a99c42682e9",
"assets/assets/images/brand_bajaj.png": "ecd5e67ecb7d821e833ae8793c1fcee4",
"assets/assets/images/c13.jpg": "ebecd6488209c26859476f48ccfc4461",
"assets/assets/images/c11.png": "33b55d077542384e5a2cccb16f45f09a",
"assets/assets/images/c14_v2.png": "f05298536e924f80afa554e3604425a3",
"assets/assets/images/whatsapp_icon.jpg": "c952bbe5455aaf272b31e6521e61fa2d",
"assets/assets/images/c14.jpg": "dc38c74bad7ad36c6221e064e1efd719",
"assets/assets/images/about_growth.png": "715f3fd0c5c29323ecdef5cb37bf8c00",
"assets/assets/images/ckd1.jpeg": "573bbca9780efadccfd22e8601a19f88",
"assets/assets/images/service_warranty.png": "555344a2a31c46c7a83b7284bf84b968",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
